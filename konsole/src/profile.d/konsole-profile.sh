#!/bin/bash

__which() {
    /usr/bin/which "${1}" 2> /dev/null \
    || echo "${1}${KDE_SESSION_VERSION}"
}

_get_color_scheme() {
    # Reads the current color-scheme from user settings
    ${__kreadconfig} \
        --file ~/.config/kdeglobals \
        --group General \
        --key ColorScheme
}

_get_window_background_color() {
    local _colorScheme="${1}"

    local _colorSchemeDir="/usr/share/color-schemes"
    if [ -f "~/.local/share/color-schemes/${_colorScheme}.colors" ]; then
        _colorSchemeDir="~/.local/share/color-schemes"
    elif [ -f "/usr/local/share/color-schemes/${_colorScheme}.colors" ]; then
	_colorSchemeDir="/usr/local/share/color-schemes"
    fi

    # Reads the window background color from colorscheme file
    ${__kreadconfig} \
        --file ${_colorSchemeDir}/${_colorScheme}.colors \
        --group Colors:Window \
        --key BackgroundNormal
}

# Determines if the color is light or dark
_is_light_or_dark() {
    # Receives the color in the format red,green,blue[,alpha]
    color=${1:-0,0,0}
    # Splits the values of red, green, and blue
    IFS=',' read -r r g b _ <<< "${color}"
    
    # Trims whitespace from the values
    r=${r// /}
    g=${g// /}
    b=${b// /}
    
    # Calculates the luminance using integer arithmetic
    luminance=$(( (2126 * ${r} + 7152 * ${g} + 722 * ${b}) / 10000 ))

    # Outputs "light" or "dark" based on luminance
    output="dark"
    if (( ${luminance} > 128 )); then
        output="light"
    fi
    echo ${output}
}

__kreadconfig=$(__which kreadconfig)
__konsoleprofile=$(__which konsoleprofile)


if [ "${XDG_CURRENT_DESKTOP}" == "KDE" ]; then
    colorScheme=$(_get_color_scheme)
    colorBackground=$(_get_window_background_color ${colorScheme})

    case $(_is_light_or_dark ${colorBackground}) in
         dark) konsoleColorScheme=Vinyl-Dark ;;
        light) konsoleColorScheme=Vinyl-Light ;;
            *) konsoleColorScheme=Vinyl-Dark ;;
    esac

   ${__konsoleprofile} \
        ColorScheme="${konsoleColorScheme:-system}"
fi
