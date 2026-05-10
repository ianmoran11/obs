/-
  ObsTeach.FakeData
  =================

  Two artefacts the demo needs:

    1. **True parameters.** A small set of "ground truth" rate
       parameters that the simulator uses to generate synthetic
       events. After running the simulation we forget these and
       try to recover them by calibration. This is the
       round-trip demo.

    2. **External empirical data.** A handful of marginal-schema
       rows that pretend to be from an external source (e.g., an
       AIHW table). We will calibrate against this *too* to
       demonstrate that the marginal-schema olog (Module 9) lets
       multiple sources contribute to the same posterior.

  The numbers below are illustrative. Rates are per year. The
  demo ticks in months (Δt = 1/12 year), so a rate of 0.1/year
  means roughly a 0.83% chance of firing in any given month.
-/

import Std.Data.HashMap
import ObsTeach.Markov
import ObsTeach.Substrate
import ObsTeach.Olog
import ObsTeach.Wiring

namespace ObsTeach.FakeData

open ObsTeach.Markov ObsTeach.Substrate ObsTeach.Olog ObsTeach.Wiring

/-- Build the "true" rate kernel. Keys are `cell|lens|from-state`,
    matching the `kernelKey` from `Lenses.lean`. We do *not*
    cell-vary every rate — most rates are constant across cells in
    this small demo. -/
def trueKernel : RateKernel :=
  let mk (k : String) (rs : Array (String × Float)) : (String × RateRow) := (k, rs)
  let rows : List (String × RateRow) := [
    -- Labour rates (constant across cells for the demo)
    -- Working → unemployed, working → nilf
    mk "*|labour|working"
       #[("working_to_unemployed", 0.08), ("working_to_nilf", 0.04)],
    mk "*|labour|unemployed"
       #[("unemployed_to_working", 0.50), ("unemployed_to_nilf", 0.10)],
    mk "*|labour|nilf"
       #[("nilf_to_working", 0.05), ("nilf_to_unemployed", 0.05)],
    -- Education rates (very rough — most movement is via wirings)
    mk "*|education|inSchool"
       #[("school_to_university", 0.20), ("school_to_notStudying", 0.05)],
    mk "*|education|inUniversity"
       #[("university_to_notStudying", 0.30)],
    mk "*|education|notStudying"
       #[("notStudying_to_university", 0.02)],
    -- Justice rates (the imprisoned hazard is computed elsewhere)
    mk "*|justice|free"
       #[("free_to_accused", 0.02)],
    mk "*|justice|accused"
       #[("accused_to_imprisoned", 0.40), ("accused_to_free", 1.50)]
    -- justice|imprisoned uses a Weibull hazard, not a flat rate
  ]
  Std.HashMap.ofList rows

/-- The Weibull parameters (shape, scale) for the
    `imprisoned → free` hazard. With `shape = 1.5` and
    `scale = 1.5` years, the median prison stay is around one
    year and the hazard rises with time served — qualitatively
    the right shape. -/
def truePrisonHazard : Float × Float := (1.5, 1.5)

/-- An external "empirical" dataset, supplied as a small list of
    marginal-schema rows. These pretend to come from an external
    source (e.g., an administrative-data table) and are
    aggregated counts of transitions in some reference period.

    The rows are deliberately sparse — only a couple of cells
    represented — so you can see them merge with the simulator's
    much larger event-derived counts during calibration. -/
def externalEmpiricalRows : Array MarginalRow := #[
  { cell := "20-34|M|major", lens := "labour", fromState := "unemployed",
    direction := "unemployed_to_working", count := 240 },
  { cell := "20-34|M|major", lens := "labour", fromState := "unemployed",
    direction := "unemployed_to_nilf",    count :=  50 },
  { cell := "20-34|F|major", lens := "labour", fromState := "unemployed",
    direction := "unemployed_to_working", count := 200 },
  { cell := "20-34|F|major", lens := "labour", fromState := "unemployed",
    direction := "unemployed_to_nilf",    count :=  60 }
]

end ObsTeach.FakeData
