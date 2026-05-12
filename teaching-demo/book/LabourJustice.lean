/-! # Compositional Systems: Labour and Justice in Lean 4

  A standalone teaching file. We model the labour-market and prison
  example as **polynomial functors and their coalgebras**, with parallel
  composition by tensor and cross-system constraints by *wirings*
  expressed as a **separate, composable algebraic object** that acts on
  coalgebras by post-processing the next-state function.

  Polynomial functors play the role of "labelled state machine":
  positions are the states a system can be in, and each position has a
  set of named outgoing transitions called directions. A coalgebra
  on a carrier `S` is a step function `S → Σᵢ (Dir i → S)` — at every
  state, name a position and supply a next-state per direction.

  The wirings are not buried inside the joint coalgebra. They live in
  their own type `Wiring p S`, form a monoid under composition, and
  *act* on coalgebras via `Coalgebra.wire`. This is the categorical
  "addition" you asked for: wirings are first-class data, separate
  from the raw parallel coalgebra, and applying them is a typed
  operation rather than an inline rewrite of the step function.

  No external imports needed. The file follows the same structural
  shape as `ObsTeach.Foundations` from the main book.
-/

namespace LabourJustice

/-! ## §1. Polynomial functors and coalgebras -/

structure Polynomial where
  Pos : Type
  Dir : Pos → Type

structure Coalgebra (p : Polynomial) (S : Type) where
  step : S → (i : p.Pos) ×' (p.Dir i → S)

/-! ## §2. The Justice system

  Three positions and four labelled directions. Each direction is a
  constructor of a dependent inductive type: e.g. `accused_to_free`
  only exists as a `JDir accused`. The dependent type literally
  enforces that you can only fire a direction valid for the current
  position.
-/

inductive JState | free | accused | imprisoned
  deriving Repr, DecidableEq, Inhabited

inductive JDir : JState → Type
  | free_to_accused       : JDir .free
  | accused_to_imprisoned : JDir .accused
  | accused_to_free       : JDir .accused
  | imprisoned_to_free    : JDir .imprisoned

def jPoly : Polynomial where
  Pos := JState
  Dir := JDir

def jNext : (s : JState) → JDir s → JState
  | _, .free_to_accused       => .accused
  | _, .accused_to_imprisoned => .imprisoned
  | _, .accused_to_free       => .free
  | _, .imprisoned_to_free    => .free

def jCoalg : Coalgebra jPoly JState where
  step s := ⟨s, jNext s⟩

/-! ## §3. The Labour system -/

inductive LState | working | unemployed | NILF
  deriving Repr, DecidableEq, Inhabited

inductive LDir : LState → Type
  | lose_job       : LDir .working
  | leave_force    : LDir .working
  | find_job       : LDir .unemployed
  | give_up        : LDir .unemployed
  | return_to_work : LDir .NILF

def lPoly : Polynomial where
  Pos := LState
  Dir := LDir

def lNext : (s : LState) → LDir s → LState
  | _, .lose_job       => .unemployed
  | _, .leave_force    => .NILF
  | _, .find_job       => .working
  | _, .give_up        => .NILF
  | _, .return_to_work => .working

def lCoalg : Coalgebra lPoly LState where
  step s := ⟨s, lNext s⟩

/-! ## §4. Tensor of polynomials and the raw parallel coalgebra

  In `Poly` the tensor `p ⊗ q` has positions `p.Pos × q.Pos` and at
  each position `(i, j)` the direction set `p.Dir i ⊕ q.Dir j`. A
  coalgebra over the tensor interleaves: one direction fires per step
  from either subsystem.
-/

def Polynomial.tensor (p q : Polynomial) : Polynomial where
  Pos := p.Pos × q.Pos
  Dir := fun ij => p.Dir ij.1 ⊕ q.Dir ij.2

def parallel {p q : Polynomial} {S T : Type}
    (c : Coalgebra p S) (d : Coalgebra q T) :
    Coalgebra (p.tensor q) (S × T) where
  step st :=
    let cs := c.step st.1
    let dt := d.step st.2
    ⟨(cs.1, dt.1), fun
      | .inl ds  => (cs.2 ds, st.2)
      | .inr ds' => (st.1, dt.2 ds')⟩

/-- The bare parallel composition of Justice and Labour — no wirings. -/
def rawJoint : Coalgebra (jPoly.tensor lPoly) (JState × LState) :=
  parallel jCoalg lCoalg

/-! ## §5. Wirings as a separate type

  A `Wiring p S` is a typed post-processor on next-state values.
  Crucially:

  - The **position** of the step is fixed (a wiring cannot change
    which position the system is reporting, because doing so would
    invalidate the direction type of the next-state function).
  - The wiring can read both the firing **position** `i` and the
    firing **direction** `d`, and rewrite the resulting next-state.

  Wirings compose. Composition is associative; the identity wiring
  is a left and right unit. So `Wiring p S` is a monoid acting on
  the set of coalgebras over `p` with carrier `S`.
-/

def Wiring (p : Polynomial) (S : Type) : Type :=
  (i : p.Pos) → p.Dir i → S → S

namespace Wiring

/-- The identity wiring: leave next states alone. -/
def id {p : Polynomial} {S : Type} : Wiring p S :=
  fun _ _ s => s

/-- Sequential composition: `comp w₁ w₂` runs `w₂` first, then `w₁`. -/
def comp {p : Polynomial} {S : Type} (w₁ w₂ : Wiring p S) : Wiring p S :=
  fun i d s => w₁ i d (w₂ i d s)

end Wiring

/-- Apply a wiring to a coalgebra. The position is unchanged; the
    next-state function is replaced by `fun d => w i d (k d)`. -/
def Coalgebra.wire {p : Polynomial} {S : Type}
    (c : Coalgebra p S) (w : Wiring p S) : Coalgebra p S where
  step s :=
    let ⟨i, k⟩ := c.step s
    ⟨i, fun d => w i d (k d)⟩

/-! ## §6. The two wirings of the labour/justice system

  Each wiring is a value of type `Wiring (jPoly.tensor lPoly) (JState × LState)`.
  They do not modify positions; they modify the next-state values
  delivered by the raw parallel coalgebra.
-/

/-- State-based invariant: snap any next state of the form
    `(imprisoned, _)` to `(imprisoned, NILF)`. The direction is
    irrelevant — the wiring fires after every step. -/
def wireInvariant : Wiring (jPoly.tensor lPoly) (JState × LState) :=
  fun _ _ s =>
    match s with
    | (.imprisoned, _) => (.imprisoned, .NILF)
    | _ => s

/-- Event-based release: when the firing direction is the Justice
    direction `imprisoned_to_free`, set the labour component of the
    next state to `unemployed`. -/
def wireRelease : Wiring (jPoly.tensor lPoly) (JState × LState) :=
  fun i d s =>
    match i, d with
    | (.imprisoned, _), .inl .imprisoned_to_free => (s.1, .unemployed)
    | _, _ => s

/-! ## §7. The wired joint coalgebra by composition

  The wired joint coalgebra is `rawJoint` with both wirings applied.
  `wireRelease` runs first (event consequence), then `wireInvariant`
  (state invariant) — the tiered precedence rule of the companion
  guide. Composition is `(rawJoint.wire wireRelease).wire wireInvariant`,
  which is equivalent to `rawJoint.wire (Wiring.comp wireInvariant wireRelease)`
  by associativity.
-/

def wiredJoint : Coalgebra (jPoly.tensor lPoly) (JState × LState) :=
  (rawJoint.wire wireRelease).wire wireInvariant

/-- Same thing, expressed by composing the wirings *first* and then
    applying once. This compiles to the same step function modulo
    associativity. -/
def wiredJointAlt : Coalgebra (jPoly.tensor lPoly) (JState × LState) :=
  rawJoint.wire (Wiring.comp wireInvariant wireRelease)

/-! ## §8. Concrete one-step examples

  Same scenarios as before. The wirings are now first-class objects,
  but the dynamics are identical.
-/

/-- From `(free, working)`, Justice fires `free_to_accused`. -/
def step1 : JState × LState :=
  match wiredJoint.step (JState.free, LState.working) with
  | ⟨_, k⟩ => k (.inl .free_to_accused)

#eval step1  -- expect (.accused, .working)

/-- From `step1`, Justice fires `accused_to_imprisoned`. -/
def step2 : JState × LState :=
  match wiredJoint.step step1 with
  | ⟨_, k⟩ => k (.inl .accused_to_imprisoned)

#eval step2  -- expect (.imprisoned, .NILF) — state invariant fires

/-- From `step2`, Justice fires `imprisoned_to_free`. -/
def step3 : JState × LState :=
  match wiredJoint.step step2 with
  | ⟨_, k⟩ => k (.inl .imprisoned_to_free)

#eval step3  -- expect (.free, .unemployed) — event wiring fires

/-- From `step3`, Labour fires `find_job`. -/
def step4 : JState × LState :=
  match wiredJoint.step step3 with
  | ⟨_, k⟩ => k (.inr .find_job)

#eval step4  -- expect (.free, .working)

end LabourJustice
