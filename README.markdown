fontaxes - Additional font axes for LaTeX
=========================================

The fontaxes package adds several new font axes on top of the New Font
Selection Scheme (NFSS). In particular, it splits the shape axis into
a primary and a secondary shape axis, and it adds three new axes to
deal with the different figure versions, offered by many professional fonts.

Usage
-----

To use this package, include

    \usepackage{fontaxes}

in the preamble of your LaTeX document. See the PDF documentation for details.

Installation
------------

To install the package and its documentation in your home texmf tree, run:

    make install

If you want to use a different texmf tree, you can specify it using the
variable TEXMFDIR:

    make install TEXMFDIR=/usr/local/texlive/texmf-local

Afterwards, you may need to regenerate the file database:

    texhash

License
-------

Copyright (c) 2007 by Andreas Bühmann
Copyright (c) 2011 by Michael Ummels <michael.ummels@rwth-aachen.de>

The LaTeX support files contained in this software may be distributed
and modified under the terms and conditions of the
[LaTeX Project Public License][LPPL], version 1.3c or greater (your choice).

[LPPL]: http://www.latex-project.org/lppl/

This work has the LPPL maintenance status `maintained'.

The Current Maintainer of this work is Michael Ummels.

This work consists of the files fontaxes.dtx, fontaxes.ins and
the derived files fontaxes.sty, test-fontaxes.tex and fontaxes.pdf.

All other files distributed with these sources are in the public domain.
