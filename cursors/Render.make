#!/usr/bin/env make

PROJECT := Vinyl
BUILDDIR := $(CURDIR)/build

clean:
	@rm -rf $(BUILDDIR)/pngs

clean-%: clean
	@rm -rf $(CURDIR)/$(PROJECT)-$(shell echo $* | sed 's/[^ _-]*/\u&/g;s/[^ _-]*/\u&/g')

render-%: clean-%
	@sizes="24 32 48"; \
	for s in $${sizes}; do \
		$(CURDIR)/svgslice.py $(CURDIR)/src/svgs/template-$*.svg \
			-v -s $${s}x$${s} \
			-o $(BUILDDIR)/pngs/$${s}; \
	done;

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
	grep -vE "^#" $(CURDIR)/src/links.in | while read c l; do \
		echo Making cursor link: $(BUILDDIR)/$${dir}/cursors/$${l} -\> $${c} && \
		ln -sf $${c} $${l}; \
	done

black: make-black
white: make-white

#vim: syntax=Makefile
