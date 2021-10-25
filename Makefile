# get the basename of the containing directory
# this will be used to name othe output document
BUILD_DIR := $(shell basename $(abspath $(dir $(lastword $(MAKEFILE_LIST)))))

all: ${BUILD_DIR}-draft.pdf

view:
	atom ${BUILD_DIR}.pdf

${BUILD_DIR}.pdf: main.tex out.bib
	latexmk -pdf -silent \
    -jobname=${BUILD_DIR} \
    -pdflatex="pdflatex -interaction=nonstopmode" main.tex

${BUILD_DIR}-draft.pdf: main.tex out.bib
	latexmk -pdf -silent \
    -jobname=${BUILD_DIR}-draft \
    -pdflatex="pdflatex -interaction=nonstopmode" draft.tex


clean:
	rm -f ${BUILD_DIR}.pdf
	rm -f ${BUILD_DIR}-draft.pdf
	rm -f out.bib

out.bib:
	# adapted from https://kevcaz.github.io/notes/latex/bibtools/
	bibtool -s -d $$(find . -name "bibl.bib" -type f) $$(find . -name "paper.bib" -type f) -o out.bib

sview:
	xdg-open ${BUILD_DIR}-draft.pdf 2>/dev/null

fresh: cleaner all

cleaner: clean
	latexmk -CA
	# remove auxillary files, excepting .tex and .bib files
	find . -type f -name ${BUILD_DIR}"*" ! -name '*.tex' ! -name '*.bib' -delete
	find . -type f -name '*.aux' -delete
	$(MAKE) cleaner -C ch/
