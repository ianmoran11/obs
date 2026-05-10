/-
  ObsTeach — library root.
  Re-exports every module of the teaching simulator.

  Each module of the course corresponds to one (or two) Lean
  files:

    Module 1, 2  — Foundations.lean
    Module 3     — ParaLens.lean
    Module 4     — Markov.lean (rate kernels, hazards, Discretise)
    Module 5     — Bayes.lean (Dirichlet–Multinomial conjugate update)
    Module 6     — Trace.lean (additive trace)
    Module 7     — Wiring.lean (wirings + behaviour-preserving morphisms)
    Module 8     — Substrate.lean (Person, Reader pattern)
    Module 9     — Olog.lean (marginal-schema common ground)
    Module 10    — Calibration.lean (backward-leg query)
    Module 11    — Sim.lean (capstone: the full driver)

  Auxiliary:
    Random.lean   — pure-functional PRNG and samplers
    Lenses.lean   — the four lenses' polynomial structure
    FakeData.lean — true parameters + external empirical rows
-/

import ObsTeach.Random
import ObsTeach.Foundations
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
import ObsTeach.Sim
