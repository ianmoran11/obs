# obs-teach — companion book

A self-contained HTML book that explains the categorical theory the simulator
implements. Open `index.html` in any modern browser. Math is rendered with
MathJax (loaded from CDN); diagrams are inline SVG.

The book is a companion to the Lean source under `../ObsTeach/`. Each
chapter ends with a *How this lives in the code* callout pointing at the
file (and often a small excerpt) that implements the concept just discussed.

## Why a single HTML file

This started as an attempt to use the `Verso` documentation system, but the
toolchain landed at a place where the upfront build cost was outweighing the
benefit for a teaching artefact. The single-file HTML approach gives you:

* No build step. Open and read.
* Searchable with Cmd-F across the whole book.
* Math and diagrams render inline, no asset directory.
* The aesthetic is close to what Verso produces — sidebar TOC, clean
  typography, code blocks pulled from the Lean source.

If you want to convert to a multi-page book later, the structure of
`index.html` is friendly to splitting along the `<section class="chapter">`
boundaries.

## Reading order

1. **Front matter** — how to read the book.
2. **Modules 1–3** — the structural skeleton (polynomial coalgebras,
   Yoneda, parametric lenses).
3. **Modules 4–6** — the dynamics (Markov categories, Bayes, additive
   trace).
4. **Modules 7–9** — the architecture (wirings, substrate, marginal-schema
   olog).
5. **Modules 10–11** — calibration as a parametric-lens backward leg, and
   the capstone that wires it all together.
