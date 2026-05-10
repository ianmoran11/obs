/-
  ObsTeach.Foundations
  ====================

  Modules 1 (Coalgebras) and 2 (Yoneda) — the structural skeleton.

  We make explicit two ideas that everything else depends on:

  * A **polynomial coalgebra** is a state machine `S → p(S)`.
    For finite enumerable position-types, `p(S) = Σᵢ S^{p[i]}` is
    just "for each position i, a function from directions out of i
    to next-states".
  * **Representables and the Yoneda intuition**: a polynomial is
    a coproduct of representables, and a lens between polynomials
    is exactly a forward map of positions plus a backward map of
    directions. This is what makes the lens-types of Module 3
    natural.

  We give a tiny worked formulation as Lean types. The simulator
  uses concrete instantiations of these throughout.
-/

namespace ObsTeach.Foundations

/-- A `Polynomial` indexed by a finite type of positions `Pos`,
    where each position has a finite type of outgoing directions.

    This is `p = Σᵢ:Pos. y^{Dir i}` written as a record. The
    `runCoalg` of a coalgebra `S → p(S)` will pattern match on the
    position and supply a per-direction next-state. -/
structure Polynomial where
  Pos : Type
  Dir : Pos → Type

/-- An F-coalgebra for the polynomial functor `p` on carrier `S`.
    The `step` says: from any state, decide a position, and provide
    a next-state for each outgoing direction.

    For a *deterministic* coalgebra, the direction is chosen by the
    enclosing dynamics; for a stochastic one (Module 4), the choice
    of direction is sampled. The structural shape is the same. -/
structure Coalgebra (p : Polynomial) (S : Type) where
  step : S → (i : p.Pos) ×' (p.Dir i → S)

/-- A **lens** between polynomials `p` and `q`.
    Forward: positions of `p` map to positions of `q`.
    Backward: at each position of `p`, directions of `q` (out of
    the image position) map back to directions of `p`.

    This is the data of a morphism in `Poly` — Module 1.4 / 3.1. -/
structure PolyLens (p q : Polynomial) where
  fwd : p.Pos → q.Pos
  bwd : (i : p.Pos) → q.Dir (fwd i) → p.Dir i

/-- Representables and Yoneda — the slogan version.

    A polynomial `p` represents the functor `S ↦ p(S)`. Yoneda
    says: a natural transformation between two such functors is
    *exactly* a lens between the polynomials. We will not prove
    this here, but we will *use* it: every parametric lens we
    construct gets its forward/backward shape from the Yoneda
    decomposition of its polynomial. (Module 2.) -/
def yonedaSlogan : String :=
  "Maps between representables = lenses between polynomials"

/-- For most of the simulator the position type is just an enum
    (`LabourState`, `EducationState`, `JusticeState`) and the
    direction type is *also* an enum (the labelled outgoing
    transitions out of each position). We package the simplest
    such polynomial as a small finite record. -/
structure FinitePoly where
  positions : List String
  /-- For each position, the labelled directions that exit it. -/
  directionsAt : String → List String

end ObsTeach.Foundations
