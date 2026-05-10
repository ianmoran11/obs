/-
  ObsTeach.Markov
  ===============

  Module 4 — Categorical Probability and Markov Chains.

  We do not formalise `FinStoch` as a category; we instantiate
  the *operational* shape of a rate kernel and the two ways of
  using it: (a) competing exponentials in event time, and (b)
  matrix exponential of `Q · Δt` for per-tick discretisation.

  We also include a hazard-kernel variant (Module 4.6) used by
  the Justice lens to model prison-stay durations as Weibull —
  the one place in the project where memorylessness is wrong.
-/

import Std.Data.HashMap
import ObsTeach.Random

namespace ObsTeach.Markov

open ObsTeach.Random

/-- A `RateRow` is the list of outgoing rates from a single
    position. Entry `(d, λ)` means "instantaneous rate of firing
    direction `d`". The CTMC sojourn rate is the sum, the
    direction is categorical with weights proportional. -/
abbrev RateRow := Array (String × Float)

/-- A `RateKernel` for a position type assigns a rate-row to each
    `(covariate-cell, position)` pair. We key everything by
    `String` for simplicity in the demo. The keys are produced by
    the lens code; the values are estimated by calibration. -/
abbrev RateKernel := Std.HashMap String RateRow

/-- Look up the rate row for a covariate-cell-and-position key,
    returning an empty row if absent. -/
def lookup (k : RateKernel) (key : String) : RateRow :=
  match k[key]? with
  | some r => r
  | none   => #[]

/-- Sample the next event from a rate row using competing
    exponentials. Returns `(direction-label, elapsed-time)`. -/
def sampleNextEvent (row : RateRow) (s : RandState)
    : (String × Float × RandState) := Id.run do
  if row.isEmpty then
    pure ("__absorb__", 1.0e30, s)
  else
    let rates := row.map (·.2)
    let (i, t, s') := competingExp rates s
    pure ((row[i]!).1, t, s')

/-- A **hazard kernel** generalises the rate kernel: instead of a
    constant rate per direction, it supplies a function of
    time-in-state. We represent this as a `(τ → row of rates)` so
    that competing exponentials at the *current* hazard recovers
    the inverse-CDF Weibull / log-logistic / piecewise-constant
    sample. (Module 4.6.) -/
abbrev HazardKernel := String → Float → RateRow

/-- Discretisation: given a rate row, compute per-tick transition
    probabilities at width `Δt`. We use the first-order
    `P ≈ I + Q·Δt` approximation for very small `Δt`, and for
    larger ticks we use the exponential approximation
    `p_d ≈ (λ_d / λ_total) · (1 - exp(-λ_total · Δt))`, with the
    self-loop probability the residual `exp(-λ_total · Δt)`.

    This is the operational content of the `Discretise(Δt)` optic.
    For the demo we sample directly in event time, so this is
    presented for explanatory completeness. (Module 4.5.) -/
def discretise (row : RateRow) (dt : Float) : Array (String × Float) := Id.run do
  let total := row.foldl (fun acc (_, r) => acc + r) 0.0
  if total ≤ 0.0 then
    pure #[("__stay__", 1.0)]
  else
    let pAny := 1.0 - Float.exp (- total * dt)
    let outRows := row.map (fun (d, r) => (d, (r / total) * pAny))
    pure (outRows.push ("__stay__", 1.0 - pAny))

end ObsTeach.Markov
