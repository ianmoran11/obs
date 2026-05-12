/-! # Compositional Systems: Labour and Justice in Lean 4

  A standalone teaching file. We model the labour-market and prison
  example as **polynomial functors and their coalgebras**, with parallel
  composition by tensor and cross-system constraints by wirings.

  Polynomial functors play the role of "labelled state machine":
  positions are the states a system can be in, and each position has a
  set of named outgoing transitions called directions. A coalgebra
  on a carrier `S` is a step function `S → Σᵢ (Dir i → S)` — at every
  state, name a position and supply a next-state per direction.

  No external imports needed. The file follows the same structural
  shape as `ObsTeach.Foundations` from the main book, so the patterns
  carry over.
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

/-! ## §3. The Labour system

  Three positions and five labelled directions, same pattern.
-/

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

  Putting two systems side by side in `Poly`: positions multiply,
  directions sum. The resulting parallel coalgebra interleaves —
  one direction fires per step, from either subsystem.

  This is the "raw" composition: it allows any joint state, including
  ones we want to forbid (e.g. imprisoned ∧ working). The wirings of
  §5 rule those out.
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

/-! ## §5. Wirings

  Two flavours, both as small total functions:

  * `wireInvariant` is **state-based**: while justice is `imprisoned`,
    labour is forced to `NILF`. Holds at the end of every tick.
  * The inline match on `dj` inside `wiredJoint` is **event-based**:
    the specific direction `imprisoned_to_free` sets labour to
    `unemployed` (someone just released re-enters the labour force).

  The invariant is enforced last so it overrides the event consequence
  if they conflict.
-/

def wireInvariant : JState × LState → JState × LState
  | (.imprisoned, _) => (.imprisoned, .NILF)
  | jl              => jl

/-! ## §6. The wired joint coalgebra

  Same shape as `parallel`, but the next-state map applies the
  event-based and state-based wirings before returning the joint state.
  We inline `jNext` and `lNext` directly so the position equality is
  visible to the elaborator.
-/

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

/-! ## §7. Concrete one-step examples

  Pick specific directions and watch the joint state evolve. These
  mirror the Python demo: the lens-style wirings appear here as
  overrides to the next-state map of `wiredJoint`.
-/

/-- From (free, working), Justice fires `free_to_accused`. -/
def step1 : JState × LState :=
  match wiredJoint.step (JState.free, LState.working) with
  | ⟨_, k⟩ => k (.inl .free_to_accused)

#eval step1  -- expect (.accused, .working)

/-- From step1, Justice fires `accused_to_imprisoned`.
    The state-based wiring snaps labour to NILF. -/
def step2 : JState × LState :=
  match wiredJoint.step step1 with
  | ⟨_, k⟩ => k (.inl .accused_to_imprisoned)

#eval step2  -- expect (.imprisoned, .NILF)

/-- From step2, Justice fires `imprisoned_to_free`.
    The event-based wiring sends labour to unemployed. -/
def step3 : JState × LState :=
  match wiredJoint.step step2 with
  | ⟨_, k⟩ => k (.inl .imprisoned_to_free)

#eval step3  -- expect (.free, .unemployed)

/-- A Labour-only step from step3: find a job. -/
def step4 : JState × LState :=
  match wiredJoint.step step3 with
  | ⟨_, k⟩ => k (.inr .find_job)

#eval step4  -- expect (.free, .working)

end LabourJustice
