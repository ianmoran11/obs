## Labour and Justice as Polynomial Functors (Lean 4)

**Companion to [`LabourJustice.lean`](LabourJustice.lean).** This file
walks through that Lean file section by section. The goal is not to
teach Lean syntax — it is to show how the labour-and-prison demo from
[`labour-prison-demo.md`](labour-prison-demo.md) looks when you give
each subsystem its proper categorical shape: a **polynomial functor**.

The Python demo used Python dicts of strings and dicts. Lean lets us be
exact about the structure: positions are an inductive type, directions
are a *dependent* inductive (different constructors at different
positions), and the coalgebra `step : S → Σᵢ (Dir i → S)` is the
literal polynomial-coalgebra signature from Module 1 of the main book.

This version (PR #9) refactors the wirings into a **first-class
algebraic object**. They are no longer buried inside the joint
coalgebra's step function. They live in their own type `Wiring p S`,
they compose, they have an identity, and they *act* on coalgebras via
a clean operation `Coalgebra.wire`.

> [!tip] One-line summary
> A polynomial functor is "positions, and for each position, the names
> of its outgoing transitions." A wiring is a typed post-processor on
> the next-state values of a coalgebra over that polynomial functor.
> Wirings form a monoid; applying a wiring to a coalgebra is a typed
> operation.

---

## Table of contents

- [1. Polynomial and Coalgebra structures (§1)](#1-polynomial-and-coalgebra-structures-1)
- [2. The Justice subsystem (§2)](#2-the-justice-subsystem-2)
- [3. The Labour subsystem (§3)](#3-the-labour-subsystem-3)
- [4. Tensor and the raw parallel coalgebra (§4)](#4-tensor-and-the-raw-parallel-coalgebra-4)
- [5. Wirings as a separate algebraic object (§5)](#5-wirings-as-a-separate-algebraic-object-5)
- [6. The two wirings of the labour/justice system (§6)](#6-the-two-wirings-of-the-labourjustice-system-6)
- [7. The wired joint coalgebra by composition (§7)](#7-the-wired-joint-coalgebra-by-composition-7)
- [8. Concrete one-step examples (§8)](#8-concrete-one-step-examples-8)
- [9. What this gives you and what it leaves out](#9-what-this-gives-you-and-what-it-leaves-out)

---

## 1. Polynomial and Coalgebra structures (§1)

```lean
structure Polynomial where
  Pos : Type
  Dir : Pos → Type

structure Coalgebra (p : Polynomial) (S : Type) where
  step : S → (i : p.Pos) ×' (p.Dir i → S)
```

`Polynomial` is a record of two fields: a position type and a
*direction* family indexed by positions. The direction family is the
crucial thing — different positions can have different sets of
directions. That is the polynomial-functor signature
$p(X) = \sum_{i \in \text{Pos}} X^{\text{Dir}(i)}$.

`Coalgebra` over a carrier `S` is the simulator step: at each state,
name the position you're in (`i : p.Pos`) and provide a next-state per
direction (`p.Dir i → S`). The `×'` is Lean's `PSigma` — a dependent
pair where the second component's type depends on the first.

---

## 2. The Justice subsystem (§2)

```lean
inductive JState | free | accused | imprisoned
  deriving Repr, DecidableEq, Inhabited

inductive JDir : JState → Type
  | free_to_accused       : JDir .free
  | accused_to_imprisoned : JDir .accused
  | accused_to_free       : JDir .accused
  | imprisoned_to_free    : JDir .imprisoned
```

`JState` is a flat enum of three positions. `JDir` is a **dependent
inductive**: each constructor lists the state it is a direction out
of. `JDir .free` has one inhabitant; `JDir .accused` has two; `JDir
.imprisoned` has one. The typechecker forbids firing a direction from
a state for which there is no constructor.

```lean
def jNext : (s : JState) → JDir s → JState
  | _, .free_to_accused       => .accused
  | _, .accused_to_imprisoned => .imprisoned
  | _, .accused_to_free       => .free
  | _, .imprisoned_to_free    => .free

def jCoalg : Coalgebra jPoly JState where
  step s := ⟨s, jNext s⟩
```

The coalgebra says "the position equals the current state, and the
next-state per direction is `jNext s`."

---

## 3. The Labour subsystem (§3)

Same pattern, different labels:

```lean
inductive LState | working | unemployed | NILF
  deriving Repr, DecidableEq, Inhabited

inductive LDir : LState → Type
  | lose_job       : LDir .working
  | leave_force    : LDir .working
  | find_job       : LDir .unemployed
  | give_up        : LDir .unemployed
  | return_to_work : LDir .NILF
```

`LDir .working` has *two* constructors but `LDir .NILF` has only one:
the branching factor differs by position. That is the whole point of
a polynomial functor — flat-matrix presentations cannot do this.

---

## 4. Tensor and the raw parallel coalgebra (§4)

```lean
def Polynomial.tensor (p q : Polynomial) : Polynomial where
  Pos := p.Pos × q.Pos
  Dir := fun ij => p.Dir ij.1 ⊕ q.Dir ij.2
```

Tensor in `Poly`: positions multiply, directions sum. At joint
position `(i, j)`, a joint direction is **either** a `p`-direction out
of `i` **or** a `q`-direction out of `j` — never both. That's the
polynomial functor's way of saying "one event fires at a time."

```lean
def parallel {p q : Polynomial} {S T : Type}
    (c : Coalgebra p S) (d : Coalgebra q T) :
    Coalgebra (p.tensor q) (S × T) where
  step st :=
    let cs := c.step st.1
    let dt := d.step st.2
    ⟨(cs.1, dt.1), fun
      | .inl ds  => (cs.2 ds, st.2)
      | .inr ds' => (st.1, dt.2 ds')⟩

def rawJoint : Coalgebra (jPoly.tensor lPoly) (JState × LState) :=
  parallel jCoalg lCoalg
```

`rawJoint` is the **uncoupled** joint dynamics. It allows all 9 joint
cells of `JState × LState`, including the illegal ones. The wirings
in §5–§7 fix that *without modifying `rawJoint`*.

---

## 5. Wirings as a separate algebraic object (§5)

This is the part that's new in this version of the file.

```lean
def Wiring (p : Polynomial) (S : Type) : Type :=
  (i : p.Pos) → p.Dir i → S → S
```

A `Wiring p S` is a typed post-processor on next-state values. Given
the firing position `i`, the firing direction `d : p.Dir i`, and the
raw next-state `s : S`, it returns a (possibly different) next-state.

> [!note] Why the position is fixed
> A wiring cannot rewrite the position the coalgebra reports. If it
> could, the direction set would change — `p.Dir i'` instead of
> `p.Dir i` — and the next-state function `k : p.Dir i → S` would no
> longer typecheck. This is the same reason a position-relabelling
> can't be a `Poly` morphism, as discussed in the previous chat: the
> direction sets at the two positions don't match in general.

Wirings have a monoid structure:

```lean
namespace Wiring

def id {p : Polynomial} {S : Type} : Wiring p S :=
  fun _ _ s => s

def comp {p : Polynomial} {S : Type} (w₁ w₂ : Wiring p S) : Wiring p S :=
  fun i d s => w₁ i d (w₂ i d s)

end Wiring
```

- `Wiring.id` is the do-nothing wiring.
- `Wiring.comp w₁ w₂` runs `w₂` first, then `w₁` on the result.
- Composition is associative; `id` is a two-sided unit.

And the action on coalgebras:

```lean
def Coalgebra.wire {p : Polynomial} {S : Type}
    (c : Coalgebra p S) (w : Wiring p S) : Coalgebra p S where
  step s :=
    let ⟨i, k⟩ := c.step s
    ⟨i, fun d => w i d (k d)⟩
```

`Coalgebra.wire` takes a coalgebra and a wiring, returns a new
coalgebra. The position `i` is preserved; the next-state function `k`
is post-composed pointwise with `w i d`.

> [!summary]
> The whole categorical story:
>
> 1. `Wiring p S` is a monoid under `Wiring.comp` with unit `Wiring.id`.
> 2. `Coalgebra.wire` is a right action of this monoid on the set of
>    `p`-coalgebras over `S`: `(c.wire w₁).wire w₂ = c.wire (w₂.comp w₁)`
>    and `c.wire Wiring.id = c`.
> 3. Wirings are first-class data: you can name them, compose them,
>    apply them in any order, and reason about them as standalone
>    objects.

---

## 6. The two wirings of the labour/justice system (§6)

State-based invariant:

```lean
def wireInvariant : Wiring (jPoly.tensor lPoly) (JState × LState) :=
  fun _ _ s =>
    match s with
    | (.imprisoned, _) => (.imprisoned, .NILF)
    | _ => s
```

The wiring ignores the firing position and direction. Whenever the
*next state* is of the form `(imprisoned, _)`, it snaps the labour
component to `NILF`. That is the post-condition "imprisoned ⇒ NILF."

Event-based release:

```lean
def wireRelease : Wiring (jPoly.tensor lPoly) (JState × LState) :=
  fun i d s =>
    match i, d with
    | (.imprisoned, _), .inl .imprisoned_to_free => (s.1, .unemployed)
    | _, _ => s
```

This one reads the position and the direction. The match clause
`(.imprisoned, _), .inl .imprisoned_to_free` says: if the firing
position has Justice equal to `imprisoned` and the firing direction
is the Justice direction `imprisoned_to_free`, then override the
labour component of the next state to `unemployed`. Otherwise pass
the raw next-state through unchanged.

> [!note]
> The dependent typing matters here: when we write
> `.inl .imprisoned_to_free`, Lean checks that this only makes sense
> when `i.1 = .imprisoned`. The pattern `(.imprisoned, _)` on `i`
> refines the type just enough for `.imprisoned_to_free` to typecheck.

---

## 7. The wired joint coalgebra by composition (§7)

Now the wired joint coalgebra is built by **composing two existing
pieces** — the raw parallel coalgebra and a wiring — rather than by
inlining wirings into a step function:

```lean
def wiredJoint : Coalgebra (jPoly.tensor lPoly) (JState × LState) :=
  (rawJoint.wire wireRelease).wire wireInvariant
```

Read left-to-right: take the raw parallel coalgebra, wire it with
`wireRelease` (event consequence), then wire that with `wireInvariant`
(state invariant). The invariant runs *after* the release, which is
the tiered precedence rule from the companion guide.

Because wirings compose, you can equivalently combine the two wirings
first and apply once:

```lean
def wiredJointAlt : Coalgebra (jPoly.tensor lPoly) (JState × LState) :=
  rawJoint.wire (Wiring.comp wireInvariant wireRelease)
```

These two definitions produce identical step functions — that is the
associativity of the monoid action.

> [!tip] What you can now do that you couldn't before
>
> - **Toggle a wiring on or off** without touching `rawJoint` or any
>   other wiring: `rawJoint.wire wireInvariant` is the "invariant
>   only" version.
> - **Add a third wiring** by writing one new `Wiring` value and one
>   more `.wire` in the composition. No edit to existing code.
> - **State and prove laws** about wirings — for example,
>   `(rawJoint.wire wireInvariant).wire wireInvariant = rawJoint.wire wireInvariant`
>   (the invariant is idempotent on next states). That's a theorem
>   about wirings, statable because `Wiring` is a real type.

---

## 8. Concrete one-step examples (§8)

Same four steps as before:

```lean
def step1 : JState × LState :=
  match wiredJoint.step (JState.free, LState.working) with
  | ⟨_, k⟩ => k (.inl .free_to_accused)

#eval step1  -- expect (.accused, .working)
```

Start at `(free, working)`. Justice fires `free_to_accused`. Neither
wiring triggers — the result is `(accused, working)`.

```lean
def step2 : JState × LState :=
  match wiredJoint.step step1 with
  | ⟨_, k⟩ => k (.inl .accused_to_imprisoned)

#eval step2  -- expect (.imprisoned, .NILF)
```

Justice fires `accused_to_imprisoned`. The raw next-state is
`(imprisoned, working)`. `wireRelease` doesn't match the direction.
`wireInvariant` snaps the labour to `NILF`. Result: `(imprisoned, NILF)`.

```lean
def step3 : JState × LState :=
  match wiredJoint.step step2 with
  | ⟨_, k⟩ => k (.inl .imprisoned_to_free)

#eval step3  -- expect (.free, .unemployed)
```

Justice fires `imprisoned_to_free`. Raw next-state: `(free, NILF)`.
`wireRelease` matches: labour becomes `unemployed`. `wireInvariant`
sees `(free, unemployed)` and does nothing. Result: `(free, unemployed)`.

```lean
def step4 : JState × LState :=
  match wiredJoint.step step3 with
  | ⟨_, k⟩ => k (.inr .find_job)

#eval step4  -- expect (.free, .working)
```

A Labour direction (`find_job`) fires — note `.inr` in place of
`.inl`. Neither wiring matches. Result: `(free, working)`.

> [!summary]
> Four steps, four different outcomes:
>
> | Step | Direction | Wiring that fired | Result |
> | --- | --- | --- | --- |
> | 1 | `free_to_accused` (J) | none | `(accused, working)` |
> | 2 | `accused_to_imprisoned` (J) | `wireInvariant` | `(imprisoned, NILF)` |
> | 3 | `imprisoned_to_free` (J) | `wireRelease` | `(free, unemployed)` |
> | 4 | `find_job` (L) | none | `(free, working)` |

---

## 9. What this gives you and what it leaves out

**What you get from the wirings-as-monoid framing:**

- Wirings are **typed**: `Wiring p S` is a real type, not a code
  pattern. You can pass them as arguments, store them in lists, prove
  laws about them.
- Wirings **compose**: `Wiring.comp` is associative with unit
  `Wiring.id`. Two wirings can be combined before being applied, or
  applied one after the other — same result.
- Wirings **act on coalgebras**: `Coalgebra.wire` is a right monoid
  action. The raw parallel coalgebra is untouched; wirings are an
  additional layer.
- Wirings are **local**: adding or removing one is a one-line edit.

**What this file still leaves out:**

- No rates, no randomness. The coalgebra is deterministic per
  direction. A real simulator picks which direction fires by drawing
  from competing exponentials (Module 4).
- No parameters, no calibration. There is no `Θ`, no Dirichlet
  posterior, no backward leg. This is the *forward-only* view.
- No scheduler. To run a trace you have to supply the directions
  yourself, as in §8.

**On the categorical status of wirings.**
A wiring as defined here is **not** a morphism in `Poly` — it doesn't
have a forward map on positions or a backward map on directions.
What it is, instead, is an **element of a monoid that acts on the
`p`-coalgebras over `S`**. That is a perfectly real categorical
gadget: monoid actions on a set of structures. The trade you make by
sitting at this level (rather than at the level of `Poly` morphisms)
is that the wiring can change next-state *values* but not the
position structure of the coalgebra — which, as it happens, is
exactly what the labour/justice example needs.
