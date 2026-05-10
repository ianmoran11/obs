/-
  ObsTeach.Wiring
  ===============

  Module 7 — Double Categories of Systems.

  We do not formalise the double category `Sys` here. We
  instantiate the two operations it organises:

    * **Wirings** (horizontal arrows). Cross-lens constraints
      that say "if Justice puts you in `imprisoned`, Labour is
      forced to `nilf` and Education is forced to `notStudying`".
      A wiring is a function from joint inner state to a
      coordinated joint outer state.

    * **Behaviour-preserving morphisms** (vertical arrows). The
      `Discretise(Δt)` we sketched in Markov.lean is one. The
      coarsening `Person → cell` in Substrate.lean is another.
      Vertical arrows swap an implementation; the interface is
      preserved.

  The two-cell coherence of Module 7 says these two axes commute
  — concretely, you can wire-then-discretise or discretise-then-
  wire and get the same result. We do not exercise that here, but
  the architecture is consistent with it.
-/

import ObsTeach.Substrate

namespace ObsTeach.Wiring

open ObsTeach.Substrate

/-- The four lens-state types. Defined here together because the
    wirings need to mention all of them. The actual per-lens
    rate kernels live in `ObsTeach.Lenses`. -/
inductive LabourState where
  | working | unemployed | nilf
  deriving Repr, DecidableEq, BEq, Inhabited

inductive EducationState where
  | inSchool | inUniversity | notStudying
  deriving Repr, DecidableEq, BEq, Inhabited

inductive JusticeState where
  | free | accused | imprisoned
  deriving Repr, DecidableEq, BEq, Inhabited

def LabourState.toString : LabourState → String
  | .working => "working" | .unemployed => "unemployed" | .nilf => "nilf"

def EducationState.toString : EducationState → String
  | .inSchool => "inSchool" | .inUniversity => "inUniversity"
  | .notStudying => "notStudying"

def JusticeState.toString : JusticeState → String
  | .free => "free" | .accused => "accused" | .imprisoned => "imprisoned"

/-- The combined per-person state across the three domain lenses
    plus the Person substrate. `time` is wall-clock simulator
    time; `prisonEntered` is the time the person entered the
    `imprisoned` state, used by the Weibull hazard kernel for
    prison stays (Module 4.6). -/
structure JointState where
  person          : Person
  labour          : LabourState
  education       : EducationState
  justice         : JusticeState
  prisonEntered   : Float -- only meaningful when justice = imprisoned
  deriving Repr

/-- The **Justice → Labour** wiring. Imprisonment forces NILF;
    on release we put the person in `unemployed`. The wiring is
    invoked whenever the Justice lens fires a transition.

    Categorically: this is the backward leg of the wiring lens
    decomposing one outer event into coordinated inner events. -/
def wireJusticeToLabour (oldJ newJ : JusticeState) (l : LabourState) : LabourState :=
  match oldJ, newJ with
  | _, .imprisoned     => .nilf
  | .imprisoned, .free => .unemployed
  | _, _               => l

/-- The **Justice → Education** wiring. Imprisonment forces
    `notStudying`; on release education is *not* automatically
    resumed (the person can re-enrol later via Education's own
    kernel). -/
def wireJusticeToEducation (_oldJ newJ : JusticeState)
    (e : EducationState) : EducationState :=
  match newJ with
  | .imprisoned => .notStudying
  | _           => e

/-- The **Education → Labour** wiring. Active study forces NILF;
    on leaving education we put the person in `unemployed`. -/
def wireEducationToLabour (oldE newE : EducationState)
    (l : LabourState) : LabourState :=
  match oldE, newE with
  | _, .inSchool      => .nilf
  | _, .inUniversity  => .nilf
  | .inSchool, .notStudying     => .unemployed
  | .inUniversity, .notStudying => .unemployed
  | _, _              => l

/-- The **Age → Education** wiring. Demographic transitions in
    Population reindex education state via this map.

    * Anyone under 16 must be `inSchool`.
    * Anyone over 25 cannot be `inUniversity`; if they are, push
      them to `notStudying`.

    This is the reindexing functor of the pseudofunctor `F` from
    Module 8.2: when a base morphism `Person → Person` ages
    someone, the per-lens fibre is transported via this rule. -/
def wireAgeToEducation (age : Nat) (e : EducationState) : EducationState :=
  if age < 16 then .inSchool
  else
    match e with
    | .inUniversity => if age > 25 then .notStudying else .inUniversity
    | _ => e

/-- Apply all three wirings after a Justice transition. This is
    the sequential-wirings composite — operadic composition of
    three pairwise wirings. (Module 7.3.) -/
def applyJusticeWirings (oldJ newJ : JusticeState) (st : JointState) : JointState :=
  { st with
    justice   := newJ
    labour    := wireJusticeToLabour oldJ newJ st.labour
    education := wireJusticeToEducation oldJ newJ st.education }

/-- Apply the Education → Labour wiring after an Education
    transition. -/
def applyEducationWirings (oldE newE : EducationState) (st : JointState)
    : JointState :=
  { st with
    education := newE
    labour    := wireEducationToLabour oldE newE st.labour }

/-- Apply age-based reindexing after Population ages someone. -/
def applyAgeWirings (newAge : Nat) (st : JointState) : JointState :=
  let p' := { st.person with age := newAge }
  { st with
    person    := p'
    education := wireAgeToEducation newAge st.education }

end ObsTeach.Wiring
