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

> [!tip] One-line summary
> A polynomial functor is "positions, and for each position, the names
> of its outgoing transitions." Lean's dependent inductive types make
> this *exactly* the data of the simulator's labelled state machines.

---

## Table of contents

- [1. Polynomial and Coalgebra structures (§1)](#1-polynomial-and-coalgebra-structures-1)
- [2. The Justice subsystem (§2)](#2-the-justice-subsystem-2)
- [3. The Labour subsystem (§3)](#3-the-labour-subsystem-3)
- [4. Tensor and the raw parallel coalgebra (§4)](#4-tensor-and-the-raw-parallel-coalgebra-4)
- [5. Wirings (§5)](#5-wirings-5)
- [6. The wired joint coalgebra (§6)](#6-the-wired-joint-coalgebra-6)
- [7. Running concrete one-step examples (§7)](#7-running-concrete-one-step-examples-7)
- [8. What this gives you and what it leaves out](#8-what-this-gives-you-and-what-it-leaves-out)

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

> [!note]
> No randomness yet. The deterministic coalgebra is the *shape*; the
> stochastic lift (Module 4 in the main book) wraps the codomain in a
> distribution monad without changing the shape.

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
.imprisoned` has one.

This is the type-level version of the Python dict

```python
JUSTICE_EVENTS = {
    "free":       {"free_to_accused":       "accused"},
    "accused":    {"accused_to_imprisoned": "imprisoned",
                   "accused_to_free":       "free"},
    "imprisoned": {"imprisoned_to_free":    "free"},
}
```

with one important difference: in Lean you **cannot** fire a direction
from a state that has no constructor for it. `JDir .free` only has
`free_to_accused`; the typechecker refuses to construct an
`accused_to_imprisoned` from `free`. The Python version trusts a
string lookup.

The next-state map is a plain dependent function:

```lean
def jNext : (s : JState) → JDir s → JState
  | _, .free_to_accused       => .accused
  | _, .accused_to_imprisoned => .imprisoned
  | _, .accused_to_free       => .free
  | _, .imprisoned_to_free    => .free
```

And the coalgebra wraps the two together:

```lean
def jPoly : Polynomial where
  Pos := JState
  Dir := JDir

def jCoalg : Coalgebra jPoly JState where
  step s := ⟨s, jNext s⟩
```

The step function says "the position equals the current state, and the
next-state per direction is `jNext s`." That `⟨s, jNext s⟩` is the
`PSigma` constructor packaging the dependent pair.

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

def lNext : (s : LState) → LDir s → LState
  | _, .lose_job       => .unemployed
  | _, .leave_force    => .NILF
  | _, .find_job       => .working
  | _, .give_up        => .NILF
  | _, .return_to_work => .working

def lCoalg : Coalgebra lPoly LState where
  step s := ⟨s, lNext s⟩
```

Notice how `LDir .working` has *two* constructors but `LDir .NILF` has
only one: the branching factor differs by position. That's the whole
point of a polynomial functor — flat-matrix presentations would lose
this.

---

## 4. Tensor and the raw parallel coalgebra (§4)

```lean
def Polynomial.tensor (p q : Polynomial) : Polynomial where
  Pos := p.Pos × q.Pos
  Dir := fun ij => p.Dir ij.1 ⊕ q.Dir ij.2
```

The tensor of two polynomials in `Poly` is given by: positions
**multiply** (`p.Pos × q.Pos`), and directions **sum** (the disjoint
union `⊕`). At joint position `(i, j)`, a joint direction is either a
direction of `p` out of `i` or a direction of `q` out of `j` — never
both at once. That asymmetry is the polynomial functor's way of saying
"one event fires at a time."

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
```

This is the **raw parallel coalgebra**: at joint state `(s, t)`,
either fire a `p`-direction (advancing the first carrier, leaving the
second alone) or fire a `q`-direction (vice versa). It corresponds to
the "uncoupled" Python run, where neither subsystem knows the other
exists.

> [!warning]
> `parallel` permits all 9 joint cells of `JState × LState`,
> including `(imprisoned, working)`. That is what we will fix with
> wirings in §5.

---

## 5. Wirings (§5)

```lean
def wireInvariant : JState × LState → JState × LState
  | (.imprisoned, _) => (.imprisoned, .NILF)
  | jl              => jl
```

A wiring is a small total function on joint states. `wireInvariant`
is the **state-based** rule: whenever justice is imprisoned, labour is
NILF — no matter what. The pattern match is exhaustive because the
second clause catches every other joint state.

The **event-based** wiring lives inline inside the wired joint
coalgebra. We could have factored it out:

```lean
def wireRelease : JDir .imprisoned → LState → LState
  | .imprisoned_to_free, _ => .unemployed
```

but inlining it keeps the next-state map of the joint coalgebra in one
place, which is easier to read.

---

## 6. The wired joint coalgebra (§6)

```lean
def wiredJoint : Coalgebra (jPoly.tensor lPoly) (JState × LState) where
  step jl :=
    let j := jl.1
    let l := jl.2
    ⟨(j, l), fun
      | .inl dj =>
          let j' := jNext j dj
          let l' := match dj with
            | .imprisoned_to_free => LState.unemployed
            | _                   => l
          wireInvariant (j', l')
      | .inr dl =>
          let l' := lNext l dl
          wireInvariant (j, l')⟩
```

This is the heart of the file. Read it as:

- Joint state `jl = (j, l)`.
- Joint position is `(j, l)` (states are positions).
- If a Justice direction `dj` fires:
  - Compute new justice state `j' = jNext j dj`.
  - Apply the event wiring: if the specific direction
    `imprisoned_to_free` fired, labour becomes `unemployed`;
    otherwise it stays put.
  - Enforce the state invariant `imprisoned ⇒ NILF`.
- If a Labour direction `dl` fires:
  - Compute new labour state `l' = lNext l dl`.
  - The invariant could be triggered too (e.g. labour transitioned
    while justice is already imprisoned — though by the invariant
    that shouldn't have been reachable to begin with).

The order — event wiring first, invariant last — is the [tiered
precedence rule](lens-composition-guide.md) from the companion
guide. The invariant wins.

> [!note]
> The dependent typing pays off here: when we match on `dj` and write
> `.imprisoned_to_free`, Lean knows that pattern only type-checks
> when `j = .imprisoned`. The wildcard catches every other Justice
> direction. There is no string-lookup runtime check.

---

## 7. Running concrete one-step examples (§7)

Four steps, each `#eval`-ed at compile time:

```lean
def step1 : JState × LState :=
  match wiredJoint.step (JState.free, LState.working) with
  | ⟨_, k⟩ => k (.inl .free_to_accused)

#eval step1  -- expect (.accused, .working)
```

Start at `(free, working)`. Justice fires `free_to_accused`. The
event wiring does not trigger (the direction is not
`imprisoned_to_free`). The invariant does not trigger (justice is
not imprisoned). Result: `(.accused, .working)`.

```lean
def step2 : JState × LState :=
  match wiredJoint.step step1 with
  | ⟨_, k⟩ => k (.inl .accused_to_imprisoned)

#eval step2  -- expect (.imprisoned, .NILF)
```

Justice fires `accused_to_imprisoned`. The invariant catches the
new joint state `(imprisoned, working)` and snaps labour to NILF.

```lean
def step3 : JState × LState :=
  match wiredJoint.step step2 with
  | ⟨_, k⟩ => k (.inl .imprisoned_to_free)

#eval step3  -- expect (.free, .unemployed)
```

Justice fires `imprisoned_to_free`. The event wiring catches this
specific direction and sets labour to `unemployed`. The invariant
no longer applies because justice is now free.

```lean
def step4 : JState × LState :=
  match wiredJoint.step step3 with
  | ⟨_, k⟩ => k (.inr .find_job)

#eval step4  -- expect (.free, .working)
```

Now a *Labour* direction fires (note `.inr` in place of `.inl`):
`find_job` from `unemployed`. Labour transitions to `working`, justice
stays at `free`, nothing fires either wiring. Result: `(.free, .working)`.

> [!summary]
> Four steps, four different outcomes:
>
> | Step | Direction | Wiring that fired | Result |
> | --- | --- | --- | --- |
> | 1 | `free_to_accused` (J) | none | `(accused, working)` |
> | 2 | `accused_to_imprisoned` (J) | state invariant | `(imprisoned, NILF)` |
> | 3 | `imprisoned_to_free` (J) | event wiring | `(free, unemployed)` |
> | 4 | `find_job` (L) | none | `(free, working)` |

---

## 8. What this gives you and what it leaves out

**What you get for free from the polynomial-functor framing:**

- Positions and directions are *types*, so the typechecker enforces
  that you can only fire a direction valid for the current position.
- The branching factor is allowed to vary by position (one direction
  out of `free`, two out of `accused`). A flat transition-matrix
  presentation cannot do this.
- Parallel composition is the tensor in `Poly`: positions multiply,
  directions sum. No bespoke combinator.
- Wirings are first-class functions on joint state, separate from the
  subsystem definitions. Adding or removing a wiring is a local edit.
- The `step : S → Σᵢ (Dir i → S)` signature is what Module 4 of the
  main book lifts to stochastic by wrapping the codomain in a
  distribution monad. The shape stays identical.

**What this file leaves out:**

- No rates, no randomness. The coalgebra is deterministic per
  direction. A real simulator picks which direction fires by drawing
  from competing exponentials (Module 4).
- No parameters, no calibration. There is no `Θ`, no Dirichlet
  posterior, no backward leg. This is the *forward-only* view —
  exactly the layer for which the parametric-lens diagram is
  [overkill](labour-prison-lens-diagram.md).
- No scheduler. To run a trace you have to supply the directions
  yourself, as in §7. Adding a stochastic scheduler turns this into
  an event-time simulator.

That's the trade we made by sticking to plain polynomial coalgebras:
maximum structural clarity, zero stochastic or calibration machinery.
The main book's `ObsTeach/` simulator adds those layers one at a time
on top of essentially the same skeleton.
