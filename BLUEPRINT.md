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

Coupling several systems (Justice → Labour etc.) is **operadic**: each subsystem is a 1-cell in a double category of systems whose horizontal composition is wiring, and whose vertical morphisms are behaviour-preserving morphisms. Reference: [Towards a double operadic theory of systems](theory-documents/Towards%20a%20double%20operadic%20theory%20of%20systems.pdf) (Libkind & Myers).

#### 2.3.1 Parallel product on polynomials

The monoidal product used for wiring is the **parallel product** `⊗` (often called the Dirichlet product):

```
(p ⊗ q).pos          := p.pos × q.pos
(p ⊗ q).dir (i, j)   := p.dir i × q.dir j
```

Intuition: place `p` and `q` side by side, observed simultaneously. A position of `p ⊗ q` is *both* `p`'s and `q`'s current state; a direction at `(i, j)` is *both* a direction of `p` at `i` and a direction of `q` at `j`. Parallel product is associative and symmetric monoidal up to coherence iso, so `(A ⊗ B) ⊗ C ≅ A ⊗ (B ⊗ C)` — pair-wise design suffices for n-ary composition.

#### 2.3.2 A wiring is a lens out of a parallel composite

Given inner systems `p₁, …, pₙ` and an outer interface polynomial `q`, a **wiring diagram** is a lens

```
w : p₁ ⊗ … ⊗ pₙ  ⟶  q
```

Unpacked:

```
w.fwd  : p₁.pos × … × pₙ.pos → q.pos
           "given the inner states, what does the outside see?"

w.bwd  : (j ∈ inner positions) (d ∈ q.dir (w.fwd j)) → p₁.dir j₁ × … × pₙ.dir jₙ
           "given an outside input direction, what direction does each inner system get?"
```

The backward leg does the routing — it is what synchronises inner systems on a shared joint transition. It can route an outer input into one inner system, route an inner output into another inner input (feedback), discard, broadcast, or merge.

#### 2.3.3 Double operadic structure

Pure operadic composition only changes interfaces. Sometimes you also want to change the *carrier* — replace a fine-grained system with a coarsened approximation, refine a stub into a full implementation, or quotient indistinguishable states. These are **behaviour-preserving morphisms**, the vertical arrows of the Libkind–Myers double category.

| | role |
|---|---|
| Objects | interface polynomials |
| Horizontal arrows | lenses (wirings) |
| Vertical arrows | behaviour-preserving morphisms (carrier changes) |
| 2-cells | wiring diagrams that commute with carrier changes |

For `obs`, the vertical structure is exactly what makes §2.4 work: `Discretise(Δt) : RateLens → ProbLens` is a behaviour-preserving morphism — same interface, different carrier (continuous-time → discrete-time). The 2-cell coherence ensures that wiring composed systems and then discretising gives the same result as discretising each first and then wiring — which is the property that makes mixing abstraction levels safe.

#### 2.3.4 Synchronous wiring vs lagged feedback

Two distinct mechanisms couple lenses, both visible in the diagrams of [ideas/](ideas/):

```
Offending.detected      ⟶  Police.becomeAlleged          (synchronous)
Police.courtAction      ⟶  Courts.charged                (synchronous)
Courts.handoffToCorrections ⟶ Corrections.intake          (synchronous)
Corrections.Released    ⤿  Offending (next-tick rate ↑)   (lagged)
Labour.unemployed       ⤿  Offending (next-tick rate ↑)   (lagged)
```

The `⟶` arrows are **synchronous wirings**: a single joint direction fires inner directions in lockstep, encoded in `w.bwd` as above. The `⤿` arrows are **lagged feedback**: they read this-tick state and modify next-tick kernel parameters, avoiding within-tick fixed points. Lagged feedback is *not* in the wiring lens — it lives in kernel covariates.

Concrete catalogue and worked example are in §3.4 and §3.5.

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

### 2.6 Within-period dynamics and the additive trace

§2.4 establishes that kernels emit *rates*, not per-tick probabilities, and §2.5 extends this to non-memoryless states via hazards. This subsection answers the operational question: how is the simulator actually stepped, and what role does the reporting period `Δt` play?

#### 2.6.1 Two time-scales

Two notions must be kept distinct:

- **Continuous event time within a period.** The simulator is event-driven: each person's next transition has a time, sampled from the current state's hazard. Sampling, firing, and rescheduling happen in event-time, not on ticks.
- **Reporting periods (`Δt`).** Quarterly, annual, monthly, or event (`Δt = 0`). These are observation windows over the event stream, used to summarise flows and stocks for calibration. Periods are *projections*, not simulation steps.

The simulator does not advance "by period" — it advances by event. Periods enter only at the trace operator that produces a per-period observable from the event stream. This is the operational reading of the `system-lens-with-additive-trace.png` diagram in [ideas/](ideas/).

#### 2.6.2 The per-lens additive trace

For each lens `L`, define a `Trace` interface alongside the rate kernel:

```text
Trace_L :=
  draw       : (state, person, t)        → (next_event_time, direction)
  split      : direction                 → { continue | exit_to L' | period_boundary }
  accumulate : (running_summary, event)  → running_summary           -- monoidal
  emit       : running_summary           → per_period_observable
```

This is the categorical reading of the *additive trace*: a feedback operator on `p_L → p_L` that loops `draw → split → accumulate` until `split` returns either an inter-lens exit or a period-boundary signal, then `emit` projects the accumulator out as the lens's per-period observable.

`accumulate` is the *additive* part. Its accumulator is required to be a (commutative) monoid — typically `(ℕ, +)` for direction counts, `(ℝ⁺, +)` for time-weighted state stocks, or vector-valued versions of these. "Additive" does not restrict the accumulator to a single number; it is only the structural requirement that combining events is associative and identity-respecting.

The per-period observable is `emit ∘ fold(accumulate, events_in_period)` — this is what calibration data is compared against in §5.

#### 2.6.3 Per-period topological sweep over the wiring DAG

The synchronous-wire structure of §2.3 is a DAG (Offending → Police → Courts → Corrections; Population is the root via lifecycle wires). Lagged feedback `⤿` does not enter the DAG — it only modifies next-period kernel parameters. Within a period the DAG is therefore acyclic, and one topological sweep per period resolves all cascades:

```text
for each period [t, t + Δt):
    for each lens L in topological_order(synchronous_wire_DAG):
        for each person currently in L (carry-over) or arriving from upstream this period:
            init: running_summary ← ε_L         -- monoid identity
            repeat:
                (event_time, direction) ← Trace_L.draw(person.state, person, t_current)
                if event_time ≥ t + Δt:
                    -- person remains in L at period boundary
                    record_event(person, L, t + Δt, "carried_over")
                    break
                case Trace_L.split(direction):
                    | continue:
                          apply intra-L transition
                          running_summary ← Trace_L.accumulate(running_summary, event)
                          record_event(person, L, event_time, direction)
                          continue loop                                -- the trace
                    | exit_to L':
                          push person onto L'.arrivals[t = event_time]
                          record_event(person, L, event_time, direction)
                          break
                    | period_boundary:
                          unreachable here (handled above)
            persist Trace_L.emit(running_summary) into period summary
```

Properties:

- **Within-period cascades resolve fully.** A person can transit `Police → Courts → Corrections` in one period because Courts processes after Police and picks up arrivals.
- **No fixed-point iteration is needed.** The DAG is acyclic *for synchronous wires*. Recidivism (`Corrections.Released ⤿ Offending`) is lagged, so it never closes a within-period loop.
- **The sweep is per period, but the dynamics inside are per event.** `Δt` enters only at the period-boundary check and the `emit`. The dynamics are scale-free.

#### 2.6.4 Events table as the canonical artefact

The simulator's primary output is an **events table**:

```
events(person_id, lens, event_time, from_state, direction, to_state, covariate_snapshot)
```

Every simulation artefact derives from this table:

- *Per-period flows* — `GROUP BY period_bucket(event_time), lens, direction`.
- *Per-period stocks* — `LAST_VALUE(state) OVER (PARTITION BY person_id ORDER BY event_time)` evaluated at period boundaries.
- *Per-lens additive trace observables* — group-by per period plus the lens's `emit`.
- *Calibration counts* (§5) — joined against observation tables.

A separate "current state" table is maintained as a *cache* (for fast hazard lookups during simulation) but is always derivable from the events table. This makes the simulator's output reproducible, debuggable, and time-travelable: any past state can be reconstructed by replaying events up to a chosen time.

#### 2.6.5 DuckDB implementation pattern

The topological sweep maps to DuckDB as a per-period, per-lens, per-arrival-cohort vectorised step. The inner `repeat` loop becomes a small bounded iteration (typically one or two rounds because most paths through a single lens are short within one period):

```sql
-- one iteration of the inner trace, vectorised over a cohort
WITH cohort AS (
  SELECT person_id, state, time_entered_state, covariate_cell
  FROM person_state WHERE lens = :L AND active_in_period(:t, :Δt)
),
hazards AS (
  SELECT c.*, k.direction, k.lambda
  FROM cohort c JOIN theta_:L k USING (state, covariate_cell)
),
sampled AS (
  SELECT person_id,
         :t + sample_event_time(SUM(lambda) OVER (PARTITION BY person_id), :Δt) AS event_time,
         sample_direction(...) AS direction
  FROM hazards GROUP BY person_id
)
INSERT INTO events
SELECT person_id, :L, event_time, direction
FROM sampled
WHERE event_time < :t + :Δt;
```

Single global event queues popping events in absolute order are also implementable but fit DuckDB's set-based model worse — they require per-event Python round-trips. The per-period topological sweep is the recommended pattern for this project.

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

### 3.4 Combining lenses: catalogue and build order

Wirings compose (§2.3.1), so the design exercise is per pair, not per n-tuple. Below is every pair that matters for `obs`, with the synchronous wire (the lens), the lagged feedback (kernel covariates), the Australian data needed, and rough effort.

| Pair | Synchronous wire(s) | Lagged feedback | Data | Effort | Phase |
|------|---------------------|------------------|------|--------|-------|
| **Within Justice** | | | | | |
| Offending ↔ Police | `Offending.detected(c)` ⟹ `Police.becomeAlleged(c)` | Diversion → reduced offending rate next tick | ABS Recorded Crime Offenders; AIC linkage | Low | v0 |
| Police ↔ Courts | `Police.courtAction(c)` ⟹ `Courts.charged(c)` | Prior arrests as Courts covariate | ABS Criminal Courts (linked to police) | Low | v0 |
| Courts ↔ Corrections | `Courts.handoffToCorrections(t)` ⟹ `Corrections.intake(t)` | Prior sentences as Courts covariate | Direct linkage; ABS, AIHW | Low | v0/v1 |
| Offending ↔ Corrections (recidivism) | none direct (must route via Police) | `Released` ⤿ ↑ Offending rate; `Prisoner` ⤿ rate = 0 | AIHW prisoner returns; ROGS | Medium — identification of multiplier vs base rate is the standard recidivism problem | v1 |
| **Justice ↔ outside** | | | | | |
| Justice ↔ Labour | `intake(Custody)` ⟹ `Labour.forcedExitIncarceration`; `sentenceComplete`/`parole` ⟹ `Labour.forcedReentryUnemployed`; `parole_revoked` ⟹ `forcedExitIncarceration` | Unemployment ⤿ ↑ offending; recent justice contact ⤿ ↑ job-separation, ↓ find-job | LFS marginals; HILDA panel; **PLIDA** for linked admin (restricted) | Medium-high — wire is clean; calibration is data-bound | v3 |
| Justice ↔ Education | `intake(Custody)` ⟹ `Education.forcedExitToCustody`; `parole`/`sentenceComplete` ⟹ optionally `Education.reentryAdult` | Low education ⤿ ↑ offending; justice contact ⤿ ↓ attainment | ACARA; NCVER VOCSTATS; PLIDA fragments | Medium — wire is clean; data is patchy outside PLIDA | v3 |
| **Outside ↔ outside** | | | | | |
| Education ↔ Labour | `Education.complete(level)` ⟹ `Labour.enterLF`; `jobSeparation` ⤿ optionally re-enrol | Education level as covariate of every Labour transition | NCVER; LFS; HILDA; ABS Education and Work | Low-medium — well-trodden | v3 |
| **Population ↔ all** | | | | | |
| Population ↔ each domain | `die` ⟹ `forcedTerminate`; `beBorn` ⟹ `forcedInitialise`; `emigrate` ⟹ `forcedSuspend`; `return` ⟹ `forcedReinstate` | Demographics as covariate of *every* kernel | ABS ERP; Births; Deaths; NOM | Low — abstract over a `Lifecycle` interface implemented by each lens | v1 |

#### Two structural observations

**Population is special.** Its wiring with every other lens has the same shape — the lifecycle hooks `{die, beBorn, emigrate, return}` synchronously force every domain lens into a terminal/initial/suspended state. Implement this once as a `Lifecycle` interface that each domain polynomial implements; the wiring with Population is then *generated*, not hand-written. Otherwise you'd write five copies of the same death-handling clauses.

**Skip-link couplings are kernel-only, not wiring.** The polynomial chain forces flows through the intermediates (Police, Courts), so couplings like Offending ↔ Corrections (recidivism) have no direct synchronous wire to author. The coupling lives entirely as a parameter modifier on next-tick Offending rates, conditioned on this-tick Corrections state. This keeps the wiring layer small and turns the cross-system effect into a covariate cell in the per-edge MLE (§5).

#### Recommended build order

1. **v0** — Within-Justice (Offending → Police → Courts, Corrections stub). Static Population. No Labour, no Education. *Wires: 3.*
2. **v1** — Full Corrections + recidivism kernel feedback. Real Population dynamics via the `Lifecycle` interface. *Wires: 4 within-Justice + 5 Population. Effort low because Lifecycle generates 4 of those.*
3. **v3a** — Add Labour. Wire to Justice (4 wires: incarceration, release×2, revoke), wire to Population. Calibrate cross-system rates from HILDA + LFS first; PLIDA later if accessible. *Wires: ~5 new.*
4. **v3b** — Add Education. Wire to Justice (1–2 wires), Labour (1 wire), Population. *Wires: ~3 new.*

Total wires across the full system once you reach v3b: **15–18 hand-authored wires** plus the generic `Lifecycle` projection. The hard work is *kernel calibration*, not wiring topology.

### 3.5 Worked example: wiring Justice and Labour

This section makes §2.3 concrete by wiring a minimal Labour polynomial against the Justice composite. It's the smallest non-trivial cross-domain example and the template every later cross-domain wiring follows.

#### 3.5.1 Labour polynomial

```text
─── Labour ──────────────────────────────────────────────────────────
pos              dir
NotInLF          { stay
                 , enterLF
                 , forcedReentryUnemployed   -- triggered externally
                 }
Employed         { stay
                 , jobSeparation → Unemployed
                 , retire → NotInLF
                 , forcedExitIncarceration   -- triggered externally
                 }
Unemployed       { stay
                 , findJob → Employed
                 , discouraged → NotInLF
                 , forcedExitIncarceration   -- triggered externally
                 }
─────────────────────────────────────────────────────────────────────
calibrated against: ABS Labour Force Survey; HILDA for transitions
```

The `forced…` directions are the **ports** through which an external wiring drives Labour. Labour's own kernel assigns them rate zero. They fire only when an outer wiring lens routes a synchronous joint direction into them.

#### 3.5.2 Parallel composite

```text
(Justice ⊗ Labour).pos      = Justice.pos × Labour.pos
(Justice ⊗ Labour).dir(j,l) = Justice.dir(j) × Labour.dir(l)
```

The parallel composite is permissive — it includes illegal joint states like `(Prisoner, Employed)`. The wiring lens cuts these down.

#### 3.5.3 Outer joint polynomial

```text
position                         meaning
Free.NotInLF                     no justice contact, out of LF
Free.Employed
Free.Unemployed
Defending.NotInLF                court process (pre-bail or on bail)
Defending.Employed
Defending.Unemployed
Remanded                         on remand → must be NotInLF
Incarcerated                     in prison  → must be NotInLF
ServingCommunity.{NotInLF,Employed,Unemployed}
OnParole.{NotInLF,Employed,Unemployed}
```

`Remanded` and `Incarcerated` collapse the labour dimension because labour state is deterministically `NotInLF` — the wiring constraint at the type level. Other joint positions retain both dimensions because labour state is genuinely independent.

#### 3.5.4 The wiring lens

```text
w : Justice ⊗ Labour → Joint
```

**Forward** (positions → positions):

```
w.fwd (NotInJustice, Employed)    = Free.Employed
w.fwd (Defendant,    Employed)    = Defending.Employed
w.fwd (OnRemand,     NotInLF)     = Remanded
w.fwd (Prisoner,     NotInLF)     = Incarcerated
w.fwd (Parolee,      Unemployed)  = OnParole.Unemployed

-- illegal: forward must still be total
w.fwd (Prisoner,     Employed)    = ⊥
w.fwd (OnRemand,     Employed)    = ⊥
```

`⊥` is unreachable if the dynamics are well-formed. In Lean we either return an `Option` or refine the inner state to exclude these.

**Backward** (joint direction → inner direction pair). This is where synchronisation lives:

```
-- pure justice transition, no labour effect
w.bwd (Defendant, Employed, "bail_granted_keep_job")
  = ( Justice.bailGranted,                Labour.stay )

-- pure labour transition while on bail
w.bwd (OnBail,    Employed, "lose_job")
  = ( Justice.continue,                   Labour.jobSeparation )

-- INCARCERATION: ONE joint direction = TWO inner directions in lockstep
w.bwd (Defendant, Employed, "sentenced_to_custody")
  = ( Courts.handoffToCorrections(Custody),
      Labour.forcedExitIncarceration )

-- RELEASE
w.bwd (Prisoner,  NotInLF,  "sentence_complete_release")
  = ( Corrections.sentenceComplete,
      Labour.forcedReentryUnemployed )

-- PAROLE REVOCATION re-incarcerates
w.bwd (Parolee,   Employed, "parole_revoked")
  = ( Corrections.revoke,                 Labour.forcedExitIncarceration )
```

The wiring's job is exactly to say *"fire these two inner directions together when the outside requests this joint direction"*.

#### 3.5.5 Worked transition — `Defending.Employed → Incarcerated`

Tick `t`:
1. Joint position is `Defending.Employed`. Joint kernel proposes joint direction `sentenced_to_custody` (with probability determined by trial outcome rates × custody rates, conditional on covariates).
2. Wiring backward decomposes: `Courts.handoffToCorrections(Custody)` for Justice; `Labour.forcedExitIncarceration` for Labour.
3. Inner systems each step in lockstep:
   - Courts: `Defendant → Sentenced(Custody)`, then via internal Justice wiring, Corrections: `NotInCorrections → Prisoner`.
   - Labour: `Employed → NotInLF[incarcerated]`.
4. Joint position at tick `t+1` is `Incarcerated`. Forward of the wiring confirms `w.fwd(Prisoner, NotInLF) = Incarcerated`.

Both inner systems advanced by one direction, in lockstep, driven by a single joint direction. That's the operadic content.

#### 3.5.6 What the wiring is *not* for

Synchronous coupling — incarceration forcing exit from labour force — is in the wiring. **Asynchronous feedback** is not:

- *Unemployment raises offending probability.* Parameter effect: `λ_offending(person, t)` depends on `person.labour_state_{t−1}`. Offending kernel reads the substrate and adjusts. No wiring change.
- *Recent criminal record raises job-separation rate.* `λ_jobSeparation(person, t)` depends on `person.justice_state_{t−1}`. Labour kernel reads, adjusts.

Synchronous coupling lives in the wiring; cross-system *propensities* live in kernels and are calibrated as ordinary covariate effects (see §3.4 catalogue).

#### 3.5.7 Implementation choice — joint kernel vs factored + wiring

Two ways to actually code this:

**Joint kernel.** One kernel table indexed by `(joint_pos, covariate_cell, joint_direction)`. Clean semantics; modest table size for a Joint with ~14 positions.

**Factored kernel + wiring.** Each inner has its own kernel; the wiring resolves "if Justice fires `handoffToCorrections(Custody)`, force Labour to fire `forcedExitIncarceration`, regardless of what Labour's own kernel would have done". Cheaper to estimate; Labour's "ordinary" rates calibrate against ABS LFS unconditionally on justice state. Cross-system effects (e.g. job-separation conditional on bail status) live as covariate effects on the Labour kernel.

**Choice for `obs`: factored + wiring.** Wiring expresses *deterministic* joint transitions (incarceration, release, revocation); kernels express *probabilistic* same-tick coupling via covariates. Matches the data shape — most flow data is per-system; linked-data sources estimate cross-system covariates.

#### 3.5.8 IR shape for a wiring

```json
{
  "wiring_id": "justice_x_labour",
  "inner_lenses": ["justice", "labour"],
  "outer_polynomial": "joint_jl",
  "fwd_map": [
    {"inner_pos": ["Prisoner", "NotInLF"],  "outer_pos": "Incarcerated"},
    {"inner_pos": ["Defendant", "Employed"], "outer_pos": "Defending.Employed"}
  ],
  "bwd_map": [
    {
      "outer_dir": "sentenced_to_custody",
      "outer_pos_pattern": ["Defendant", "*"],
      "inner_dirs": {
        "justice": "handoffToCorrections(Custody)",
        "labour":  "forcedExitIncarceration"
      }
    }
  ]
}
```

The DuckDB compiler turns this into (a) constraint checks ensuring no person ever ends up at a `⊥` joint position, (b) a routing table the simulation step joins against to resolve sampled outer directions into inner direction pairs.

### 3.6 Marginal-schema olog: the common ground for calibration

Calibration compares simulator output against published aggregate statistics. To make that comparison precise we need an explicit, typed schema for "what a comparable summary looks like". This subsection defines that schema as a Spivak-style **olog** — a small finitely-presented category whose objects are types and whose arrows are functional aspects (Spivak & Kent, *PLoS ONE* 2012). Both the simulator and the empirical data are realised as instances of this olog via schema morphisms; calibration loss is computed at the olog level.

#### 3.6.1 Three ologs

Three schemas are involved in calibration.

- **`S_sim`** — the simulator schema. Types include `[a person]`, `[an event]`, `[a position]`, `[a direction]`, `[a covariate cell]`. The events table (§2.6.4) is an instance `I_sim : S_sim → Set`.
- **`S_emp,k`** for each empirical source `k` — one olog per source (ABS Recorded Crime, ABS Criminal Courts, AIHW Prisoners, AIC, ROGS, etc.). Types reflect what the source actually publishes; instances `I_emp,k : S_emp,k → Set` are the loaded tables.
- **`M`** — the **marginal-schema olog**. The lingua franca for calibration. Types include `[a person]`, `[indigenous status]`, `[corrections status]`, `[age band]`, `[a period]`, `[a transition count cell]`. Aspects connect them — see §3.6.4 for the v0 starter set.

#### 3.6.2 Schema morphisms

The marginal-schema olog `M` is connected to the simulator and to each empirical source via schema morphisms:

```text
        Φ              Ψ_k
   M  ─────►  S_sim     M  ─────►  S_emp,k     for each empirical source k
```

`Φ` says how a marginal-schema concept is realised inside the simulator schema. `Ψ_k` says the same for empirical source `k`. For example:

- `[a person] –has corrections status–> [corrections position]` in `M` realises in `S_sim` as: latest event in events table per person, restricted to `lens = 'corrections'`, projected to its `to_state` field.
- The same aspect realises in `S_aihw_prisoners` as: a row's `position` column from a stock-snapshot table.

The morphisms are typed mappings between schemas. Composition checks (path equivalences from `M` to either side) make these mappings *testable*.

#### 3.6.3 Calibration as comparison in `Inst(M)`

The Δ-pullback (functorial data migration; Spivak's *FDM*) ferries instances along schema morphisms in the *opposite* direction:

$$ I_M^{\mathrm{sim}} \;:=\; \Delta_\Phi(I_{\mathrm{sim}}) \qquad I_M^{\mathrm{emp},k} \;:=\; \Delta_{\Psi_k}(I_{\mathrm{emp},k}) $$

Both are instances of the *same* schema `M`. Calibration loss is then a divergence between two instances of `M`:

$$ \mathcal{L} \;=\; d\big(I_M^{\mathrm{sim}},\; I_M^{\mathrm{emp},k}\big) $$

for some chosen divergence (KL, χ², Hellinger). The categorical content is: *both sides of the comparison are typed at the marginal-schema level*, and the typing is enforced by the schema morphisms.

For seed-population synthesis (§6.1), the right Kan extension `Π_Ψ` gives the most-restrictive simulator-schema instance compatible with observed marginals — categorically, this is what IPF computes.

#### 3.6.4 The marginal-schema olog for v0

Starter set, sufficient for the v0 vertical slice (Population + Offending + Police + Courts):

```text
─── Marginal-schema olog M (v0) ─────────────────────────────────────
[a person]               –has indigenous status–>  [indigenous status]
[a person]               –has age band–>           [age band]
[a person]               –has sex–>                [sex]
[a person]               –has region class–>       [region class]
[a person]               –has police status–>      [police position]
[a person]               –has courts status–>      [courts position]

[a transition count cell] –is over period–>          [a period]
[a transition count cell] –is for lens–>             [a lens]
[a transition count cell] –is for from-state–>       [a position]
[a transition count cell] –is for to-direction–>     [a direction]
[a transition count cell] –is for covariate cell–>   [a covariate cell]
[a transition count cell] –has count–>               [a non-negative integer]

[a covariate cell] –has age band–>          [age band]
[a covariate cell] –has sex–>               [sex]
[a covariate cell] –has indigenous status–> [indigenous status]
[a covariate cell] –has region class–>      [region class]

[a stock-snapshot cell]  –is at time–>          [an instant]
[a stock-snapshot cell]  –is for lens–>         [a lens]
[a stock-snapshot cell]  –is for position–>     [a position]
[a stock-snapshot cell]  –is for covariate cell–> [a covariate cell]
[a stock-snapshot cell]  –has count–>           [a non-negative integer]
─────────────────────────────────────────────────────────────────────
Commutativity: the obvious aggregation diagrams
  e.g. for any [a covariate cell], its component aspects must agree
       with the corresponding aspects of [a person] under aggregation.
```

This olog is small, but it captures every calibration target the v0 slice cares about: per-cell flow counts, per-cell stock counts, and the demographic axes along which both are sliced.

#### 3.6.5 Implementation approach

Two principles.

**Make `M` formal; keep `S_emp,k` informal.**

- `M` and `Φ : M → S_sim` are encoded in Lean alongside the polynomial-functor IR (§4.1, Layer 2). Each type becomes a Lean type; each aspect becomes a function; each commutativity equation becomes a stated `theorem` (proof deferred to v5, alongside other proofs).
- `Ψ_k : M → S_emp,k` is encoded informally as a Python module that knows how to load source `k` and project it to `Inst(M)`. Promote individual `Ψ_k` to formal Lean morphisms only when source-specific pain forces it.

**Generate DuckDB views from the schema morphisms.**

For each schema morphism, the compiler emits a SQL view producing the marginal-schema instance:

```sql
CREATE VIEW marginal_from_simulator AS  -- Δ_Φ(I_sim)
  SELECT person_id, indigenous_status, age_band, sex, region_class,
         <latest police position>, <latest courts position>
  FROM person_state JOIN events ...;

CREATE VIEW marginal_from_abs_courts AS  -- Δ_Ψ_abs(I_abs_courts)
  SELECT cell_key, period, count
  FROM abs_courts_table;
```

The calibration loss is then a `JOIN` across these views per per-lens cell. The conjugate-update query of §5.1 / §5.2 is unchanged in shape — it just sources its `count` column from `marginal_from_abs_courts` rather than from a hand-prepared table, with the projection guaranteed correct by the schema morphism.

#### 3.6.6 Categorical fit with the rest of the architecture

Three places this slots cleanly into the existing apparatus.

**(1) Modularity (§5.3 / Module 9.4) sharpens.** `M` factors as a wide pullback over `[a person]`:

$$ M \;\cong\; M_{\mathrm{Pop}} \times_{[\text{a person}]} M_{\mathrm{Off}} \times_{[\text{a person}]} M_{\mathrm{Pol}} \times_{[\text{a person}]} \cdots $$

Each lens contributes its own marginal sub-olog; they share only the `[a person]` substrate. Calibration is independent across factors because Δ distributes over the wide pullback. This is the categorical reason "five independent DuckDB queries" works.

**(2) Substrate (§3.1) is an olog fragment.** The fibration `π : ⨿_L S_L → Person` corresponds to the small `M` fragment with type `[a person]` plus the per-lens position type and the aspect `–has L status–>`. The fibration view is one slice of `M`.

**(3) Cross-source disagreement becomes commutativity failure.** When ABS Criminal Courts and AIHW Prisoners disagree on a quantity that *both* sources should report (e.g. people sentenced to custody in 2023), the diagram

$$ I_{\mathrm{abs}} \;\xleftarrow{\Psi_{\mathrm{abs}}}\; M \;\xrightarrow{\Psi_{\mathrm{aihw}}}\; I_{\mathrm{aihw}} $$

fails to commute on a particular path. The olog framework makes the disagreement *visible* and gives a place to record the reconciliation choice (which source to trust, on which cell, with what justification).

#### 3.6.7 What's deferred

- **Formalising `S_emp,k` ologs.** The empirical-source schemas are kept informal in v1. Promote them when a source change breaks more than one downstream query.
- **AQL / CQL tooling.** Wisnesky's Categorical Query Language directly implements ologs + functorial data migration. Adoption deferred indefinitely — categorical content is the goal, not the specific tool.
- **Π and Σ migrations.** v1 uses Δ exclusively (marginalisation). The right Kan `Π` enters at seed-population synthesis (§6.1). The left Kan `Σ` is unused for now; could appear if we ever need to extrapolate sparse marginals to a fuller schema.
- **Commutativity proofs in Lean.** The diagrams are stated but unproved in v1, consistent with the typed-DSL-only Lean posture (§7).

#### 3.6.8 Why this is worth doing

Three concrete payoffs the rest of the architecture does not already provide.

1. An explicit, typed artefact for "what we calibrate against". Currently implicit (column-name conventions across DuckDB). Becomes a first-class file.
2. Source-to-marginal mappings as commit-able, reviewable code. When a source reissues a series with a new layout, you rewrite one Ψ rather than scatter changes across queries.
3. Diagram-commutativity as unit tests. "Total over indigenous status equals total people" is a categorical equation that can be auto-checked rather than visually verified.

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

The data on each side of the comparison (simulator output vs observed) is typed at the marginal-schema olog level (§3.6). Both sides project to `Inst(M)` via Δ-pullback; the conjugate-update SQL of §5.1 / §5.2 sources its `count` column from the resulting views. The categorical reason the per-lens decomposition holds is that `M` factors as a wide pullback over `[a person]` (§3.6.6); the per-lens factors of `θ` correspond to the per-lens factors of `M`.

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
│       ├── Wiring.lean          -- the cross-lens wirings, root spec
│       ├── Olog.lean            -- Olog type + schema-morphism shape (§3.6)
│       └── MarginalSchema.lean  -- the marginal-schema olog M and Φ : M → S_sim
├── ir/
│   ├── schema.json              -- IR JSON Schema
│   └── marginal_schema.json     -- emitted M and Φ definitions (§3.6)
├── compiler/
│   ├── pyproject.toml
│   └── obs_compiler/
│       ├── ir.py                -- pydantic models matching schema
│       ├── duckdb_emit.py       -- IR → DDL + SQL macros
│       ├── marginal_emit.py     -- marginal-schema IR → SQL views (§3.6)
│       ├── calibrate.py         -- per-lens MLE queries
│       └── driver.py            -- run loop
├── empirical/
│   ├── abs_courts.py            -- Ψ_abs : M → S_abs_courts (informal in v1)
│   ├── aihw_prisoners.py        -- Ψ_aihw : M → S_aihw_prisoners
│   └── ...                      -- one Ψ per source
├── seed/
│   └── seed_population.py       -- ABS TableBuilder + IPF (Π_Ψ for the seed-marginal schema)
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
| Additive trace | The `(draw, split, accumulate, emit)` operator on each lens that folds within-period events into a per-period observable; categorically, a trace on `p_L → p_L`. |
| Trace accumulator | The (commutative) monoid in which the trace's per-event fold lives — typically counts or time-weighted state stocks. |
| Topological sweep | One pass per period over the synchronous-wire DAG of lenses, processing each lens once in dependency order. |
| Events table | Canonical simulator output: one row per fired transition, keyed by `(person_id, lens, event_time, direction)`. All other artefacts (stocks, flows, period summaries) are derived. |
| Reporting period (`Δt`) | Observation window over the event stream; enters the simulator only at the period-boundary check and at `emit`. |
| Olog | Spivak/Kent ontology log: a finitely-presented category whose objects are types (boxes labelled by noun phrases) and arrows are functional aspects (verb-phrase labels), with commutativity equations. |
| Marginal-schema olog (`M`) | The common-ground olog used for calibration: types like `[a person]`, `[a transition count cell]`, `[a stock-snapshot cell]` plus aspects connecting them to demographic and per-lens position types. |
| Schema morphism (`Φ`, `Ψ`) | A typed mapping between ologs; in `obs`, `Φ : M → S_sim` from marginal schema to simulator schema, and `Ψ_k : M → S_emp,k` for each empirical source. |
| Δ-pullback | Functorial data migration along a schema morphism; produces an `M`-instance from a larger-schema instance. The categorical version of marginalisation. |
| Π / Σ migrations | Right and left Kan extensions along a schema morphism. `Π` is used for seed-population synthesis (IPF); `Σ` is unused in v1. |
| IR | The JSON intermediate representation between Lean and DuckDB. |
| Cell | A combination of covariate values that indexes parameter rows. |

## 9. References

- Spivak, Niu — *Polynomial Functors: A Mathematical Theory of Interaction* — [PDF](theory-documents/Polynomial%20Functors_%20A%20Mathematical%20Theory%20of%20Interaction.pdf).
- Gavranović — *Fundamental Components of Deep Learning: A category-theoretic approach* — [PDF](theory-documents/Fundamental%20Components%20of%20Deep%20Learning.pdf).
- Libkind, Myers — *Towards a double operadic theory of systems* — [PDF](theory-documents/Towards%20a%20double%20operadic%20theory%20of%20systems.pdf).
- Spivak, Kent — *Ologs: A Categorical Framework for Knowledge Representation* — *PLoS ONE* 7(1):e24274, 2012. The marginal-schema olog of §3.6 follows this framework.
- Spivak — *Functorial Data Migration* — arXiv:1009.1166, 2010. Source for the Δ / Π / Σ migrations underpinning §3.6.
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
- **Marginal-schema olog scope (§3.6).** v0 covers Population + Police + Courts. Extend `M` as Offending, Corrections, Labour, Education are added — open question whether to grow `M` monolithically or factor it as a colimit of per-lens sub-ologs glued along `[a person]`.
- **Empirical-source ologs.** Currently `Ψ_k : M → S_emp,k` is informal Python. Promote to formal Lean morphisms when source-specific schema churn forces it.
- **Cross-source reconciliation.** When two empirical sources give incompatible `M`-instances (e.g. ABS vs AIHW disagreement on custody counts), the diagram fails to commute. Need an explicit per-cell reconciliation policy — flagged but unresolved.

## 11. Out of scope for v1

- Real Bayesian uncertainty quantification on calibrated parameters.
- Spatially explicit movement (region transitions are demographic only, not modelled as a spatial diffusion).
- Court appeal pathways (treated as outside the polynomial).
- Federal vs state jurisdictional differentiation.
- Cost / fiscal accounting on top of the simulator.
