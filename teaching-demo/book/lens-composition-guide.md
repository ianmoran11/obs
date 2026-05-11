# Lens & System Composition — A Reader's Guide

**A companion to `index.md`.** This file exists to untangle one particular
knot in the main book: the word *lens* is used in two very different senses
in the literature, and the difference matters once you try to combine
systems. The guide also walks through what "system composition" actually
buys you when you set out to build a joint model, and what it does *not*
do for you.

It is written to be read linearly, like a short book chapter inside
Obsidian.

---

## Table of contents

- [1. Why this guide exists](#1-why-this-guide-exists)
- [2. Two different things both called "lens"](#2-two-different-things-both-called-lens)
- [3. The verdict on the original advice](#3-the-verdict-on-the-original-advice)
- [4. The architectural difference, concretely](#4-the-architectural-difference-concretely)
- [5. What system composition actually gives you](#5-what-system-composition-actually-gives-you)
- [6. Hard vs soft coupling](#6-hard-vs-soft-coupling)
- [7. What system composition does NOT give you](#7-what-system-composition-does-not-give-you)
- [8. Cheat sheet](#8-cheat-sheet)

---

## 1. Why this guide exists

When you first read the main book, you wrote some pseudocode that looked
roughly like this:

```typescript
Type Lens<S, A> {
  get: Function(S) -> A
  set: Function(S, A) -> S
}

Function modify<S, A>(lens, state, updateFn) -> S {
  let part = lens.get(state)
  let next = stepForward(part)
  return lens.set(state, next)
}
```

That is a perfectly correct, standard FP-style lens. It is the shape
people learn when they first meet lenses in Haskell, Scala, or TypeScript.
But the main book's "lens" is doing something structurally different, and
the conversation you had with the assistant kept brushing past that
difference.

This guide makes the difference explicit, then explains what changes when
you try to build a joint Labour × Education × Justice model in each
style.

> [!tip]
> If you remember only one thing from this guide: an FP lens is about
> **reaching into data**, while a polynomial lens is about **plugging
> interfaces together**. They share a name and a forward/backward
> shape, but they answer different questions.

---

## 2. Two different things both called "lens"

### 2.1 The FP lens

An FP lens is a **data accessor**. Its job is to focus on a part of a
larger immutable record so you can read it or update it without rewriting
the whole structure by hand.

```typescript
Type Lens<S, A> {
  get: (S) -> A           // pull the part out of the whole
  set: (S, A) -> S        // put a (possibly new) part back into the whole
}
```

Key features:

- The types `S` and `A` are **data types**. `S` is the outer record;
  `A` is the inner field.
- The operations `get` and `set` are pure plumbing. They don't model
  any dynamics.
- Composition (`outer ∘ inner`) is composition of accessors: it lets
  you reach deeper into nested records.

You'll often see this written more abstractly as
`(S → A) × (S × A → S)`. That's still just data extraction and
reinsertion.

### 2.2 The polynomial / parametric lens

A polynomial lens is a **morphism between interfaces**, where each
interface is a polynomial functor. The interfaces have *positions*
(what the system can currently expose) and *directions* (what events can
fire from each position).

```text
Forward:   φ      : positions(p) → positions(q)
Backward:  φ^♯_i  : directions(q at φ(i)) → directions(p at i)
```

In words:

- The **forward leg** says "given the inner system is in position `i`,
  here is the outer position to expose."
- The **backward leg** says "if the outer interface fires a direction,
  here is the corresponding direction inside the inner system."

When you add the `Para` construction on top, you get a *parametric*
lens, where parameters `Θ` are threaded through both legs:

```text
fwd : Θ × pos(p) → pos(q)                       // simulate
bwd : Θ × pos(p) × dir(q) → Θ × dir(p)          // calibrate / propagate
```

Key features:

- The types are **interfaces**, not records. A position is a state of
  the system; a direction is a labelled transition.
- The forward leg is the **simulator step**; the backward leg is the
  **calibration step** (or, in ML, the chain-rule step).
- Composition is composition in the category `Para(Lens(C))` — when
  you compose two lenses, the parameter spaces tensor and the forward
  and backward legs glue along the shared interface.

### 2.3 Side-by-side

| Question | FP lens | Polynomial / parametric lens |
| --- | --- | --- |
| What does it focus on? | A field inside a record | A labelled interface of a state machine |
| What do `fwd`/`get` and `bwd`/`set` do? | Read and write data | Simulate one step and propagate the resulting event |
| What composes? | Nested accessors | Parametric morphisms in `Para(Lens(C))` |
| What scales with you? | Depth of record nesting | Number of interacting subsystems |
| Where does `Θ` live? | Not really part of the structure | Threaded through both legs by construction |
| What does it *not* do? | Define dynamics or events | Reach into arbitrary fields of an unrelated record |

### 2.4 Why the names collide

The shapes look similar — both have a "forward" half and a "backward"
half, both can be composed, and both let you treat a big system as if
it were a focus on a smaller part. Categorically, FP lenses are a
special case of more general lenses (sometimes called *bidirectional
transformations*), and polynomial lenses live in a different but
related category (`Poly`). So they really are cousins; they are not the
same thing, and they were designed for different problems.

> [!note]
> A useful slogan: the FP lens is a lens on **data**, the polynomial
> lens is a lens on **behaviour**.

---

## 3. The verdict on the original advice

The exchange in the original document ended with some confident claims
that are *directionally* right but **overstated** in three places. The
honest, toned-down version is:

> [!summary] Toned-down verdict
> 1. **FP-lens code is feasible.** It is a perfectly reasonable
>    architecture for a microsimulator. It is not "wrong"; it just
>    organises the problem around data shape rather than behaviour.
> 2. **Bayesian conjugate updates do still use a likelihood.** In the
>    Dirichlet–Categorical case the likelihood happens to reduce to
>    "add observed counts to prior pseudo-counts," which is why the
>    update *looks* like it has no loss step. That is a property of
>    conjugacy, not a property of categorical lenses.
> 3. **Composition is not magic.** The categorical framework gives
>    you a disciplined place to put each piece, but you still have to
>    define the composition operator, the wiring rules, the data
>    schema, and the event-time loop. The category doesn't write
>    those for you.
> 4. **The ML backward leg needs more than a parameter update.** A
>    correct compositional learner returns both an updated parameter
>    and an *input-side gradient* (sometimes called a "request"). The
>    book's pseudocode omits this and that omission is not
>    cosmetic — it's what makes layers compose into a chain rule.

The shape that is genuinely correct in the original advice:

- The FP lens approach is a **data-accessor architecture**.
- The polynomial/parametric approach is a **compositional interface
  architecture**.
- The latter pays a higher up-front cost in abstraction in exchange
  for a cleaner answer to "what happens when I wire two subsystems
  together?"

---

## 4. The architectural difference, concretely

Here is the cleanest single sentence:

> **Old approach:** build one big joint model, then use lenses to reach
> into it.
>
> **Later approach:** build small separate models, then use typed
> wirings to join them.

### 4.1 The example

Justice has just transitioned from `free` to `imprisoned`. Labour must
become `NILF`. How does each architecture handle it?

### 4.2 FP-lens version

```typescript
function runJointStep(state, params) {
  let justice = justiceLens.get(state)
  let labour  = labourLens.get(state)

  let newJustice = runJustice(justice, params.justice)

  if (newJustice === "imprisoned") {
    labour = "NILF"
  }

  return { ...state, justice: newJustice, labour: labour }
}
```

The joint behaviour lives in `runJointStep`. That function has to know:

- how Justice steps,
- how Labour steps,
- how Justice forces Labour,
- how to record events for calibration,
- how to keep parameters aligned.

Add Education and now `runJointStep` grows to handle more cases. Add
Healthcare and it grows again. The cross-effects pile up inside a
single procedural function.

### 4.3 Polynomial / parametric version

Each subsystem is defined independently with its own positions and
directions:

```text
Justice states:    free | accused | imprisoned
Justice events:    free_to_accused, accused_to_imprisoned,
                   accused_to_free, imprisoned_to_free

Labour states:     working | unemployed | NILF
```

Cross-effects live in **wirings** — small total functions that say
"when this Justice event fires, here is what happens to Labour":

```text
wireJusticeToLabour oldJ newJ labour :=
  match oldJ, newJ with
  | _,           imprisoned => NILF
  | imprisoned,  free       => unemployed
  | _,           _          => labour
```

The joint behaviour is then:

```text
Justice lens
+ Labour lens
+ Education lens
+ wirings between them
+ generic event-time loop (earliest competing exponential wins)
+ calibration that reads named events
```

### 4.4 Side-by-side

| Question | FP-lens approach | Parametric-lens approach |
| --- | --- | --- |
| What is a lens? | A data accessor | A behavioural unit with states, events, simulation, and update |
| Where does the joint model live? | Inside a hand-written `runJointStep` | In the composition of small lenses plus wirings |
| How are cross-effects expressed? | Manual `if`/`switch` logic | Separate wiring functions |
| Adding a new domain? | Edit the joint function | Add a new lens; define its wirings |
| What does calibration count? | Whatever the custom code recorded | Named transition directions from each lens |
| Main risk | The orchestrator becomes a tangle | More abstraction up front |

> [!tip]
> The categorical approach does not remove modelling decisions. It
> gives each decision a typed place to live.

---

## 5. What system composition actually gives you

Six concrete things, in order of importance:

### 5.1 Each domain keeps its own typed interface

Instead of starting from a single mega-state `Person × Labour × Education
× Justice`, you describe each subsystem as a small typed state machine.
The labels on its transitions are exactly what calibration will later
count. Without labelled directions, calibration has no targets.

### 5.2 The joint state is a product, but the joint behaviour is not

```text
JointState := Person × Labour × Education × Justice
```

This gives you the *carrier*. It does not give you the rules. The raw
product would allow nonsense like "imprisoned and working." Wirings
**cut the product down** to legal behaviour.

### 5.3 Wirings express cross-lens causal constraints

Instead of writing every joint transition by hand, you write small local
rules:

```text
Justice imprisonment  → Labour becomes NILF
Justice imprisonment  → Education becomes notStudying
Education entry       → Labour becomes NILF
Leaving education     → Labour becomes unemployed
Age under 16          → Education becomes inSchool
```

This is the **strongest practical benefit**. The joint model is now:

```text
local transition + wiring consequences
```

rather than:

```text
enumerate every possible joint transition
```

### 5.4 An event-time loop composes the lenses dynamically

```text
At time t:
  draw next Labour event
  draw next Education event
  draw next Justice event
  choose earliest
  apply that lens's transition
  apply wirings
  record event for calibration
  advance time, repeat
```

You get a precise joint stochastic process without ever writing a
hand-built global transition matrix.

### 5.5 Parameter spaces compose by tensor

```text
Θ_joint = Θ_labour ⊗ Θ_education ⊗ Θ_justice
```

So you update Labour parameters from Labour events, Education
parameters from Education events, and so on, instead of running one
opaque mega-parameter object.

### 5.6 The substrate (`Person`) is shared, not duplicated

`Person` carries demographic state (age, sex, region, cohort). Each
lens *reads* from it; only the Population lens *writes* to it. When the
substrate changes (e.g., ageing), all lenses see the change without you
patching each one.

---

## 6. Hard vs soft coupling

There are two distinct ways one system can affect another, and the
book mostly shows the first. The framework supports both, but the
calibration story is different in each case.

### 6.1 Hard coupling (wirings)

A transition in system A **directly changes the state** of system B.

```text
Justice: free → imprisoned     forces     Labour: → NILF
```

Implemented as a wiring function. State-level effect.

### 6.2 Soft coupling (rate dependencies)

The state of system A **changes the probabilities** of B's transitions.

```text
Labour = unemployed   raises the rate of   Education: → inUniversity
Education = notStudying   raises the rate of   Justice: → accused
```

Implemented by letting the rate kernel read from the joint state, not
just its own lens's state:

```typescript
function drawJustice(params, jointState) {
  const rates = params.justiceRates[
    jointState.person.cell,
    jointState.justice,
    jointState.labour,
    jointState.education,
  ]
  return sampleNextJusticeEvent(rates)
}
```

### 6.3 The calibration cost of soft coupling

Modular case — Justice rates depend only on `(cell, justice_state)`:

```text
calibration groups by: cell, justice_from_state, justice_direction
```

Cross-lens case — Justice rates depend on Labour too:

```text
calibration groups by: cell, justice_from_state, labour_state, justice_direction
```

The grouping dimension grows. The framework still handles it cleanly,
but you have made the model genuinely more complex, and that complexity
is honestly recorded in the schema.

> [!warning]
> Soft coupling is where it's tempting to "just add an `if`." Resist.
> Putting the dependency into the rate kernel keeps it visible to the
> calibration schema.

---

## 7. What system composition does NOT give you

Three honest caveats, because the original advice was too cheerful here:

### 7.1 It does not discover the model for you

You still decide:

- Does imprisonment force NILF, or merely make it more likely?
- Does release imply unemployment?
- Can university students work?
- Does Labour status feed back into Justice rates?
- Should some rates depend on the full joint state?

Composition is a **place to put each answer**, not the answer itself.

### 7.2 It does not eliminate the likelihood in Bayesian updating

The Dirichlet–Categorical conjugate update *looks* loss-free because
the likelihood simplifies to count addition. That is a property of
**conjugacy**, not a property of lenses. Non-conjugate Bayesian models
still need explicit likelihood evaluation.

### 7.3 It does not let the backward leg drop the input gradient

In the ML interpretation, the correct signature is:

```text
bwd : (Θ, input, output_gradient) -> (Θ', input_gradient)
```

The `input_gradient` (the "request" in the open-learner literature) is
how composed layers propagate error backward. Drop it, and your "free"
chain-rule composition stops working at exactly the moment you try to
stack two learners. The original document mentions this only in
passing; treat it as central.

---

## 8. Cheat sheet

> [!summary] One-line definitions
>
> - **FP lens.** Pair of `(get, set)`. Reaches into a data structure.
> - **Polynomial lens.** Forward map of positions plus backward map of
>   directions. Plugs interfaces together.
> - **Parametric lens.** Polynomial lens with parameters `Θ` threaded
>   through both legs. Forward = simulate; backward = update / propagate.
> - **Wiring.** A typed cross-lens rule: when this direction fires
>   here, that lens changes there.
> - **Hard coupling.** A wiring that changes another lens's *state*.
> - **Soft coupling.** A rate kernel that depends on another lens's
>   *state*, changing the other lens's *probabilities*.
> - **Substrate.** Shared base (here, `Person`) that all lenses read
>   from and only a privileged lens (Population) writes to.

> [!summary] Two architectural mantras
>
> *Old:* build the whole machine, then reach into its parts with lenses.
>
> *New:* build each part as a small machine, then declare how the
> machines are wired together.

### Where to read next

- [`index.md`](index.md), Module 3 — Parametric lenses
- [`index.md`](index.md), Module 7 — Wirings (double categories)
- [`index.md`](index.md), Module 8 — Substrate as fibration
- [`index.md`](index.md), Module 10 — Calibration as backward leg
