/-
  ObsTeach.Random
  ===============

  A tiny pure-functional PRNG and the samplers we need for the
  forward leg of every lens. Everything is state-passing: a
  `RandState` is threaded through, never read from the environment.

  Why this matters categorically: a stochastic morphism `X → 𝒟(Y)`
  in a Markov category becomes, operationally, a *deterministic*
  function `X × RandState → Y × RandState`. That is the unfolding
  of the Giry-monad Kleisli morphism into pure code. (Module 4.1)
-/

namespace ObsTeach.Random

/-- The PRNG state is a single 64-bit word. Splittable, deterministic,
    no IO. -/
abbrev RandState := UInt64

/-- One step of a SplitMix-style LCG. The constants are from
    Numerical Recipes, chosen so the period is 2^64. -/
@[inline] def step (s : RandState) : RandState :=
  s * 6364136223846793005 + 1442695040888963407

/-- Uniform sample in [0, 1) with 53 bits of resolution. -/
def uniform01 (s : RandState) : Float × RandState :=
  let s' := step s
  -- Take the top 53 bits and divide by 2^53.
  let bits : UInt64 := s' >>> 11
  let u : Float := bits.toNat.toFloat / 9007199254740992.0
  (u, s')

/-- Exponential sample by inverse CDF: `T = -log(1 - U) / λ`.
    This is the textbook one-line CTMC sojourn-time draw. -/
def expSample (rate : Float) (s : RandState) : Float × RandState :=
  let (u, s') := uniform01 s
  let t := -(Float.log (1.0 - u)) / rate
  (t, s')

/-- Weibull sample by inverse CDF:
    `T = scale · (-log(1 - U))^(1/shape)`.

    Used for non-memoryless dwell times (e.g., prison stays).
    (Module 4.6: hazard models.) -/
def weibullSample (shape scale : Float) (s : RandState) : Float × RandState :=
  let (u, s') := uniform01 s
  let x := -(Float.log (1.0 - u))
  -- x^(1/shape) = exp(log(x)/shape)
  let t := scale * Float.exp (Float.log x / shape)
  (t, s')

/-- Categorical sample over an array of probabilities. Returns the
    index that fires.

    Used at every multinomial transition. (Module 4.3.) -/
def categorical (probs : Array Float) (s : RandState) : Nat × RandState := Id.run do
  let (u, s') := uniform01 s
  let mut cum : Float := 0.0
  let mut chosen : Nat := probs.size - 1
  let mut found := false
  for i in [0 : probs.size] do
    if !found then
      cum := cum + probs[i]!
      if u ≤ cum then
        chosen := i
        found := true
  pure (chosen, s')

/-- Competing-exponentials draw: given a vector of rates, return
    the firing index and the elapsed time. By the standard fact that
    the minimum of independent exponentials is exponential and the
    arg-min is categorical with weights proportional to rates,
    this is equivalent to "exponential sojourn + categorical
    direction" — but generalises uniformly to hazards. (Module 4.4.) -/
def competingExp (rates : Array Float) (s : RandState) : (Nat × Float × RandState) := Id.run do
  let total := rates.foldl (· + ·) 0.0
  if total ≤ 0.0 then
    -- absorbing state
    pure (0, 1.0e30, s)
  else
    let (t, s1) := expSample total s
    let probs := rates.map (· / total)
    let (i, s2) := categorical probs s1
    pure (i, t, s2)

end ObsTeach.Random
