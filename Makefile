SHELL := /bin/sh
PDFLATEX := pdflatex
TAR := gtar -c -z --owner=root --group=root --mode='a+r'
RM := rm -rf
INSTALL := install
INSTALLDIR := $(INSTALL) -d
INSTALLDATA := $(INSTALL) -m 644

ifneq (,$(findstring install,$(MAKECMDGOALS)))
TEXMFDIR := $(shell kpsewhich -expand-var='$$TEXMFHOME')
endif

pkg := fontaxes
tempfiles := $(pkg).aux $(pkg).log $(pkg).toc $(pkg).out $(pkg).hd test-$(pkg).aux test-$(pkg).log test-$(pkg).toc test-$(pkg).out

# default rule

.PHONY: all
all: latex

# rules for building the LaTeX package

.PHONY: latex
latex: $(pkg).sty

$(pkg).sty test-$(pkg).tex: $(pkg).ins $(pkg).dtx
	$(PDFLATEX) $(pkg).ins

# rules for building the documentation

.PHONY: doc
doc: $(pkg).pdf

$(pkg).pdf: $(pkg).dtx
	$(PDFLATEX) $(pkg).dtx
	(while grep -s 'Rerun to get' $(pkg).log; do \
	  $(PDFLATEX) $(pkg).dtx; \
	done)

# rules for building the test document

.PHONY: test
test: test-$(pkg).pdf

test-$(pkg).pdf: test-$(pkg).tex
	$(PDFLATEX) test-$(pkg).tex

# rules for building a distribution tarball

.PHONY: dist
dist: $(pkg).tar.gz

$(pkg).tar.gz: $(pkg).ins $(pkg).dtx $(pkg).pdf README.ctan
	$(TAR) --transform 's,^,$(pkg)/,g' --transform 's,README\.ctan,README,' $^ > $@

# rules for (un)installing everything

.PHONY: installl
install: all
	$(INSTALLDIR) $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDATA) $(pkg).sty $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDATA) $(pkg).pdf test-$(pkg).tex $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/source/latex/$(pkg)
	$(INSTALLDATA) $(pkg).ins $(pkg).dtx $(TEXMFDIR)/source/latex/$(pkg)

.PHONY: uninstall
uninstall:
	$(RM) $(TEXMFDIR)/tex/latex/$(pkg)
	$(RM) $(TEXMFDIR)/doc/latex/$(pkg)
	$(RM) $(TEXMFDIR)/source/latex/$(pkg)

# rule for cleaning the source tree

.PHONY: clean
clean:
	$(RM) $(pkg).sty test-$(pkg).tex test-$(pkg).pdf $(pkg).tar.gz
	$(RM) $(tempfiles)

# delete files on error

.DELETE_ON_ERROR:
