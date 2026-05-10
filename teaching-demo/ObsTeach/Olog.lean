/-
  ObsTeach.Olog
  =============

  Module 9 — Ologs and Functorial Data Migration.

  An **olog** is a categorical schema. A schema morphism
  `Φ : M → S` lets you pull data back along it (the Δ-functor of
  functorial data migration). The simulator's state schema and
  any external empirical schema *both* admit morphisms to a small
  shared **marginal-schema olog** `M`. Calibration against the
  empirical data factors through `M`.

  In code, the `M` schema is a small list of variables. Each
  source (simulator events, external CSV) provides a function
  that projects its rich state down to a row of `M`. Calibration
  consumes `M`-shaped rows uniformly.
-/

import Std.Data.HashMap

namespace ObsTeach.Olog

/-- One row of the marginal schema. Every calibration source
    must produce rows of this shape. The fields are the
    *common ground* between the simulator and the external data. -/
structure MarginalRow where
  cell      : String
  lens      : String
  fromState : String
  direction : String
  /-- Number of observed transitions of this kind. -/
  count     : Nat
  deriving Repr

/-- A morphism into the marginal schema is a function from the
    source schema's row type into `MarginalRow`.

    For the simulator: events are projected to `(cell, lens,
    from, direction)` and counted. For an external CSV: the
    columns are read directly into the same shape.

    The categorical content is that both projections are functors
    `S → M` of olog-categories; pulling back along them produces
    the same calibration target. (Module 9.3.) -/
abbrev SchemaMorphism (Source : Type) := Source → MarginalRow

/-- Aggregate a list of rows by `(cell, lens, from, direction)`,
    summing counts. This is the common GROUP BY that calibration
    consumes — the Δ-pullback of the marginal schema. -/
def aggregate (rows : Array MarginalRow) : Array MarginalRow := Id.run do
  let mut acc : Std.HashMap String MarginalRow := {}
  for r in rows do
    let key := s!"{r.cell}|{r.lens}|{r.fromState}|{r.direction}"
    match acc[key]? with
    | some existing =>
        acc := acc.insert key { existing with count := existing.count + r.count }
    | none =>
        acc := acc.insert key r
  pure (acc.toArray.map (·.2))

end ObsTeach.Olog
