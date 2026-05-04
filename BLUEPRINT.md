# obs — individual-level simulation of Australians through justice, education, and employment systems

> **Status:** design document. No code yet. Architectural decisions in §4 and §5 are locked; everything in §11 is open.

## 1. Goal

Build a runnable, individual-level (per-person, per-event) microsimulation of Australians moving through three coupled systems — **justice**, **education**, **employment** — calibrated against published Australian official statistics, with the structural backbone derived from applied category theory.

The architecture is intentionally three things at once:

1. **A typed DSL** (Lean 4) in which a *system* is a polynomial functor, a *transition rule* is a coalgebra, a *parameter-update rule* is a parametric lens, and a *cross-system coupling* is a wiring of polynomials.
2. **A compilable specification.** The Lean spec is data — `deriving ToJson` produces a backend-agnostic intermediate representation (IR).
3. **A high-throughput runtime** in DuckDB. The IR compiles to SQL macros that run the simulation over a per-person event log.

The first version targets the **justice pipeline** (Offending → Police → Courts → Corrections) on a static `Person` substrate, with education and employment slotted in as additional lenses sharing the same substrate in v2.

## 2. Theoretical foundations

The three PDFs in [theory-documents/](theory-documents/) are the sources. This section names the constructions used; the file paths point to definitive treatments.

### 2.1 Polynomial functors as systems

A **polynomial** is a dependent pair

```
p = Σ_{i ∈ I} y^{p[i]}        I : positions,  p[i] : directions at i
```

Read operationally: at each *position* `i` (a state), the system can be observed as `i` and accepts one of the *directions* in `p[i]` (a transition label).

A **coalgebra** of `p` on a state set `S` is a function

```
S → Σ_{i ∈ I} S^{p[i]}        i.e.  s ↦ (pos(s), δ_s : p[pos(s)] → S)
```

i.e. a state-machine: from state `s`, output a position and, for each direction, a next state. This is the Spivak/Niu reading of dynamical systems. Reference: [Polynomial Functors: A Mathematical Theory of Interaction](theory-documents/Polynomial%20Functors_%20A%20Mathematical%20Theory%20of%20Interaction.pdf).

In `obs`, every system lens (Population, Offending, Police, Courts, Corrections) is a polynomial. Its positions are person-states inside that lens; its directions are the labelled transitions out of each state.

### 2.2 Lenses and parametric lenses

A **lens of polynomials** `p → q` is a pair

```
f      : pos(p) → pos(q)                              forward (positions)
f^♯_i  : dir(q)(f(i)) → dir(p)(i)   for each i        backward (directions)
```

The forward `f` reports the system's position to the outside world; the backward `f^♯` translates an external direction into an internal one. Sequential composition of lenses is the natural notion of "stack systems on top of each other".

A **parametric lens** carries an extra parameter object `Θ`. Following the Para construction (Bruno Gavranović, [Fundamental Components of Deep Learning](theory-documents/Fundamental%20Components%20of%20Deep%20Learning.pdf)):

```
ParaLens(Θ) p q :=
  forward  : Θ × pos(p) → pos(q)
  backward : Θ × pos(p) × dir(q) → Θ × dir(p)
```

The backward leg can update `Θ`. Reading `forward` as *simulate* and `backward` as *update parameters from observation*, this is exactly the shape of a learning system. The `parametric-updating-lens.png` and `combined-simulation-and-parameter-updating.png` diagrams in [ideas/](ideas/) are instances of this construction.

### 2.3 Wiring and operadic composition

Coupling several systems (justice → employment etc.) is **operadic**: each subsystem is a 1-cell in a double category of systems whose horizontal composition is wiring, and whose vertical morphisms are behaviour-preserving morphisms. Reference: [Towards a double operadic theory of systems](theory-documents/Towards%20a%20double%20operadic%20theory%20of%20systems.pdf) (Libkind & Myers).

Concretely, a wiring is a *map of polynomials* that identifies an output direction of one lens with an input direction of another. In `obs`:

```
Offending.detected      ⟶  Police.becomeAlleged
Police.courtAction      ⟶  Courts.charged
Courts.handoffToCorrections ⟶ Corrections.intake
Corrections.Released    ⤿  Population (next-tick recidivism modifier on Offending)
```

The `⤿` arrows are **lagged feedback**: they read this-tick state and write next-tick parameters, avoiding within-tick fixed points.

### 2.4 Continuous-time Markov chains with run-time discretisation

The simulator is **rate-based**. Each lens kernel emits, for each (state, covariate-bin), a vector of rates over outgoing directions:

```
λ : (Person, State, Θ) → RateVector(directions)
```

A **discretisation optic** `Discretise(Δt) : RateLens → ProbLens` produces the per-tick kernel:

- `Δt > 0`: `P(direction | Δt) = (exp(Q · Δt))[state, ·]`, computed per covariate-bin offline.
- `Δt = 0`: event-time mode. Sample next event time as `Exp(Σ rates)`; sample direction by `Cat(rates / Σ rates)`.

This factoring means *the same kernel* runs at any resolution, annual / quarterly / monthly results are mathematically consistent (they're discretisations of the same generator), and event-time is just a degenerate case of the same code path.

### 2.5 Hazard-based dwell times for non-memoryless states

Pure CTMC makes every sojourn exponential, which is wrong for prison/parole/community-order durations. For these states the kernel is replaced with a **hazard model**:

```
λ : (Person, State, time_in_state, Θ) → instantaneous_rate_per_direction
```

At entry to state `i`, draw the dwell time from the integrated hazard; at exit, draw the direction by competing-risks shares. Calibration uses survival-regression MLE. Distributions to fit (see §11 — choice deferred): Weibull, log-logistic, or piecewise-constant hazards.

This is option **(b)** from the design discussion. It plays well with DuckDB by adding a single `time_entered_state` column to the per-person current-state table.

## 3. Domain model

### 3.1 Substrate: `Person`, owned by the Population lens

Every domain lens reads a per-person record `Person` (demographic covariates) but only the Population lens writes to it. So `Person` is the **shared substrate** of the simulator — the factor that every lens's state space has in common.

```
Person :=
  id          : PersonId
  age         : ℕ
  sex         : Sex
  indigenous  : Bool
  region      : SA2
  -- + role flags set by domain lenses (offender? victim?)
```

**A note on terminology.** "Carrier" is overloaded. In strict coalgebraic usage, the *carrier* of an `F`-coalgebra is the object `X` of the pair `(X, c : X → F(X))` — the object the dynamics `c` act on. By that definition, each lens has its own carrier: the Police lens's carrier is `Person × PoliceState`, because both are needed to step the dynamics. `Person` is *not* the carrier of any single coalgebra; it is the **shared base** that every lens's carrier has as a factor.

The precise statement is: each domain lens admits a *behaviour-preserving morphism* (in the sense of [Libkind & Myers](theory-documents/Towards%20a%20double%20operadic%20theory%20of%20systems.pdf)) from its carrier to `Person`, given by the projection `(Person × DomainState) → Person`. The Population lens is distinguished as the unique lens whose carrier *is* `Person`. Equivalently, and closer to the implementation, non-Population kernels factor through a Reader-comonad-style read of `Person` with no Put — they have lens access with trivial backward leg on the demographic component.

This document uses **substrate** as the working term and reserves **carrier** for its strict coalgebraic meaning.

```text
─── Population (substrate-owning lens) ──────────────────────────────
pos              dir
NotYetBorn       {beBorn}
Alive            {age, die, emigrate, giveBirth, becomeVictim, …}
Deceased         ∅
Emigrated        {return}
─────────────────────────────────────────────────────────────────────
calibrated against: ABS Estimated Resident Population, Census, Births,
                    Deaths, Net Overseas Migration
```

### 3.2 Justice pipeline

Four lenses, each with its own observation source so calibration decomposes per lens:

```text
─── Offending (per Alive person, per tick) ─────────────────────────
NotOffending     {stay, commit(c : OffenceCategory)}
OffendingHidden  {detected(c), undetectedRepeat, desist}
─────────────────────────────────────────────────────────────────────
calibrated against: ABS Recorded Crime — Victims/Offenders;
                    ABS Crime Victimisation Survey (dark-figure)

─── Police ─────────────────────────────────────────────────────────
NotKnown         {stay, becomeAlleged(c)}            ← Offending.detected
AllegedOffender  {caution        → Diverted          // 15–30k
                 ,courtAction(c) → handoffToCourts   // 265k
                 ,noFurtherAction → CaseClosed }
Diverted         {remain, reoffend}                  ⤿ Offending
CaseClosed       ∅
─────────────────────────────────────────────────────────────────────
calibrated against: AIC, ROGS Police Services

─── Courts ─────────────────────────────────────────────────────────
NotInCourts      {stay, charged(c)}                  ← Police.courtAction
Defendant        {bailGranted → OnBail               // 155k
                 ,bailRefused → OnRemand }           // 30k
OnBail           {continue
                 ,breach        → OnRemand           // 15k
                 ,hearing(v)    → Acquitted | Sentenced(t) }
OnRemand         {continue
                 ,hearing(v)    → Acquitted | Sentenced(t) }
Acquitted        {exit}
Sentenced(t)     {handoffToCorrections(t)}           ⟶ Corrections
─────────────────────────────────────────────────────────────────────
v : Verdict   ::= Guilty | NotGuilty
t : SentType  ::= Fine | CommunityOrder | Custody
calibrated against: ABS Criminal Courts Australia, AIC court data

─── Corrections ────────────────────────────────────────────────────
NotInCorrections {stay, intake(t)}                   ← Courts
Fined            {paid → Released                    // 150k
                 ,defaultToCustody → Prisoner }      // 2k
CommunityOrder   {complete → Released                // 62k
                 ,breach   → Prisoner }              // 10k
Prisoner         {stay
                 ,parole          → Parolee          // 25k
                 ,sentenceComplete → Released }      // 15k
Parolee          {stay
                 ,complete → Released
                 ,revoke   → Prisoner }              // 4k
Released         {stay}                              ⤿ Population (recidivism)
─────────────────────────────────────────────────────────────────────
calibrated against: AIHW Prisoners in Australia, ROGS Corrective Services
```

Counts (in `// …`) are read from the SCC-condensation diagram at [ideas/system-partition-with-causal-ordering.png](ideas/system-partition-with-causal-ordering.png) and serve as the empirical anchor for v1 calibration.

### 3.3 Future lenses (v2+)

Education, employment, mental health, child protection, AOD will each be additional polynomials sharing the `Person` substrate. They wire to the justice pipeline via labelled directions (e.g. `Education.disengaged ⤿ Offending` rate multiplier).

## 4. System architecture

### 4.1 Four layers

```
┌─ Layer 1 — Domain data ────────────────────────────────────────────┐
│  ABS / AIHW / AIC / ROGS / NCVER / DEWR aggregate tables; per-lens │
│  observation series D_t for calibration; ABS TableBuilder           │
│  marginals + IPF for seed population.                              │
├─ Layer 2 — Theory (Lean 4, typed DSL) ─────────────────────────────┤
│  Poly, Lens, ParaLens, RateLens; the five system polynomials and   │
│  their wirings. Type-checks structure; emits IR. No theorems v1.   │
├─ Layer 3 — IR (JSON) ──────────────────────────────────────────────┤
│  Backend-agnostic record of positions, directions, kernel shapes,  │
│  wirings, observation bindings. Validated by JSON Schema.          │
├─ Layer 4 — Runtime (DuckDB + Python driver) ───────────────────────┤
│  Schema DDL + parametric SQL macros + driver loop running          │
│  forward simulation and per-lens MLE calibration.                  │
└────────────────────────────────────────────────────────────────────┘
```

### 4.2 The compilation pipeline

```
  Lean spec (typed DSL)
        │
        │  obs.lean: #eval emitIR rootSpec  →  ToJson
        ▼
  spec.json (IR)
        │
        │  obs_compiler.duckdb_emit
        ▼
  schema.sql + macros.sql
        │
        │  obs_compiler.driver: forward + calibrate loop
        ▼
  cohort.duckdb  (per-person event log + per-lens θ tables)
```

The Lean side does **no compute** beyond producing the IR. The Python compiler holds all SQL knowledge. Re-targeting (Polars, ClickHouse, JAX) is a new compiler module.

### 4.3 Where parameters live

For each lens `L`, the parameter object `θ_L` is a *table*, not a scalar:

```
θ_L : (covariate_cell × from_state × to_direction) → rate
```

Covariate cells are tuples like `(age_band, sex, indigenous, region_class, offence_category)`. The cell schema is part of the IR for each lens — it controls both the SQL shape of the kernel join and the granularity of MLE estimation.

The full simulator parameter is a product `θ = (θ_pop, θ_off, θ_pol, θ_crt, θ_cor)` and per-lens calibration touches only one factor at a time.

## 5. Calibration

### 5.1 Per-edge multinomial MLE for probabilities

For each `(cell, from_state)`, the outgoing direction shares are multinomial. The MLE of the share for direction `d` is

```
p̂(d | cell, from) = (n(cell, from, d) + α) / Σ_d' (n(cell, from, d') + α)
```

with Dirichlet smoothing `α = 0.5` (Jeffreys) by default. This is one DuckDB query per lens:

```sql
SELECT
  age_band, sex, indigenous, region_class, from_state, to_direction,
  (count + α) / sum(count + α)
    OVER (PARTITION BY age_band, sex, indigenous, region_class, from_state)
    AS p_hat
FROM observed_transitions;
```

### 5.2 Rate MLE: occurrence over exposure

For continuous-time rates,

```
λ̂(i → j | cell) = transitions_{i→j, cell}  /  person-time-in-i_{cell}
```

Person-time is reconstructed from stock × window when only flow + snapshot data are reported (the standard demographic occurrence/exposure trick). For non-memoryless states (§2.5), survival regression replaces this — Weibull / log-logistic MLE on observed dwell-time distributions.

### 5.3 Modular calibration by lens

Five independent calibration queries — one per lens factor of `θ`. Cross-lens couplings (e.g. recidivism multipliers) are calibrated separately as a pseudo-MLE over simulator output vs observed cohort outcomes, after the per-lens factors are pinned.

### 5.4 Why the parametric-lens framing matters

The lens type signature `(forward = simulate, backward = D → θ̂)` says nothing about *what's inside* `backward`. v1 backward = closed-form MLE. v2 candidates: hierarchical / partial-pooling fits via PyMC or Stan; gradient-step calibration via JAX (requires moving the simulator to JAX); ABC for likelihood-free targets. The forward simulator and the IR never change.

## 6. Implementation plan

### 6.1 Vertical slice (v0)

Smallest end-to-end demo that exercises the full stack:

- **Population:** static cohort from a small IPF over ABS TableBuilder marginals — no births/deaths.
- **Offending:** Poisson exogenous on demographic cells; one offence category.
- **Police:** full polynomial (NotKnown / AllegedOffender / Diverted / CaseClosed).
- **Courts:** full polynomial (Defendant through Sentenced).
- **Corrections:** stubbed as an absorbing sink (`intake → exit`).

Goal: 10k synthetic persons, run 5 yearly ticks, calibrate the Police and Courts lenses against ABS Criminal Courts data, see plausible flow counts. Roughly two weekends.

### 6.2 Phases beyond v0

| Phase | Scope                                                                 | New machinery                                  |
|-------|------------------------------------------------------------------------|------------------------------------------------|
| v0    | Vertical slice (above)                                                | All four layers wired end-to-end                |
| v1    | Full justice pipeline with real Population dynamics                    | Births/deaths, hazard models for dwell times    |
| v2    | Δt sweep (annual/quarterly/monthly/event-time) on the same kernels    | `Discretise(Δt)` optic                          |
| v3    | Education + Employment lenses                                          | Two more polynomials, more wirings              |
| v4    | Hierarchical calibration                                              | Partial-pooling, swap-in calibration backend    |
| v5    | Theorems in Lean (conservation, kernel well-formedness, identifiability) | Mathlib import, real proof obligations         |

### 6.3 Repository layout

```
obs/
├── BLUEPRINT.md                 (this file)
├── README.md
├── lean/
│   ├── lakefile.toml
│   └── Obs/
│       ├── Poly.lean            -- Poly, Lens, ParaLens, RateLens core
│       ├── Time.lean            -- discretisation optic, hazard interface
│       ├── Population.lean
│       ├── Offending.lean
│       ├── Police.lean
│       ├── Courts.lean
│       ├── Corrections.lean
│       └── Wiring.lean          -- the cross-lens wirings, root spec
├── ir/
│   └── schema.json              -- IR JSON Schema
├── compiler/
│   ├── pyproject.toml
│   └── obs_compiler/
│       ├── ir.py                -- pydantic models matching schema
│       ├── duckdb_emit.py       -- IR → DDL + SQL macros
│       ├── calibrate.py         -- per-lens MLE queries
│       └── driver.py            -- run loop
├── seed/
│   └── seed_population.py       -- ABS TableBuilder + IPF
├── data/
│   ├── raw/                     -- ABS/AIHW/AIC/ROGS extracts
│   └── derived/                 -- transition counts, person-time
├── theory-documents/            -- existing PDFs
├── ideas/                       -- existing diagrams
└── notebooks/                   -- exploratory analysis
```

## 7. Tooling and dependencies

| Layer       | Tool                 | Role                                              |
|-------------|----------------------|---------------------------------------------------|
| Theory      | Lean 4 + Lake        | Typed DSL for polynomials, lenses, wirings        |
| IR          | JSON + JSON Schema   | Backend-agnostic spec; validated on emit         |
| Compiler    | Python ≥ 3.12        | IR consumption, SQL emission, driver loop        |
|             | pydantic             | IR types, schema validation                       |
|             | DuckDB Python        | DB connection, parameterised macro execution     |
| Runtime     | DuckDB ≥ 1.0         | Columnar OLAP engine; per-tick simulation        |
| Seeding     | Python + numpy/pandas | IPF over ABS TableBuilder marginals              |
| Calibration | DuckDB SQL (v1)      | Closed-form per-edge multinomial / rate MLE      |
|             | PyMC / Stan (v4+)    | Hierarchical pooling                              |
|             | JAX (deferred)       | If/when a gradient-based calibrator is wanted    |
| Data        | ABS TableBuilder     | Census marginals for seeding                      |
|             | ABS, AIHW, AIC, ROGS  | Per-lens observation series for calibration       |
| Repro       | Lake + uv            | Lean and Python lockfiles respectively            |

## 8. Glossary

| Term | Meaning in `obs` |
|------|------------------|
| Position | A state in a lens's polynomial (e.g. `OnRemand`). |
| Direction | A labelled outgoing transition from a position (e.g. `bailGranted`). |
| Lens (of polys) | Forward map of positions plus backward pull-back of directions. |
| Parametric lens | A lens where forward/backward are parameterised by `θ`. |
| Coalgebra | The actual stepper: `S → p(S)`, mapping a state to position + direction-handler. |
| Wiring | A morphism identifying an output direction of one lens with an input direction of another. |
| Carrier (of a coalgebra) | Strict CT sense: the object `X` of an `F`-coalgebra `(X, c : X → F(X))`. Each lens has its own carrier (e.g. Police's is `Person × PoliceState`). |
| Substrate / shared base | The factor every lens's carrier has in common (here: `Person`). What earlier loose usage called the "carrier". |
| Behaviour-preserving morphism | Vertical morphism in the Libkind–Myers double category of systems. Each domain lens's carrier admits one to `Person`, given by projection. |
| Rate kernel | `(person, state, θ) → RateVector(directions)`. |
| Discretiser | Optic taking a rate kernel to a per-tick probability kernel for a given `Δt`. |
| Hazard model | Time-in-state-aware rate kernel for non-memoryless states. |
| IR | The JSON intermediate representation between Lean and DuckDB. |
| Cell | A combination of covariate values that indexes parameter rows. |

## 9. References

- Spivak, Niu — *Polynomial Functors: A Mathematical Theory of Interaction* — [PDF](theory-documents/Polynomial%20Functors_%20A%20Mathematical%20Theory%20of%20Interaction.pdf).
- Gavranović — *Fundamental Components of Deep Learning: A category-theoretic approach* — [PDF](theory-documents/Fundamental%20Components%20of%20Deep%20Learning.pdf).
- Libkind, Myers — *Towards a double operadic theory of systems* — [PDF](theory-documents/Towards%20a%20double%20operadic%20theory%20of%20systems.pdf).
- Diagrams in [ideas/](ideas/) — informal but load-bearing visualisations of the parametric lens, additive trace, parameter updating, combined simulation+update, and the SCC-condensation of the AU justice flow.
- Australian data sources: ABS Estimated Resident Population, Census, Recorded Crime, Criminal Courts Australia, Crime Victimisation Survey; AIHW Prisoners in Australia; AIC; ROGS Corrective Services / Police / Courts; NCVER VOCSTATS; DEWR labour-market data.

## 10. Open questions

These are deliberately deferred and should be revisited at the noted phase.

- **Dwell-time distribution choice (v1).** Weibull, log-logistic, or piecewise-constant hazards for prison / parole / community-order. Pick when calibration data is in hand.
- **Cell schema per lens.** What covariate combinations are too sparse to stratify on at the per-edge level. Affects v1 MLE; partially fixed by v4 hierarchical pooling.
- **Cross-lens calibration order.** Pin per-lens factors first, then fit recidivism couplings — but also need a sanity loop where the joint simulation is checked against published cohort outcomes and per-lens factors are nudged. Procedure to be formalised in v1.
- **Victim modelling.** v1 treats victimhood as a `Person` role flag set by Offending. Repeat-victimisation modelling needs its own polynomial.
- **Cohort vs period accounting.** Some Australian publications report period (financial-year flows), some report cohort (offenders followed through outcomes). Reconciliation matters for MLE and is fiddly — flagged for v1.
- **Lean → IR ergonomics.** The exact `ToJson` derivation strategy for dependent `pos`/`dir` types. Likely sum-out dependent positions before serialising (the `Sentenced(t)` discussion).
- **Privacy posture beyond home use.** TableBuilder perturbation is enough now. If the project is ever shared as a tool with seed populations attached, revisit DP.

## 11. Out of scope for v1

- Real Bayesian uncertainty quantification on calibrated parameters.
- Spatially explicit movement (region transitions are demographic only, not modelled as a spatial diffusion).
- Court appeal pathways (treated as outside the polynomial).
- Federal vs state jurisdictional differentiation.
- Cost / fiscal accounting on top of the simulator.
