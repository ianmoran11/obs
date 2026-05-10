/-
  ObsTeach.Calibration
  ====================

  Module 10 — Calibration as a parametric lens's backward leg.

  The calibration step is a single function:

      events → (per-edge) Dirichlet posterior parameters

  In a real implementation this is a DuckDB SQL query. In Lean it
  is a fold over the events table, grouping by
  `(covariate-cell, lens, from-state, direction)`.

  The output Dirichlet parameters are then summarised by the
  posterior mean (Bayes-Laplace estimator). Setting α = 0.5 gives
  the Jeffreys-prior smoothed MLE; setting α = 1.0 and taking the
  posterior mode gives the frequentist MLE. The architecture
  supports both. (Module 5.5; BLUEPRINT §5.1.)
-/

import Std.Data.HashMap
import ObsTeach.Trace
import ObsTeach.Olog
import ObsTeach.Bayes

namespace ObsTeach.Calibration

open ObsTeach.Trace ObsTeach.Olog ObsTeach.Bayes

/-- A `KernelKey` identifies one cell in the calibration GROUP BY.
    The Dirichlet posterior is keyed by this. -/
structure KernelKey where
  cell      : String
  lens      : String
  fromState : String
  deriving BEq, Hashable, Repr

instance : ToString KernelKey where
  toString k := s!"{k.cell}~{k.lens}~{k.fromState}"

/-- Calibration produces a map from `KernelKey` to a Dirichlet
    posterior over the directions out of that cell.

    Every per-period rate kernel in the simulator is recovered by
    looking up this map and reading the posterior mean. -/
abbrev Calibrated := Std.HashMap KernelKey Dirichlet

/-- Project an `Event` down to a marginal-schema row with count 1.
    This is the simulator's `SchemaMorphism` into `M`. -/
def eventToMarginal (cellOf : Nat → String) (e : Event) : MarginalRow :=
  { cell := cellOf e.personId
    lens := e.lens
    fromState := e.fromState
    direction := e.direction
    count := 1 }

/-- Build the calibration posterior from a list of marginal-schema
    rows. This is the categorical content of BLUEPRINT §5.1: the
    SQL GROUP BY, the conjugate update of Module 5, and the
    backward leg of every parametric lens (Module 3.4) — all in
    one function. -/
def calibrateFromRows
    (rows : Array MarginalRow)
    (directionsOf : KernelKey → Array String)
    : Calibrated := Id.run do
  let agg := aggregate rows
  -- Group counts by KernelKey.
  let mut grouped : Std.HashMap KernelKey (Array (String × Nat)) := {}
  for r in agg do
    let k : KernelKey := ⟨r.cell, r.lens, r.fromState⟩
    let curr := (grouped[k]?).getD #[]
    grouped := grouped.insert k (curr.push (r.direction, r.count))
  -- Build the Dirichlet posterior for each key.
  let mut result : Calibrated := {}
  for entry in grouped.toArray do
    let k := entry.1
    let counts := entry.2
    let dirs := directionsOf k
    let post := fromCounts dirs counts
    result := result.insert k post
  pure result

/-- The events-table version of the calibration query. -/
def calibrate
    (events : Array Event)
    (cellOf : Nat → String)
    (directionsOf : KernelKey → Array String)
    : Calibrated :=
  calibrateFromRows (events.map (eventToMarginal cellOf)) directionsOf

/-- Read the calibrated posterior mean for one kernel key. Returns
    a list of `(direction, probability)` summing to 1. -/
def readMean (cal : Calibrated) (k : KernelKey) : Array (String × Float) :=
  match cal[k]? with
  | some α => posteriorMean α
  | none   => #[]

end ObsTeach.Calibration
