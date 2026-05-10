# obs-teach — companion book

A single Markdown book that explains the categorical theory the simulator
implements. The book is `index.md`; open it in any Markdown viewer or read
it on GitHub, where math (`$...$`, `$$...$$`) and Mermaid diagrams render
natively.

The book is a companion to the Lean source under `../ObsTeach/`. Each
chapter ends with a *How this lives in the code* section that reproduces
the **full body** of the relevant Lean functions (not just declarations) so
you can see how the math becomes code.

## Reading order

1. **Front matter** — how to read the book, conventions.
2. **Modules 1–3** — the structural skeleton (polynomial coalgebras,
   Yoneda, parametric lenses).
3. **Modules 4–6** — the dynamics (Markov categories, Bayes, additive
   trace).
4. **Modules 7–9** — the architecture (wirings, substrate, marginal-schema
   olog).
5. **Modules 10–11** — calibration as a parametric-lens backward leg, and
   the capstone that wires it all together.

## Why Markdown

The book started as a single self-contained HTML file. The Markdown form
gives you the same content with a few practical advantages:

* **Renders on GitHub.** Math and Mermaid diagrams display inline in the
  repository view; no build step.
* **Easy to extend.** Adding a chapter or revising prose is a normal text
  edit.
* **Clean diff.** PR reviews show actual prose changes, not blocks of HTML
  noise.

The 11 chapters total ~13,000 words and quote the full bodies of every
non-trivial function in the simulator.
