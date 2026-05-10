/-
  Main — the runnable entry point.

  Run with `lake exe obs-teach`. Optional arguments:

    --persons N   number of persons (default 1000)
    --periods N   number of monthly periods (default 60)
    --seed S      PRNG seed (hex; default 14627333968728801519)
    --out DIR     output directory for CSV (default "out")

  This program:
    1. Builds the cohort.
    2. Runs the simulation, accumulating an events table.
    3. Writes events.csv.
    4. Calibrates from events alone, prints recovered parameters.
    5. Calibrates from events ∪ external empirical rows, prints
       the result.
    6. Prints the truth for side-by-side comparison.
-/

import ObsTeach

open ObsTeach.Sim ObsTeach.FakeData ObsTeach.Substrate

/-- Make sure the output directory exists. -/
def ensureDir (path : System.FilePath) : IO Unit := do
  if ¬ (← path.pathExists) then
    IO.FS.createDirAll path

def parseArgs : List String → IO Config
  | [] => pure {}
  | "--persons" :: n :: rest => do
      let cfg ← parseArgs rest
      let some n' := n.toNat? | (do IO.eprintln "bad --persons"; pure cfg)
      pure { cfg with numPersons := n' }
  | "--periods" :: n :: rest => do
      let cfg ← parseArgs rest
      let some n' := n.toNat? | (do IO.eprintln "bad --periods"; pure cfg)
      pure { cfg with numPeriods := n' }
  | "--seed" :: s :: rest => do
      let cfg ← parseArgs rest
      pure { cfg with seed := (s.toNat?.getD 14627333968728801519).toUInt64 }
  | "--out" :: d :: rest => do
      let cfg ← parseArgs rest
      pure { cfg with outDir := d }
  | other => do
      IO.eprintln s!"unknown arg: {other}"; pure {}

/-- The map from `personId` to covariate cell. We rebuild the
    cohort to derive cells from ids; this matches how the
    simulator generates them. -/
def cellOfId (n : Nat) : Nat → String :=
  let cohort := initCohort n
  fun id =>
    if id < cohort.size then cohort[id]!.cell
    else "unknown"

def main (args : List String) : IO Unit := do
  let cfg ← parseArgs args
  IO.println s!"obs-teach: {cfg.numPersons} persons, {cfg.numPeriods} periods"
  IO.println "running simulation..."
  let (events, _final) := runSimulation cfg
  IO.println s!"  emitted {events.size} events"

  -- Write events.csv
  ensureDir cfg.outDir
  let csvPath := s!"{cfg.outDir}/events.csv"
  IO.FS.writeFile csvPath (eventsToCsv events)
  IO.println s!"  wrote {csvPath}"

  -- Round-trip calibration from events alone
  IO.println "\ncalibrating from simulator events only..."
  let cellOf := cellOfId cfg.numPersons
  let calA := calibrateFromEvents events cellOf
  IO.println (reportRecovery calA "RECOVERED (events only)")

  -- Calibration from events ∪ external rows
  IO.println "calibrating from events + external empirical rows..."
  let calB := calibrateFromBoth events cellOf externalEmpiricalRows
  IO.println (reportRecovery calB "RECOVERED (events + external)")

  -- Truth for comparison
  IO.println reportTruth

  IO.println "\ndone."
