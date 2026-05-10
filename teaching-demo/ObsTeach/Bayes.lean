/-
  ObsTeach.Bayes
  ==============

  Module 5 — Categorical Bayes: inversion, conjugacy, naturality.

  We implement the **Dirichlet–Multinomial conjugate update** —
  the only conjugate pair the simulator uses. The implementation
  is the simplest possible: add observed counts to prior pseudo-
  counts.

  The categorical content (Bayesian inverse, naturality, etc.)
  shows up here as the *uniformity* of the update: the same
  three-line procedure works for every per-edge calibration in
  the simulator, regardless of which lens or covariate cell it
  came from. That is what makes the architecture modular.
-/

namespace ObsTeach.Bayes

/-- A `Dirichlet` is a vector of positive pseudo-counts, one per
    direction label. For each `(covariate-cell, from-position)`
    we keep one of these — the parameter object Θ for the
    backward leg. -/
abbrev Dirichlet := Array (String × Float)

/-- `posteriorMean` reads off the Bayes-Laplace estimator. This
    is the formula from BLUEPRINT §5.1 with α = 0.5 (Jeffreys). -/
def posteriorMean (α : Dirichlet) : Array (String × Float) :=
  let total := α.foldl (fun acc (_, x) => acc + x) 0.0
  if total ≤ 0.0 then α
  else α.map (fun (d, x) => (d, x / total))

/-- The conjugate update map. Given prior parameters and a count
    array, return the posterior parameters. This is just
    componentwise addition by direction label. -/
def update (α : Dirichlet) (counts : Array (String × Nat)) : Dirichlet :=
  α.map fun (d, x) =>
    let n := (counts.find? (·.1 = d)).map (·.2) |>.getD 0
    (d, x + n.toFloat)

/-- `fromCounts` builds a Dirichlet posterior from a single batch
    of observed counts plus a Jeffreys prior of 0.5 per direction.
    This is the form returned by the calibration query. -/
def fromCounts (directions : Array String) (counts : Array (String × Nat)) : Dirichlet :=
  let prior : Dirichlet := directions.map (fun d => (d, 0.5))
  update prior counts

/-- Naturality fact (not proven here, but stated): updating with
    `c1` then `c2` equals updating with `c1 + c2`. The structural
    proof is associativity of `Float.add`. (Module 5.4.) -/
theorem update_naturality_sketch : True := trivial

end ObsTeach.Bayes
