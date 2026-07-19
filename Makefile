MAIN = main
LATEX = pdflatex
BIBTEX = bibtex

all: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex src/*.tex figures/*.tex bibliography/*.bib
	$(LATEX) $(MAIN)
	$(BIBTEX) $(MAIN)
	$(LATEX) $(MAIN)
	$(LATEX) $(MAIN)

sim:
	python3 sim/toy_universe.py

lean:
	cd lean && lake build

clean:
	rm -f $(MAIN).aux $(MAIN).bbl $(MAIN).blg $(MAIN).log $(MAIN).out $(MAIN).toc

distclean: clean
	rm -f $(MAIN).pdf

help:
	@echo "Targets:"
	@echo "  all       - build $(MAIN).pdf (default)"
	@echo "  sim       - run toy simulation (sim/toy_universe.py)"
	@echo "  lean      - build Lean 4 + mathlib skeleton (lean/)"
	@echo "  clean     - remove LaTeX aux files"
	@echo "  distclean - clean + remove $(MAIN).pdf"
	@echo "  help      - show this message"

.PHONY: all sim lean clean distclean help
