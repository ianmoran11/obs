/-
  ObsTeach.ParaLens
  =================

  Module 3 — The Para construction and parametric lenses.

  A **parametric lens** has type `(Θ × p) ⇆ q`:
    forward leg :  Θ × pos(p) × dir(q)? → pos(q)
    backward leg : Θ × pos(p) × dir(q)  → Θ × dir(p)

  The forward leg simulates; the backward leg updates parameters
  *and* routes outer directions into inner ones. In our setting
  the backward leg is calibration (Module 10) and the parameter
  object Θ is the per-edge probability simplex (Module 5).

  We give a minimal record-shaped formulation here that the
  actual lenses (Population, Labour, Education, Justice) will
  fill in.
-/

import ObsTeach.Foundations
import ObsTeach.Markov
import ObsTeach.Random

namespace ObsTeach.ParaLens

open ObsTeach.Random

/-- A `Forward` is the simulator's per-step morphism. Given
    parameters, current position, and a random state, produce the
    next position, an event label (the direction that fired), the
    elapsed event time, and a fresh random state.

    This is the Kleisli-unfolded form of a stochastic lens:
    `Θ × Pos → 𝒟(Pos × DirLabel × Time)`. -/
structure Forward (Θ Pos : Type) where
  step : Θ → Pos → RandState → (Pos × String × Float × RandState)

/-- A `Backward` is the parameter-update morphism. Given current
    parameters and a multiset of observed events, produce updated
    parameters. This is exactly the Bayesian inverse of the
    forward leg under conjugacy (Module 5). -/
structure Backward (Θ : Type) where
  update : Θ → Array (String × String × String) → Θ
  -- (covariate-cell, from-position, fired-direction)

/-- A parametric lens. The forward leg is responsible for the
    simulator's dynamics; the backward leg is responsible for the
    calibration. Together they form a `(Θ × p) ⇆ q` morphism in
    `Para(Lens(FinStoch))`. -/
structure ParaLens (Θ Pos : Type) where
  fwd : Forward Θ Pos
  bwd : Backward Θ

end ObsTeach.ParaLens
