MAIN = main
LATEX = pdflatex
BIBTEX = bibtex

all: $(MAIN)

$(MAIN).pdf: $(MAIN).tex src/*.tex figures/*.tex bibliography/*.bib
	$(LATEX) $(MAIN)
	$(BIBTEX) $(MAIN)
	$(LATEX) $(MAIN)
	$(LATEX) $(MAIN)

sim:
	python3 bin/toy_universe.py

clean:
	rm -f $(MAIN).aux $(MAIN).bbl $(MAIN).blg $(MAIN).log $(MAIN).out $(MAIN).toc

distclean: clean
	rm -f $(MAIN).pdf

.PHONY: all sim clean distclean
