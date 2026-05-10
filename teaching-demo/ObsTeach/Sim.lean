/-
  ObsTeach.Sim
  ============

  Module 11 — Capstone. Wires every module of the course into one
  runnable simulator + calibration round-trip.

  The structure of `runSimulation` mirrors the BLUEPRINT pipeline:

    * Initialise a cohort of persons (Module 8 substrate).
    * For each reporting period:
        - For each person, for each lens, run the additive trace
          (Module 6) over the period.
        - Apply cross-lens wirings (Module 7) on each transition.
        - Append events to the global table.
        - Age the cohort by one period (Population kernel,
          Module 8).
    * After all periods, write the events table.
    * Calibrate from events alone (Module 5 conjugate update,
      Module 10 backward-leg query).
    * Calibrate from events ∪ external rows (Module 9 marginal
      schema acting as common ground).
    * Report true vs recovered parameters.
-/

import Std.Data.HashMap
import ObsTeach.Foundations
import ObsTeach.Random
import ObsTeach.Markov
import ObsTeach.ParaLens
import ObsTeach.Bayes
import ObsTeach.Trace
import ObsTeach.Wiring
import ObsTeach.Substrate
import ObsTeach.Olog
import ObsTeach.Calibration
import ObsTeach.Lenses
import ObsTeach.FakeData

namespace ObsTeach.Sim

open ObsTeach.Random ObsTeach.Markov ObsTeach.Bayes ObsTeach.Trace
open ObsTeach.Wiring ObsTeach.Substrate ObsTeach.Olog
open ObsTeach.Calibration ObsTeach.Lenses ObsTeach.FakeData

/-- Demo configuration. -/
structure Config where
  numPersons    : Nat   := 1000
  numPeriods    : Nat   := 60
  /-- One simulator period in years. Default: one month. -/
  dtYears       : Float := 1.0 / 12.0
  seed          : UInt64 := 0xCAFEBABEDEADBEEF
  outDir        : String := "out"

/- ─────────────────────────────────────────────────────────────
   Cohort initialisation
   ───────────────────────────────────────────────────────────── -/

/-- Build an initial population by deterministically rotating
    through demographic combinations. Not realistic, but
    reproducible and small enough to inspect. -/
def initCohort (n : Nat) : Array Person := Id.run do
  let sexes : Array Sex := #[.male, .female]
  let regions : Array Region := #[.major, .regional, .remote]
  let mut acc : Array Person := #[]
  for i in [0 : n] do
    let age := 5 + (i % 75)
    let sex := sexes[i % 2]!
    let region := regions[i % 3]!
    acc := acc.push { id := i, age, sex, region, cohort := 0 }
  pure acc

/-- Initial joint state for one person — most start `unemployed`,
    `notStudying`, `free`. Children under 16 start `inSchool`. -/
def initJoint (p : Person) : JointState :=
  let edu : EducationState :=
    if p.age < 16 then .inSchool
    else if p.age < 23 ∧ p.id % 4 = 0 then .inUniversity
    else .notStudying
  let lab : LabourState :=
    if p.age < 16 then .nilf
    else if edu == EducationState.inUniversity then .nilf
    else if p.age >= 65 then .nilf
    else if p.id % 5 = 0 then .unemployed
    else .working
  { person := p, labour := lab, education := edu,
    justice := .free, prisonEntered := -1.0 }

/- ─────────────────────────────────────────────────────────────
   Forward leg: per-lens draw using the `trueKernel`
   ───────────────────────────────────────────────────────────── -/

/-- Build the "*|lens|from" key for a constant-across-cells row.
    The simulation generator uses constant rates for simplicity. -/
def kernelKeyTrue (lens : LensName) (from_ : String) : String :=
  s!"*|{lens.toString}|{from_}"

/-- Draw the next labour event. Returns absolute event time,
    direction label, and a fresh seed. -/
def drawLabour (_cell : String) (now : Float) (s : RandState) (st : JointState)
    : (Float × String × RandState) :=
  let from_ := LabourState.toString st.labour
  let key := kernelKeyTrue .labour from_
  let row := lookup trueKernel key
  let (dir, dt, s') := sampleNextEvent row s
  -- Convert from years to absolute time.
  (now + dt, dir, s')

def drawEducation (_cell : String) (now : Float) (s : RandState) (st : JointState)
    : (Float × String × RandState) :=
  let from_ := EducationState.toString st.education
  let key := kernelKeyTrue .education from_
  let row := lookup trueKernel key
  let (dir, dt, s') := sampleNextEvent row s
  (now + dt, dir, s')

/-- Justice draw uses a Weibull hazard for `imprisoned`, and a
    constant rate row for the other positions. -/
def drawJustice (_cell : String) (now : Float) (s : RandState) (st : JointState)
    : (Float × String × RandState) :=
  match st.justice with
  | .imprisoned =>
      let τ := now - st.prisonEntered
      let (shape, scale) := truePrisonHazard
      let h := weibullHazard shape scale (max τ 0.001)
      let row : RateRow := #[("imprisoned_to_free", h)]
      let (dir, dt, s') := sampleNextEvent row s
      (now + dt, dir, s')
  | _ =>
      let from_ := JusticeState.toString st.justice
      let key := kernelKeyTrue .justice from_
      let row := lookup trueKernel key
      let (dir, dt, s') := sampleNextEvent row s
      (now + dt, dir, s')

/- ─────────────────────────────────────────────────────────────
   Per-period dynamics — the additive-trace loop
   ───────────────────────────────────────────────────────────── -/

/-- Run one person, one lens, over one period. Returns the
    emitted events and the updated joint state. We loop on
    competing lenses *jointly* — the next event across all three
    domain lenses is the one that fires next. This is the
    parallel-product trace of Module 7.

    The function keeps drawing the next-candidate event time per
    lens, takes the minimum, applies the wirings, and repeats
    until the period ends. -/
partial def runPersonPeriod
    (period : Nat) (periodStart periodEnd : Float)
    (st0 : JointState) (s0 : RandState)
    : (Array Event × JointState × RandState) := Id.run do
  let mut st := st0
  let mut s := s0
  let mut acc : Array Event := #[]
  let mut now := periodStart
  let mut continue_ := true
  while continue_ do
    let cell := st.person.cell
    -- Sample next event from each lens.
    let (tL, dL, s1) := drawLabour cell now s st
    let (tE, dE, s2) := drawEducation cell now s1 st
    let (tJ, dJ, s3) := drawJustice cell now s2 st
    s := s3
    -- Find the earliest event.
    let earliest :=
      if tL ≤ tE ∧ tL ≤ tJ then ("labour", tL, dL)
      else if tE ≤ tJ then ("education", tE, dE)
      else ("justice", tJ, dJ)
    let (lens, t, dir) := earliest
    if t ≥ periodEnd then
      now := periodEnd
      continue_ := false
    else
      now := t
      -- Apply the transition for the firing lens, plus its wirings.
      match lens with
      | "labour" =>
          let oldL := st.labour
          let newL := labourNext oldL dir
          let from_ := LabourState.toString oldL
          acc := acc.push { personId := st.person.id, period, time := t,
                            lens := "labour", fromState := from_, direction := dir }
          st := { st with labour := newL }
      | "education" =>
          let oldE := st.education
          let newE := educationNext oldE dir
          let from_ := EducationState.toString oldE
          acc := acc.push { personId := st.person.id, period, time := t,
                            lens := "education", fromState := from_, direction := dir }
          st := applyEducationWirings oldE newE st
      | "justice" =>
          let oldJ := st.justice
          let newJ := justiceNext oldJ dir
          let from_ := JusticeState.toString oldJ
          acc := acc.push { personId := st.person.id, period, time := t,
                            lens := "justice", fromState := from_, direction := dir }
          let st1 := applyJusticeWirings oldJ newJ st
          let st2 :=
            if newJ == JusticeState.imprisoned then
              { st1 with prisonEntered := t }
            else st1
          st := st2
      | _ => continue_ := false
  pure (acc, st, s)

/-- Age every person by one period and apply the age-based
    education wiring. This is the Population kernel — the only
    morphism that writes to `Person`. (Module 8.4.) -/
def ageCohort (dtYears : Float) (states : Array JointState) : Array JointState :=
  states.map fun st =>
    -- We use a coarse age increment: integer years per simulation
    -- year. This is a teaching demo, not an actuarial model.
    let newAge := st.person.age + (if dtYears ≥ 1.0 then 1 else 0)
    if newAge ≠ st.person.age then applyAgeWirings newAge st else st

/- ─────────────────────────────────────────────────────────────
   Top-level driver
   ───────────────────────────────────────────────────────────── -/

/-- Run the full multi-period simulation. Returns the events and
    the final joint states. -/
def runSimulation (cfg : Config) : (Array Event × Array JointState) := Id.run do
  let cohort := initCohort cfg.numPersons
  let mut states : Array JointState := cohort.map initJoint
  let mut events : Array Event := #[]
  let mut s : RandState := cfg.seed
  for period in [0 : cfg.numPeriods] do
    let periodStart := period.toFloat * cfg.dtYears
    let periodEnd := periodStart + cfg.dtYears
    let mut newStates : Array JointState := Array.mkEmpty states.size
    for st in states do
      -- Mix the seed with the person id so different persons see
      -- different randomness even with the same global seed.
      let personSeed : RandState := s ^^^ st.person.id.toUInt64
      let (evts, st', s') := runPersonPeriod period periodStart periodEnd st personSeed
      events := events ++ evts
      newStates := newStates.push st'
      s := s'
    states := ageCohort cfg.dtYears newStates
  pure (events, states)

/- ─────────────────────────────────────────────────────────────
   Direction lookup — needed by the calibration query
   ───────────────────────────────────────────────────────────── -/

def directionsOf (k : KernelKey) : Array String :=
  match k.lens, k.fromState with
  | "labour", "working"    => labourDirections .working
  | "labour", "unemployed" => labourDirections .unemployed
  | "labour", "nilf"       => labourDirections .nilf
  | "education", "inSchool"     => educationDirections .inSchool
  | "education", "inUniversity" => educationDirections .inUniversity
  | "education", "notStudying"  => educationDirections .notStudying
  | "justice", "free"       => justiceDirections .free
  | "justice", "accused"    => justiceDirections .accused
  | "justice", "imprisoned" => justiceDirections .imprisoned
  | _, _ => #[]

/- ─────────────────────────────────────────────────────────────
   Calibration round-trip and external-data calibration
   ───────────────────────────────────────────────────────────── -/

/-- Calibrate using only the simulator's own events. -/
def calibrateFromEvents
    (events : Array Event)
    (cellOf : Nat → String)
    : Calibrated :=
  calibrate events cellOf directionsOf

/-- Calibrate using the simulator's events *plus* external rows.
    This demonstrates the marginal-schema olog as common ground:
    both sources contribute counts to the same posterior keyed
    by `(cell, lens, from, direction)`. -/
def calibrateFromBoth
    (events : Array Event)
    (cellOf : Nat → String)
    (external : Array MarginalRow)
    : Calibrated :=
  let simRows := events.map (eventToMarginal cellOf)
  calibrateFromRows (simRows ++ external) directionsOf

/- ─────────────────────────────────────────────────────────────
   Reporting helpers
   ───────────────────────────────────────────────────────────── -/

def eventsToCsv (events : Array Event) : String := Id.run do
  let mut out := eventsHeader ++ "\n"
  for e in events do
    out := out ++ e.toCsv ++ "\n"
  pure out

/-- Aggregate calibration counts into a single per-(lens, from)
    summary, ignoring cells. This is what we compare against the
    constant-across-cells `trueKernel`. -/
def aggregateAcrossCells (cal : Calibrated) : Std.HashMap String (Array (String × Float)) := Id.run do
  let mut sums : Std.HashMap String Dirichlet := {}
  for entry in cal.toArray do
    let k := entry.1
    let α := entry.2
    let lensKey := s!"{k.lens}|{k.fromState}"
    let curr := (sums[lensKey]?).getD (α.map fun (d, _) => (d, 0.0))
    let combined : Dirichlet := α.map fun (d, x) =>
      let prev :=
        ((curr.find? (·.1 = d)).map (·.2)).getD 0.0
      (d, prev + x)
    sums := sums.insert lensKey combined
  let mut out : Std.HashMap String (Array (String × Float)) := {}
  for entry in sums.toArray do
    out := out.insert entry.1 (posteriorMean entry.2)
  pure out

/-- Pretty-print the recovered parameters next to the truth. -/
def reportRecovery
    (cal : Calibrated)
    (label : String) : String := Id.run do
  let agg := aggregateAcrossCells cal
  let mut out := s!"\n=== {label} ===\n"
  for entry in agg.toArray do
    out := out ++ s!"  {entry.1}\n"
    for (d, p) in entry.2 do
      out := out ++ s!"    {d}: {p}\n"
  pure out

/-- Print true rate-row probabilities (normalising rates to a
    probability vector for direct comparison with the recovered
    posterior mean). -/
def reportTruth : String := Id.run do
  let mut out := s!"\n=== TRUE PARAMETERS (rate proportions) ===\n"
  for entry in trueKernel.toArray do
    let key := entry.1
    let row := entry.2
    let total := row.foldl (fun acc (_, r) => acc + r) 0.0
    out := out ++ s!"  {key}\n"
    for (d, r) in row do
      let p := if total > 0.0 then r / total else 0.0
      out := out ++ s!"    {d}: {p}\n"
  pure out

end ObsTeach.Sim
