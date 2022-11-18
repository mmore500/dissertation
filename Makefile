# get the basename of the containing directory
# this will be used to name othe output document
BUILD_DIR := $(shell basename $(abspath $(dir $(lastword $(MAKEFILE_LIST)))))

all: ${BUILD_DIR}-draft.pdf

view:
	atom ${BUILD_DIR}.pdf

DRAFT_SUPPLEMENT_PAGE = $(shell pdftk ${BUILD_DIR}-draft.pdf dump_data_utf8 | pcregrep -M -o1 '^BookmarkBegin\nBookmarkTitle: APPENDICES\nBookmarkLevel: 2\nBookmarkPageNumber: ([0-9]+)$$')

RELEASE_SUPPLEMENT_PAGE = $(shell pdftk ${BUILD_DIR}.pdf dump_data_utf8 | pcregrep -M -o1 '^BookmarkBegin\nBookmarkTitle: APPENDICES\nBookmarkLevel: 2\nBookmarkPageNumber: ([0-9]+)$$')

draft: ${BUILD_DIR}-draft.pdf ${BUILD_DIR}-manuscript-draft.pdf ${BUILD_DIR}-supplement-draft.pdf

release: ${BUILD_DIR}.pdf ${BUILD_DIR}-manuscript.pdf ${BUILD_DIR}-supplement.pdf

${BUILD_DIR}.pdf: main.tex out.bib
	latexmk -pdf -silent \
    -jobname=${BUILD_DIR} \
    -pdflatex="pdflatex -interaction=nonstopmode" main.tex

${BUILD_DIR}-draft.pdf: main.tex out.bib
	latexmk -pdf -silent \
    -jobname=${BUILD_DIR}-draft \
    -pdflatex="pdflatex -interaction=nonstopmode" draft.tex

${BUILD_DIR}-manuscript.pdf: ${BUILD_DIR}.pdf
	pdftk ${BUILD_DIR}.pdf cat 1-$$(( $(RELEASE_SUPPLEMENT_PAGE) - 1 )) output ${BUILD_DIR}-manuscript.pdf

${BUILD_DIR}-supplement.pdf: ${BUILD_DIR}.pdf
	pdftk ${BUILD_DIR}.pdf cat $(RELEASE_SUPPLEMENT_PAGE)-end output ${BUILD_DIR}-supplement.pdf

${BUILD_DIR}-manuscript-draft.pdf: ${BUILD_DIR}-draft.pdf
	pdftk ${BUILD_DIR}-draft.pdf cat 1-$$(( $(DRAFT_SUPPLEMENT_PAGE) - 1 )) output ${BUILD_DIR}-manuscript-draft.pdf

${BUILD_DIR}-supplement-draft.pdf: ${BUILD_DIR}-draft.pdf
	pdftk ${BUILD_DIR}-draft.pdf cat $(DRAFT_SUPPLEMENT_PAGE)-end output ${BUILD_DIR}-supplement-draft.pdf

clean:
	rm -f ${BUILD_DIR}.pdf
	rm -f ${BUILD_DIR}.tex
	rm -f ${BUILD_DIR}-draft.pdf
	rm -f ${BUILD_DIR}-draft.tex
	rm -f ${BUILD_DIR}-manuscript.pdf
	rm -f ${BUILD_DIR}-manuscript-draft.pdf
	rm -f ${BUILD_DIR}-supplement.pdf
	rm -f ${BUILD_DIR}-supplement-draft.pdf
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
