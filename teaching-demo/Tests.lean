/-
  Tests.lean
  ==========

  A small smoke-test suite for the teaching simulator. Each test
  returns `IO Bool`. The runner prints a labelled PASS/FAIL line
  and exits with non-zero status if any test fails.

  Run with:

      lake exe obs-teach-tests

  Tests are grouped by the module they exercise:

    1. PRNG and samplers (Module 4 / Random.lean)
    2. Conjugate Bayesian update (Module 5)
    3. Cross-lens wirings (Module 7)
    4. Marginal-schema aggregation (Module 9)
    5. Calibration round-trip (Module 10)
    6. Lenses' polynomial structure (Module 1 / Lenses.lean)
-/

import ObsTeach

open ObsTeach.Random ObsTeach.Bayes ObsTeach.Wiring
open ObsTeach.Olog ObsTeach.Calibration ObsTeach.Trace
open ObsTeach.Lenses ObsTeach.Sim

/-- A small absolute tolerance for Float comparisons. -/
def ε : Float := 1.0e-9

/-- Approximate equality for Floats with a tolerance. -/
def approxEq (x y tol : Float) : Bool :=
  (if x ≥ y then x - y else y - x) ≤ tol

/-- Print a labelled PASS/FAIL line. Returns the bool unchanged. -/
def report (label : String) (ok : Bool) : IO Bool := do
  if ok then
    IO.println s!"  PASS  {label}"
  else
    IO.println s!"  FAIL  {label}"
  pure ok

/- ─────────────────────────────────────────────────────────────
   1. PRNG and samplers
   ───────────────────────────────────────────────────────────── -/

/-- Same seed yields the same uniform sample. (Determinism.) -/
def testPrngDeterministic : IO Bool := do
  let s : RandState := 42
  let (a, _) := uniform01 s
  let (b, _) := uniform01 s
  report "PRNG: same seed → same sample" (a == b)

/-- 1000 uniform samples are all in [0, 1). -/
def testUniformRange : IO Bool := do
  let mut s : RandState := 12345
  let mut allOk := true
  for _ in [0 : 1000] do
    let (u, s') := uniform01 s
    if u < 0.0 ∨ u ≥ 1.0 then allOk := false
    s := s'
  report "PRNG: uniform01 ∈ [0, 1)" allOk

/-- Exponential sample mean approaches 1/rate for large N. -/
def testExpMean : IO Bool := do
  let rate : Float := 2.0
  let N : Nat := 20000
  let mut sum : Float := 0.0
  let mut s : RandState := 99
  for _ in [0 : N] do
    let (t, s') := expSample rate s
    sum := sum + t
    s := s'
  let mean := sum / N.toFloat
  let target := 1.0 / rate
  -- Tolerance: 5% of target, i.e. relative within 5%.
  report s!"Exponential: empirical mean {mean} ≈ 1/λ {target}"
    (approxEq mean target (target * 0.05))

/-- Categorical sample proportions match the input weights. -/
def testCategoricalProportions : IO Bool := do
  let probs : Array Float := #[0.7, 0.2, 0.1]
  let N : Nat := 20000
  let mut counts : Array Nat := #[0, 0, 0]
  let mut s : RandState := 7
  for _ in [0 : N] do
    let (i, s') := categorical probs s
    counts := counts.modify i (· + 1)
    s := s'
  let p0 := counts[0]!.toFloat / N.toFloat
  let p1 := counts[1]!.toFloat / N.toFloat
  let p2 := counts[2]!.toFloat / N.toFloat
  let ok :=
    approxEq p0 0.7 0.02 ∧ approxEq p1 0.2 0.02 ∧ approxEq p2 0.1 0.02
  report s!"Categorical: empirical ({p0}, {p1}, {p2}) ≈ (0.7, 0.2, 0.1)" ok

/-- Competing exponentials: with rates [3.0, 1.0], the first
    direction should fire ~75% of the time. -/
def testCompetingExp : IO Bool := do
  let rates : Array Float := #[3.0, 1.0]
  let N : Nat := 20000
  let mut wins0 : Nat := 0
  let mut s : RandState := 13
  for _ in [0 : N] do
    let (i, _, s') := competingExp rates s
    if i = 0 then wins0 := wins0 + 1
    s := s'
  let p := wins0.toFloat / N.toFloat
  report s!"Competing exp: P(0) = {p} ≈ 0.75" (approxEq p 0.75 0.02)

/- ─────────────────────────────────────────────────────────────
   2. Bayes — Dirichlet–Multinomial conjugate update
   ───────────────────────────────────────────────────────────── -/

/-- Update is addition (Module 5.5). -/
def testUpdateIsAddition : IO Bool := do
  let prior : Dirichlet := #[("a", 0.5), ("b", 0.5)]
  let post := update prior #[("a", 3), ("b", 1)]
  let aOk := (post.find? (·.1 = "a")).map (·.2) == some 3.5
  let bOk := (post.find? (·.1 = "b")).map (·.2) == some 1.5
  report "Bayes: update(α, n) = α + n" (aOk ∧ bOk)

/-- Naturality: sequential update equals batch update (Module 5.4). -/
def testUpdateNaturality : IO Bool := do
  let prior : Dirichlet := #[("a", 0.5), ("b", 0.5), ("c", 0.5)]
  let c1 : Array (String × Nat) := #[("a", 2), ("b", 1)]
  let c2 : Array (String × Nat) := #[("a", 3), ("c", 4)]
  -- Sequential: update with c1 then c2.
  let seq := update (update prior c1) c2
  -- Batch: combine counts and update once.
  let combined : Array (String × Nat) :=
    #[("a", 5), ("b", 1), ("c", 4)]
  let batch := update prior combined
  let same := seq.all fun (d, x) =>
    (batch.find? (·.1 = d)).map (·.2) == some x
  report "Bayes: sequential ≡ batch (naturality)" same

/-- Posterior mean sums to 1 for any non-empty Dirichlet. -/
def testPosteriorMeanSumsToOne : IO Bool := do
  let α : Dirichlet := #[("a", 1.5), ("b", 3.0), ("c", 0.5)]
  let m := posteriorMean α
  let total := m.foldl (fun acc (_, p) => acc + p) 0.0
  report s!"Bayes: posterior mean sums to 1 (got {total})"
    (approxEq total 1.0 ε)

/-- A constructed Dirichlet with counts (80, 20) and Jeffreys prior
    should give posterior mean approximately (0.80, 0.20). -/
def testFromCountsExpectedMean : IO Bool := do
  let dirs : Array String := #["x", "y"]
  let counts : Array (String × Nat) := #[("x", 80), ("y", 20)]
  let post := fromCounts dirs counts
  let m := posteriorMean post
  let mx := (m.find? (·.1 = "x")).map (·.2) |>.getD 0.0
  let my := (m.find? (·.1 = "y")).map (·.2) |>.getD 0.0
  -- 80.5 / 101 ≈ 0.7970; 20.5 / 101 ≈ 0.2030
  report s!"Bayes: fromCounts (80, 20) → ({mx}, {my})"
    (approxEq mx (80.5 / 101.0) 1.0e-6 ∧ approxEq my (20.5 / 101.0) 1.0e-6)

/- ─────────────────────────────────────────────────────────────
   3. Wirings (Module 7)
   ───────────────────────────────────────────────────────────── -/

def testJusticeToLabourImprisons : IO Bool := do
  let l := wireJusticeToLabour .free .imprisoned .working
  report "Wiring: incarceration forces NILF" (l == LabourState.nilf)

def testJusticeToLabourReleases : IO Bool := do
  let l := wireJusticeToLabour .imprisoned .free .nilf
  report "Wiring: release returns to unemployed" (l == LabourState.unemployed)

def testJusticeToLabourNoOp : IO Bool := do
  -- Free → accused doesn't change labour status.
  let l := wireJusticeToLabour .free .accused .working
  report "Wiring: free→accused leaves labour unchanged" (l == LabourState.working)

def testJusticeToEducation : IO Bool := do
  let e := wireJusticeToEducation .free .imprisoned .inUniversity
  report "Wiring: incarceration forces notStudying"
    (e == EducationState.notStudying)

def testEducationToLabour : IO Bool := do
  -- Entering school forces NILF.
  let l1 := wireEducationToLabour .notStudying .inSchool .working
  -- Leaving school exits to unemployed.
  let l2 := wireEducationToLabour .inSchool .notStudying .nilf
  report "Wiring: school enrol/exit reroutes labour"
    (l1 == LabourState.nilf ∧ l2 == LabourState.unemployed)

def testAgeUnderSixteen : IO Bool := do
  let e := wireAgeToEducation 12 .notStudying
  report "Wiring: age < 16 forces inSchool" (e == EducationState.inSchool)

def testAgeOverTwentyFive : IO Bool := do
  let e := wireAgeToEducation 30 .inUniversity
  report "Wiring: age > 25 ⇒ inUniversity → notStudying"
    (e == EducationState.notStudying)

/- ─────────────────────────────────────────────────────────────
   4. Marginal-schema aggregation (Module 9)
   ───────────────────────────────────────────────────────────── -/

def testAggregateMergesDuplicates : IO Bool := do
  let rows : Array MarginalRow := #[
    { cell := "C", lens := "labour", fromState := "working",
      direction := "working_to_nilf", count := 3 },
    { cell := "C", lens := "labour", fromState := "working",
      direction := "working_to_nilf", count := 5 },
    { cell := "C", lens := "labour", fromState := "working",
      direction := "working_to_unemployed", count := 2 }
  ]
  let agg := aggregate rows
  -- We expect two distinct rows: NILF with count 8, unemployed with 2.
  let nilfCount := (agg.find? (·.direction = "working_to_nilf"))
                   |>.map (·.count) |>.getD 0
  let unempCount := (agg.find? (·.direction = "working_to_unemployed"))
                    |>.map (·.count) |>.getD 0
  report s!"Olog: aggregate merges duplicates (nilf={nilfCount}, unemp={unempCount})"
    (nilfCount = 8 ∧ unempCount = 2 ∧ agg.size = 2)

/- ─────────────────────────────────────────────────────────────
   5. Calibration round-trip (Module 10)
   ───────────────────────────────────────────────────────────── -/

/-- Build a synthetic events list that contains exactly known
    counts of two transitions for one person, and verify that the
    calibration query recovers the expected posterior. -/
def testCalibrationRoundTrip : IO Bool := do
  let mkEvent (dir : String) (i : Nat) : Event :=
    { personId := 0, period := 0, time := i.toFloat * 0.01,
      lens := "labour", fromState := "working", direction := dir }
  -- 80 working_to_unemployed + 20 working_to_nilf
  let evts : Array Event :=
    (Array.range 80).map (fun i => mkEvent "working_to_unemployed" i)
      ++ (Array.range 20).map (fun i => mkEvent "working_to_nilf" (i + 80))
  let cellOf : Nat → String := fun _ => "20-34|M|major"
  let cal := calibrate evts cellOf directionsOf
  let key : KernelKey := ⟨"20-34|M|major", "labour", "working"⟩
  let m := readMean cal key
  let pUnemp := (m.find? (·.1 = "working_to_unemployed")).map (·.2) |>.getD 0.0
  let pNilf  := (m.find? (·.1 = "working_to_nilf")).map (·.2)        |>.getD 0.0
  -- 80.5 / 101 and 20.5 / 101 (Jeffreys prior).
  report s!"Calibration: round-trip ({pUnemp}, {pNilf})"
    (approxEq pUnemp (80.5 / 101.0) 1.0e-6 ∧
     approxEq pNilf  (20.5 / 101.0) 1.0e-6)

/- ─────────────────────────────────────────────────────────────
   6. Lenses (Module 1 / Lenses.lean)
   ───────────────────────────────────────────────────────────── -/

/-- Every `(lens, fromState)` pair declared in `directionsOf`
    returns a non-empty array — i.e., there is at least one
    outgoing labelled transition from each polynomial position. -/
def testDirectionsOfExhaustive : IO Bool := do
  let cases : Array (String × String) := #[
    ("labour", "working"), ("labour", "unemployed"), ("labour", "nilf"),
    ("education", "inSchool"), ("education", "inUniversity"),
    ("education", "notStudying"),
    ("justice", "free"), ("justice", "accused"), ("justice", "imprisoned")
  ]
  let mut ok := true
  for (l, s) in cases do
    let dirs := directionsOf ⟨"any|cell", l, s⟩
    if dirs.isEmpty then ok := false
  report "Lenses: every (lens, fromState) has ≥ 1 direction" ok

/- ─────────────────────────────────────────────────────────────
   Runner
   ───────────────────────────────────────────────────────────── -/

def allTests : List (IO Bool) := [
  testPrngDeterministic,
  testUniformRange,
  testExpMean,
  testCategoricalProportions,
  testCompetingExp,
  testUpdateIsAddition,
  testUpdateNaturality,
  testPosteriorMeanSumsToOne,
  testFromCountsExpectedMean,
  testJusticeToLabourImprisons,
  testJusticeToLabourReleases,
  testJusticeToLabourNoOp,
  testJusticeToEducation,
  testEducationToLabour,
  testAgeUnderSixteen,
  testAgeOverTwentyFive,
  testAggregateMergesDuplicates,
  testCalibrationRoundTrip,
  testDirectionsOfExhaustive
]

def main : IO UInt32 := do
  IO.println "obs-teach: running test suite"
  let mut passed : Nat := 0
  let mut failed : Nat := 0
  for t in allTests do
    if (← t) then passed := passed + 1 else failed := failed + 1
  IO.println s!"\n{passed} passed, {failed} failed (of {passed + failed})"
  pure (if failed = 0 then 0 else 1)
