texfiles := *.tex chapters/*.tex
figfiles := figures/*

pdf: main.pdf

details: main-details.pdf

epub: main.epub

main.bbl: $(texfiles) $(figfiles) thesis-fixed.bib
	pdflatex main.tex
	bibtex main

main.pdf: $(texfiles) $(figfiles) main.bbl
	pdflatex main.tex
	pdflatex main.tex
	pdflatex main.tex

main-details.pdf: $(texfiles) $(figfiles) thesis-fixed.bib
	pdflatex main-details.tex
	bibtex main-details
	pdflatex main-details.tex
	pdflatex main-details.tex

main.epub: main.pdf myhtml2.cfg
	htlatex main.tex myhtml2
	ebook-convert main.html main.epub --language en --no-default-epub-cover
	rm -f LaTeXML.* ltx-report.css main.4ct main.xref main.dvi main.4tc main.html main.lg main.idv main.tmp main.css main*x.png

main2.epub: main.pdf myhtml2.cfg
	latexml --dest=main.xml main.tex
	latexmlpost -dest=main.html main.xml
	ebook-convert main.html main.epub --language en --no-default-epub-cover

main-details.epub: main-details.pdf myhtml2.cfg
	htlatex main-details.tex myhtml2
	ebook-convert main-details.html main-details.epub --language en --no-default-epub-cover
	rm -f LaTeXML.* ltx-report.css main-details.4ct main-details.xref main-details.dvi main-details.4tc main-details.html main-details.lg main-details.idv main-details.tmp main-details.css main-details*x.png

thesis-fixed.bib: thesis.bib unsrtnat5.bst
	perl -pe 's/ϵ/\$$\\epsilon\$$/' thesis.bib > thesis-fixed.bib

listmissing: main.pdf
	pdfgrep '\?' main.pdf
	pdfgrep 'XX' main.pdf

checklatex: $(texfiles) main.pdf
	python checkLatex.py -i main.tex -inrefs | less

accents: main.tex
	perl -pi -e "s/\\\'e/é/g" main.tex
	perl -pi -e "s/\\`e/è/g" main.tex

official: main.pdf
	gs -dPDFA=1 -dBATCH -dNOPAUSE -dNOOUTERSAVE -dEmbedAllFonts=true -dSubsetFonts=false -dHaveTrueTypes=true -dPDFSETTINGS=/prepress -sProcessColorModel=DeviceRGB -sDEVICE=pdfwrite -sPDFACompatibilityPolicy=1 -sOutputFile=260535322_Monlong_Jean_HumanGenetics_thesis_final.pdf main.pdf
	echo "Now convert with Acrobat Reader Pro!"

pdfa: main.pdf
	pdftops main.pdf main.ps
	gs -dPDFA -dBATCH -dNOPAUSE -dNOOUTERSAVE -dUseCIEColor -sProcessColorModel=DeviceCMYK -sDEVICE=pdfwrite -sPDFACompatibilityPolicy=1 -sOutputFile=mainPDFA.pdf main.ps

clean:
	rm -fr auto main.blg main.bbl main.toc main.out main.lot main.lof main.pdf main.4ct main.aux main.xref main.log main.dvi main.4tc main.html main.lg main.idv main.tmp main.css main.epub LaTeXML.* ltx-report.css main*x.png main-details.blg main-details.bbl main-details.toc main-details.out main-details.lot main-details.lof main-details.pdf main-details.4ct main-details.aux main-details.xref main-details.log main-details.dvi main-details.4tc main-details.html main-details.lg main-details.idv main-details.tmp main-details.css main-details.epub main.ps
