import Lake
open Lake DSL

package «obs-teach» where
  -- A self-contained teaching microsimulator for the Compositional
  -- Stochastic Systems course. No external dependencies.

lean_lib «ObsTeach» where
  -- All the modules of the simulator live under the `ObsTeach.*`
  -- namespace and are exposed as a single library.

@[default_target]
lean_exe «obs-teach» where
  root := `Main
  -- The capstone driver. Run with `lake exe obs-teach`.

lean_exe «obs-teach-tests» where
  root := `Tests
  -- The smoke-test suite. Run with `lake exe obs-teach-tests`.
