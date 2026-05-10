# obs-teach

A self-contained Lean 4 microsimulator that demonstrates every module of the
Compositional Stochastic Systems course end-to-end. It simulates a small
cohort of synthetic Australians moving through three lenses — labour,
education, and justice — over the substrate of demographic Person records.

It is deliberately small. Every module of the course corresponds to one (or
two) Lean files; every file has a header comment naming the module(s) it
implements. The aim is teaching, not realism.

## Build and run

```sh
lake build         # first build will fetch the Lean toolchain
lake exe obs-teach
```

Optional arguments:

```sh
lake exe obs-teach --persons 1000 --periods 60 --seed 42 --out out
```

Output:

* `out/events.csv` — the events table (the additive trace's accumulator,
  Module 6).
* Stdout prints the recovered calibration posteriors next to the true
  parameters.

Run the test suite with:

```sh
lake exe obs-teach-tests
```

It exercises the PRNG, the Dirichlet conjugate update (including naturality),
the cross-lens wirings, the marginal-schema aggregation, the calibration
round-trip on a synthetic events list, and the lens polynomial structure.

## Module → file map

| Module | File | What it implements |
|---|---|---|
| 1 — Coalgebras | `ObsTeach/Foundations.lean` | Polynomial coalgebras as Lean records. |
| 2 — Yoneda | `ObsTeach/Foundations.lean` | Lenses between polynomials. |
| 3 — Para-lenses | `ObsTeach/ParaLens.lean` | Forward/backward parametric lens type. |
| 4 — Markov categories | `ObsTeach/Markov.lean` | Rate kernels, hazards, `Discretise(Δt)`. |
| 5 — Categorical Bayes | `ObsTeach/Bayes.lean` | Dirichlet–Multinomial conjugate update. |
| 6 — Additive trace | `ObsTeach/Trace.lean` | Per-period within-lens trace, events accumulator. |
| 7 — Double categories | `ObsTeach/Wiring.lean` | Cross-lens wirings, behaviour-preserving morphisms. |
| 8 — Substrate | `ObsTeach/Substrate.lean` | Person, covariate-cell coarsening, Reader pattern. |
| 9 — Ologs / FDM | `ObsTeach/Olog.lean` | Marginal-schema common ground. |
| 10 — Calibration | `ObsTeach/Calibration.lean` | Backward-leg query (events → posterior). |
| 11 — Capstone | `ObsTeach/Sim.lean` + `Main.lean` | The full driver. |

Auxiliary:

* `ObsTeach/Random.lean` — pure-functional PRNG, exponential / Weibull /
  categorical samplers.
* `ObsTeach/Lenses.lean` — the polynomial structure (positions and labelled
  directions) of the four lenses.
* `ObsTeach/FakeData.lean` — true rate parameters + a small external
  empirical dataset.

## What the demo demonstrates

1. **The forward leg as a parametric lens** (Modules 1, 3, 4). Every
   transition is sampled by competing exponentials from a rate kernel keyed
   by `(covariate-cell, lens, from-state)`. The `imprisoned → free`
   transition is sampled with a Weibull hazard (Module 4.6).

2. **Wirings between lenses** (Module 7). Imprisonment forces NILF and
   `notStudying`. School/university enrolment forces NILF. Ageing past 16
   forces the substrate to update education state.

3. **Substrate as fibration** (Module 8). The `Person` record is the base.
   Domain-lens kernels read it but do not write to it. Only the cohort-ageing
   "Population kernel" mutates `Person`.

4. **The additive trace** (Module 6). Per period, per person, per lens, the
   simulator iterates draws until the period boundary fires and accumulates
   every event into a multiset (the events table).

5. **Bayes-Laplace calibration** (Module 5, Module 10). After the simulation
   we forget the true parameters and recover them from the events table by
   the conjugate Dirichlet update with a Jeffreys prior. The recovered
   posterior means should match the truth to within sampling error.

6. **Marginal-schema olog as common ground** (Module 9). A small external
   "empirical" dataset is supplied as marginal-schema rows. Calibration that
   pools simulator events and external rows uses the same conjugate update
   over the same key — the olog is the structural reason the two sources
   compose.

## Notes for the reader

* The PRNG is a SplitMix-style LCG. It is deterministic and reproducible
  given the seed.
* All numerical work is `Float`. There is no Mathlib dependency.
* Time is in years; the default tick is one month. Rates in `FakeData.lean`
  are per-year; competing exponentials sample directly in event time.
* Cells in `trueKernel` are tagged `*` to indicate "constant across all
  cells". The calibration query keys posteriors by the actual cell each
  person belongs to; the `aggregateAcrossCells` helper marginalises back
  for side-by-side comparison with the `*`-tagged ground truth.

## License

Same as the parent `obs` project.
