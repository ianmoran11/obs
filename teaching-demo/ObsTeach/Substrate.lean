/-
  ObsTeach.Substrate
  ==================

  Module 8 — Substrate, Fibrations, and Context.

  `Person` is the **substrate** of the simulator. Every domain
  lens reads `Person` from context (the Reader-comonad pattern of
  Lesson 8.3); only the Population lens writes to `Person`.

  Categorically: the joint state space of the simulator is the
  Grothendieck construction of a `Person`-indexed family of
  per-lens fibres. Each lens lives in the slice category over
  `Person`; Population's slice object is `id_Person` and every
  other lens factors uniquely through it (Lesson 8.4).
-/

namespace ObsTeach.Substrate

/-- Demographic sex. -/
inductive Sex where
  | male | female
  deriving Repr, DecidableEq, BEq, Inhabited

/-- A coarse region tag. We keep this minimal for the demo. -/
inductive Region where
  | major | regional | remote
  deriving Repr, DecidableEq, BEq, Inhabited

/-- The substrate record. Every lens's per-person state has this
    object as its base. The `id` is invariant; the other fields
    can be modified, but only by the Population lens. -/
structure Person where
  id        : Nat
  age       : Nat
  sex       : Sex
  region    : Region
  -- Time of birth (years before simulation start, negative for
  -- already-alive cohort members at t=0). Not a real demographic
  -- field — used only to sketch the indexed-fibre structure.
  cohort    : Int
  deriving Repr, Inhabited

/-- Render the demographic covariate cell as a string key. This
    is the "covariate cell" used in calibration GROUP BYs.

    Reading this categorically: `Person → CovariateCell` is a
    coarsening map — a behaviour-preserving morphism (Module 7.4)
    from per-person state to the calibration-relevant equivalence
    class. The fibres of this map are people in the same cell. -/
def Person.cell (p : Person) : String :=
  let ageBand :=
    if p.age < 20      then "0-19"
    else if p.age < 35 then "20-34"
    else if p.age < 50 then "35-49"
    else if p.age < 65 then "50-64"
    else "65+"
  let sex := match p.sex with | .male => "M" | .female => "F"
  let reg := match p.region with
    | .major => "major" | .regional => "regional" | .remote => "remote"
  s!"{ageBand}|{sex}|{reg}"

/-- The Reader-pattern signature: every domain lens kernel reads
    `Person` (and any extra context) and produces a transition.
    None of them write a new `Person`. -/
abbrev ReaderKernel (S Out : Type) := Person → S → Out

/-- Population's kernel (the only one that *writes* to `Person`)
    has a different signature: it takes a `Person` and produces a
    new `Person`. This is the categorical statement that
    Population is *not* a co-Kleisli morphism for the Reader
    comonad on `Person`. (Lesson 8.4.) -/
abbrev PopulationKernel := Person → Person

end ObsTeach.Substrate
