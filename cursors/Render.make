#!/usr/bin/env make

PROJECT := Vinyl
BUILDDIR := $(CURDIR)/build

clean:
	@rm -rf $(CURDIR)/build/pngs

clean-%: clean
	@rm -rf $(CURDIR)/$(PROJECT)-$(shell echo $* | sed 's/[^ _-]*/\u&/g;s/[^ _-]*/\u&/g')

render-%: clean-%
	@$(CURDIR)/svgslice.py $(CURDIR)/src/svgs/template-$*.svg

make-%: render-%
	name=$(PROJECT)-$(shell echo $* | sed -e 's/[^ _-]*/\u&/g'); \
	dir=$(PROJECT)-$(shell echo $* | sed -e 's/[^ _-]*/\u&/g;s/[^A-Za-z0-9_-]/-/g'); \
	mkdir -p  $(BUILDDIR)/$${dir}/cursors; \
	echo -e "[Icon Theme]\nName=$${name}" > $(BUILDDIR)/$${dir}/index.theme; \
	cp -a $(CURDIR)/src/hotspots $(BUILDDIR)/; \
	cd $(BUILDDIR)/hotspots; \
	for f in *.in; do \
		xcursorgen "$${f}" $(BUILDDIR)/$${dir}/cursors/"$${f%.in}" ; \
	done; \
	cd $(BUILDDIR)/$${dir}/cursors; \
	grep -vE "^#" $(CURDIR)/src/links.in | xargs -n2 ln -sfv

black: make-black
white: make-white

#vim: syntax=Makefile
