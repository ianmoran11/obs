/-
  ObsTeach.Lenses
  ===============

  The four lenses of the demo. Each is a parametric lens
  (Module 3) with:

    * A polynomial coalgebra structure (Module 1) — positions and
      labelled directions.
    * A rate kernel (Module 4) keyed by `(cell, position)` —
      forward leg.
    * A Dirichlet posterior (Module 5) keyed the same way —
      backward leg.
    * Behaviour-preserving wirings to other lenses (Module 7).

  Justice is the only lens with a hazard kernel — Weibull dwell
  times in `imprisoned` (Module 4.6).

  This file just declares the **structural data**: which positions
  and directions exist, and how the next state is computed when a
  direction fires. The numerical parameters live in `FakeData`.
-/

import ObsTeach.Wiring
import ObsTeach.Substrate
import ObsTeach.Markov
import ObsTeach.Random

namespace ObsTeach.Lenses

open ObsTeach.Wiring ObsTeach.Substrate ObsTeach.Markov ObsTeach.Random

/- ─────────────────────────────────────────────────────────────
   LABOUR — positions × directions
   ───────────────────────────────────────────────────────────── -/

/-- The labelled directions out of each labour position. These
    are exactly the multinomial outcomes the calibration estimates. -/
def labourDirections : LabourState → Array String
  | .working    => #["working_to_unemployed", "working_to_nilf"]
  | .unemployed => #["unemployed_to_working", "unemployed_to_nilf"]
  | .nilf       => #["nilf_to_working", "nilf_to_unemployed"]

/-- The next-state handler when a labour direction fires. -/
def labourNext : LabourState → String → LabourState
  | _, "working_to_unemployed"   => .unemployed
  | _, "working_to_nilf"         => .nilf
  | _, "unemployed_to_working"   => .working
  | _, "unemployed_to_nilf"      => .nilf
  | _, "nilf_to_working"         => .working
  | _, "nilf_to_unemployed"      => .unemployed
  | s, _                         => s

/- ─────────────────────────────────────────────────────────────
   EDUCATION — positions × directions
   ───────────────────────────────────────────────────────────── -/

def educationDirections : EducationState → Array String
  | .inSchool     => #["school_to_university", "school_to_notStudying"]
  | .inUniversity => #["university_to_notStudying"]
  | .notStudying  => #["notStudying_to_university"]

def educationNext : EducationState → String → EducationState
  | _, "school_to_university"     => .inUniversity
  | _, "school_to_notStudying"    => .notStudying
  | _, "university_to_notStudying" => .notStudying
  | _, "notStudying_to_university" => .inUniversity
  | s, _                          => s

/- ─────────────────────────────────────────────────────────────
   JUSTICE — positions × directions, with Weibull on imprisonment
   ───────────────────────────────────────────────────────────── -/

def justiceDirections : JusticeState → Array String
  | .free       => #["free_to_accused"]
  | .accused    => #["accused_to_imprisoned", "accused_to_free"]
  | .imprisoned => #["imprisoned_to_free"]

def justiceNext : JusticeState → String → JusticeState
  | _, "free_to_accused"        => .accused
  | _, "accused_to_imprisoned"  => .imprisoned
  | _, "accused_to_free"        => .free
  | _, "imprisoned_to_free"     => .free
  | s, _                        => s

/-- The Justice lens uses a **hazard** rather than a constant rate
    on the `imprisoned` position. Given the time already served
    `τ`, the hazard is Weibull with shape `k > 1` (so the rate of
    release rises with time served). The `imprisoned_to_free`
    rate at `τ` is `(k/η) · (τ/η)^{k-1}`.

    For the other positions we use constant rates. (Module 4.6.) -/
def weibullHazard (shape scale τ : Float) : Float :=
  if τ ≤ 0.0 then (shape / scale) * 1.0e-6
  else
    -- (k/η) * (τ/η)^(k-1) = (k/η) * exp((k-1) * log(τ/η))
    let r := τ / scale
    (shape / scale) * Float.exp ((shape - 1.0) * Float.log r)

/- ─────────────────────────────────────────────────────────────
   Common lens-name and key construction
   ───────────────────────────────────────────────────────────── -/

inductive LensName where
  | labour | education | justice
  deriving Repr, BEq

def LensName.toString : LensName → String
  | .labour => "labour" | .education => "education" | .justice => "justice"

/-- A kernel key for `(cell, lens, from-state)`. This is exactly
    the GROUP BY key for calibration. -/
def kernelKey (cell : String) (lens : LensName) (from_ : String) : String :=
  s!"{cell}|{lens.toString}|{from_}"

end ObsTeach.Lenses
