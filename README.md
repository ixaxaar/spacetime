# causal-entropy-universe

A framework paper (WIP): spacetime as a growing directed simplicial set,
evolving by sprout + inner-horn-fill moves; time = the solving process;
entropy = log(# linear extensions of the causal past); dynamics to be
derived by maximum entropy inference.

Status: draft v0.1. All unfinished pieces are marked `[GAP: ...]` in red
in the compiled PDF. See `TODO-PAPER-ENHANCEMENTS.md` for the work queue.

## Layout

- `main.tex` — entry point
- `src/` — sections (introduction, prerequisites, background, methodology, results, discussion, appendix)
- `figures/` — TikZ sources + generated plots
- `bibliography/references.bib`
- `bin/toy_universe.py` — the toy simulation (sprout/fill, event poset, exact linear-extension count)

## Build

    make          # pdf
    make sim      # rerun the toy simulation
