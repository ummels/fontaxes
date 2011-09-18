SHELL := /bin/sh
PDFLATEX := pdflatex
TAR := tar
RM := rm -rf
INSTALL := install
INSTALLDIR := $(INSTALL) -d
INSTALLDATA := $(INSTALL) -m 644

ifneq (,$(findstring install,$(MAKECMDGOALS)))
TEXMFDIR := $(shell kpsewhich -expand-var='$$TEXMFHOME')
endif

pkg := fontaxes
tempfiles := $(pkg).aux $(pkg).log $(pkg).toc $(pkg).out

# default rule

.PHONY: all
all: latex

# rules for building the LaTeX package

.PHONY: latex
latex: $(pkg).sty test-$(pkg).tex

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

# rules for building a tarball for CTAN

.PHONY: ctan
ctan: $(pkg).tar.gz

$(pkg).tar.gz: $(pkg).ins $(pkg).dtx $(pkg).pdf README.ctan
	$(TAR) -cz -s '/README\.ctan/README/' $^ > $@

# rules for (un)installing everything

.PHONY: installl
install: all
	$(INSTALLDIR) $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDATA) $(pkg).sty $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDATA) $(pkg).pdf test-$(pkg).tex $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/source/latex/$(pkg)
	$(INSTALLDATA) latex/$(pkg).ins latex/$(pkg).dtx $(TEXMFDIR)/source/latex/$(pkg)

.PHONY: uninstall
uninstall:
	$(RM) $(TEXMFDIR)/tex/latex/$(pkg)
	$(RM) $(TEXMFDIR)/doc/latex/$(pkg)
	$(RM) $(TEXMFDIR)/source/latex/$(pkg)

# rule for cleaning the source tree

.PHONY: clean
clean:
	$(RM) $(pkg).sty test-$(pkg).tex $(pkg).tar.gz
	$(RM) $(tempfiles)

# delete files on error

.DELETE_ON_ERROR:
