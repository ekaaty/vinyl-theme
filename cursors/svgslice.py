#!/usr/bin/env python3
#
# SVGSlice
#
# Released under the GNU General Public License, version 2.
# Email Lee Braiden of Digital Unleashed at lee.b@digitalunleashed.com
# with any questions, suggestions, patches, or general uncertainties
# regarding this software.

usageMsg = """You need to add a layer called "slices", and draw rectangles on it to
represent the areas that should be saved as slices. It helps when drawing these
rectangles if you make them translucent.

If you name these slices using the "id" field of Inkscape's built-in XML editor,
that name will be reflected in the slice filenames.

Please remember to HIDE the slices layer before exporting, so that the
rectangles themselves are not drawn in the final image slices."""

# How it works:
#
# Basically, svgslice parses an SVG file, looking for the tags that define
# the slices, and saves them in a list of rectangles. Next, it modifies the
# SVG's viewBox to crop each slice individually and then uses cairosvg
# to render the cropped SVG to a PNG file.
#
# This approach avoids the overhead of a full GUI application and provides a
# fast, scriptable way to export icons from a single source file.

import os
import sys
import shutil
import cairosvg
from lxml import etree
from optparse import OptionParser
from xml.sax import saxutils, make_parser, SAXParseException, handler
from xml.sax.handler import feature_namespaces

optParser = OptionParser()
optParser.add_option('-d', '--debug', action='store_true', dest='debug',
                     help='Enable extra debugging info.')
optParser.add_option('-o', '--outputdir', action='store', dest='outputdir',
                     help='Specifies the output directory for generated slice files.')
optParser.add_option('-p', '--sliceprefix', action='store', dest='sliceprefix',
                     help='Specifies the prefix to use for individual slice filenames.')
optParser.add_option('-s', '--size', action='store', dest='size',
                     help='Size of the slices in format [width]x[height].')
optParser.add_option('-v', '--verbose', action='store_true', dest='verbose',
                     help='Enable the verbose output.')

svgFilename = None

def verb(msg):
    if options.verbose:
        print(msg)

def dbg(msg):
    if options.debug:
        sys.stderr.write(msg)

def cleanup():
    if svgFilename != None and os.path.exists(svgFilename):
        os.unlink(svgFilename)

def fatalError(msg):
    sys.stderr.write(msg)
    cleanup()
    sys.exit(20)


class SVGRect:
    """Manages a simple rectangular area, along with certain attributes
    such as a name"""
    def __init__(self, x1, y1, x2, y2, name=None):
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.name = name
        dbg("New SVGRect: (%s)\n" % name)

    def renderFromSVG(self, svgFName, sliceFName):
        #output_dir = os.path.realpath('./build/pngs')
        output_dir = os.path.realpath(options.outputdir)

        # Coordinates and dimensions of the slice rectangle
        x_coord = self.x1
        y_coord = self.y1
        slice_width = self.x2 - self.x1
        slice_height = self.y2 - self.y1

        # Read the original SVG file once
        parser = etree.XMLParser()
        original_svg_tree = etree.parse(svgFName, parser)
        root = original_svg_tree.getroot()

        # Update the SVG's viewBox to crop it to the slice's area
        viewbox_value = f"{x_coord} {y_coord} {slice_width} {slice_height}"
        root.set("viewBox", viewbox_value)
        root.set("width", str(slice_width))
        root.set("height", str(slice_height))

        # Convert the modified SVG tree to a string in memory
        in_memory_svg = etree.tostring(original_svg_tree)

        if not os.path.exists(os.path.realpath(output_dir)):
            os.makedirs(os.path.realpath(output_dir))

        width, height = options.size.split('x')
        output_path = os.path.join(output_dir, sliceFName)
        verb("Rendering icon slice: %s" % output_path)

        try:
            # Use cairosvg to render the in-memory SVG string directly
            cairosvg.svg2png(
                bytestring=in_memory_svg,
                write_to=output_path,
                output_width=int(width),
                output_height=int(height)
            )
        except Exception as e:
            fatalError(f'ABORTING: cairosvg failed to render the slice. Error: {e}')


class SVGHandler(handler.ContentHandler):
    """Base class for SVG parsers"""
    def __init__(self):
        self.pageBounds = SVGRect(0, 0, 0, 0)

    def isFloat(self, stringVal):
        try:
            return (float(stringVal), True)[1]
        except (ValueError, TypeError):
            return False

    def parseCoordinates(self, val):
        """Strips the units from a coordinate, and returns just the value."""
        if val.endswith('px'):
            val = float(val.rstrip('px'))
        elif val.endswith('pt'):
            val = float(val.rstrip('pt'))
        elif val.endswith('cm'):
            val = float(val.rstrip('cm'))
        elif val.endswith('mm'):
            val = float(val.rstrip('mm'))
        elif val.endswith('in'):
            val = float(val.rstrip('in'))
        elif val.endswith('%'):
            val = float(val.rstrip('%'))
        elif self.isFloat(val):
            val = float(val)
        else:
            fatalError("Coordinate value %s has unrecognised units. Only px, pt, "
                       "cm, mm, and in units are currently supported." % val)
        return val

    def startElement_svg(self, name, attrs):
        """Callback hook which handles the start of an svg image"""
        dbg('startElement_svg called\n')
        width = attrs.get('width', None)
        height = attrs.get('height', None)
        self.pageBounds.x2 = self.parseCoordinates(width)
        self.pageBounds.y2 = self.parseCoordinates(height)

    def endElement(self, name):
        """General callback for the end of a tag"""
        dbg('Ending element "%s"\n' % name)


class SVGLayerHandler(SVGHandler):
    """Parses an SVG file, extracting slicing rectangles from a "slices" layer"""
    def __init__(self):
        SVGHandler.__init__(self)
        self.svg_rects = []
        self.layer_nests = 0

    def inSlicesLayer(self):
        return (self.layer_nests >= 1)

    def add(self, rect):
        """Adds the given rect to the list of rectangles successfully parsed"""
        self.svg_rects.append(rect)

    def startElement_layer(self, name, attrs):
        """Callback hook for parsing layer elements

        Checks to see if we're starting to parse a slices layer, and sets the
        appropriate flags. Otherwise, the layer will simply be ignored."""
        dbg('found layer: name="%s" id="%s"\n' % (name, attrs['id']))
        if attrs.get('inkscape:groupmode', None) == 'layer':
            if self.inSlicesLayer() or attrs['inkscape:label'] == 'slices':
                self.layer_nests += 1

    def endElement_layer(self, name):
        """Callback for leaving a layer in the SVG file

        Just undoes any flags set previously."""
        dbg('leaving layer: name="%s"\n' % name)
        if self.inSlicesLayer():
            self.layer_nests -= 1

    def startElement_rect(self, name, attrs):
        """Callback for parsing an SVG rectangle

        Checks if we're currently in a special "slices" layer using flags set
        by startElement_layer(). If we are, the current rectangle is considered
        to be a slice, and is added to the list of parsed rectangles. Otherwise,
        it will be ignored."""
        if self.inSlicesLayer():
            x1 = self.parseCoordinates(attrs['x'])
            y1 = self.parseCoordinates(attrs['y'])
            x2 = self.parseCoordinates(attrs['width']) + x1
            y2 = self.parseCoordinates(attrs['height']) + y1
            name = attrs['id']
            rect = SVGRect(x1, y1, x2, y2, name)
            self.add(rect)

    def startElement(self, name, attrs):
        """Generic hook for examining and/or parsing all SVG tags"""
        if options.debug:
            dbg('Beginning element "%s"\n' % name)
        if name == 'svg':
            self.startElement_svg(name, attrs)
        elif name == 'g':
            # inkscape layers are groups, I guess, hence 'g'
            self.startElement_layer(name, attrs)
        elif name == 'rect':
            self.startElement_rect(name, attrs)

    def endElement(self, name):
        """Generic hook called when the parser is leaving each SVG tag"""
        dbg('Ending element "%s"\n' % name)
        if name == 'g':
            self.endElement_layer(name)

    def generateXHTMLPage(self):
        """Generates an XHTML page for the SVG rectangles previously parsed."""
        write = sys.stdout.write
        write('<?xml version="1.0" encoding="UTF-8"?>\n')
        write('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" '
              '"DTD/xhtml1-strict.dtd">\n')
        write('<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" '
              'lang="en">\n')
        write('    <head>\n')
        write('        <title>Sample SVGSlice Output</title>\n')
        write('    </head>\n')
        write('    <body>\n')
        write('        <p>Sorry, SVGSlice\'s XHTML output is currently very basic. '
              'Hopefully, it will serve as a quick way to preview all generated '
              'slices in your browser, and perhaps as a starting point for '
              'further layout work. Feel free to write it and submit a patch '
              'to the author :)</p>\n')

        write('        <p>')
        for rect in self.svg_rects:
            write('            <img src="%s" alt="%s (please add real '
                  'alternative text for this image)" longdesc="Please add a '
                  'full description of this image" />\n' %
                  (sliceprefix + rect.name + '.png', rect.name))
        write('        </p>')

        write('<p><a href="http://validator.w3.org/check?uri=referer"><img '
              'src="http://www.w3.org/Icons/valid-xhtml10" alt="Valid XHTML 1.0!" '
              'height="31" width="88" /></a></p>')

        write('    </body>\n')
        write('</html>\n')


if __name__ == '__main__':
    # parse command line into arguments and options
    (options, args) = optParser.parse_args()

    if len(args) != 1:
        fatalError("\nCall me with the SVG as a parameter.\n\n")
    originalFilename = args[0]

    svgFilename = originalFilename + '.svg'
    shutil.copyfile(originalFilename, svgFilename)

    # setup program variables from command line (in other words, handle
    # non-option args)
    basename = os.path.splitext(svgFilename)[0]

    if options.sliceprefix:
        sliceprefix = options.sliceprefix
    else:
        sliceprefix = ''

    # initialise results before actually attempting to parse the SVG file
    svgBounds = SVGRect(0, 0, 0, 0)
    rectList = []

    # Try to parse the svg file
    xmlParser = make_parser()
    xmlParser.setFeature(feature_namespaces, 0)

    # setup XML Parser with an SVGLayerHandler class as a callback parser
    svgLayerHandler = SVGLayerHandler()
    xmlParser.setContentHandler(svgLayerHandler)
    try:
        xmlParser.parse(svgFilename)
    except SAXParseException as e:
        fatalError("Error parsing SVG file '%s': line %d, col %d: %s. This "
                   "probably indicates a bug that should be reported." %
                   (svgFilename, e.getLineNumber(), e.getColumnNumber(),
                    e.getMessage()))

    # verify that the svg file actually contained some rectangles.
    if len(svgLayerHandler.svg_rects) == 0:
        fatalError("""No slices were found in this SVG file. Please refer to
                   the documentation for guidance on how to use this SVGSlice.
                   As a quick summary:\n\n""" + usageMsg)
    else:
        dbg("Parsing successful.\n")

    #svgLayerHandler.generateXHTMLPage()

    # loop through each slice rectangle, and render a PNG image for it
    for rect in svgLayerHandler.svg_rects:
        sliceFName = sliceprefix + rect.name + '.png'

        dbg('Saving slice as: "%s"\n' % sliceFName)
        rect.renderFromSVG(svgFilename, sliceFName)

    cleanup()

    dbg('Slicing complete.\n')
