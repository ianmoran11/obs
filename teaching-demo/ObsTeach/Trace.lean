/-
  ObsTeach.Trace
  ==============

  Module 6 — Traces, Folds, and Within-Period Dynamics.

  The **additive trace** of a per-lens dynamic over a period
  produces the *events table* — a multiset of event-rows under
  disjoint union. The accumulator monoid is the bag of events;
  the loop iterates `(draw, split, accumulate)` until the period
  boundary fires; `emit` is any GROUP BY downstream.

  In Lean, the multiset accumulator is just `Array Event` — order
  is preserved here, but every per-period summary we compute is
  invariant under permutation, recovering the multiset semantics.
-/

import ObsTeach.Random
import ObsTeach.Markov

namespace ObsTeach.Trace

open ObsTeach.Random ObsTeach.Markov

/-- One row of the events table.

    Categorically, this is a single contribution to the additive
    trace's monoid. Multisets of `Event`s combine by disjoint
    union, which here is `Array.append`.

    `time` is wall-clock simulator time at which the event fired;
    `period` is the index of the reporting window in which it
    fell; `lens` is which lens emitted the event; `fromState` and
    `direction` are the multinomial transition that fired. -/
structure Event where
  personId   : Nat
  period     : Nat
  time       : Float
  lens       : String
  fromState  : String
  direction  : String
  deriving Repr

/-- Render one event as a CSV line. -/
def Event.toCsv (e : Event) : String :=
  s!"{e.personId},{e.period},{e.time},{e.lens},{e.fromState},{e.direction}"

/-- The CSV header — written once at the start of the events file. -/
def eventsHeader : String :=
  "person_id,period,time,lens,from_state,direction"

/-- The signature of a single per-lens, per-person, within-period
    `draw` step. Given a lens-specific kernel-key (covariate cell
    + position), the current time, and the random state, produce:

      * the next event time (absolute simulator time),
      * the direction that fires,
      * a fresh random state.

    This is the Kleisli-unfolded body of the additive trace. -/
abbrev DrawStep := String → Float → RandState → (Float × String × RandState)

/-- The body of the additive trace for one person, in one lens,
    over a single reporting period.

    Loops `draw` until either the period boundary is reached or
    the lens decides the person has exited. Returns:

      * the events emitted (the trace's accumulator value),
      * the final position-key (so subsequent periods know where
        to resume),
      * the time at which the loop closed,
      * a fresh random state.

    `keyOf` is the lens-specific function that turns the current
    position into the kernel-key. `transition` advances the
    inner state when a direction fires. (Module 6.4.) -/
partial def runWithinPeriod
    (personId : Nat) (period : Nat) (lens : String)
    (keyOf : String → String) (transition : String → String → String)
    (draw : DrawStep)
    (start : Float) (periodEnd : Float) (state : String)
    (s : RandState)
    : (Array Event × String × Float × RandState) :=
  let rec loop (cur : String) (now : Float) (s : RandState) (acc : Array Event)
      : (Array Event × String × Float × RandState) :=
    let key := keyOf cur
    let (eventTime, direction, s') := draw key now s
    if eventTime ≥ periodEnd then
      -- Period boundary — close the loop.
      (acc, cur, periodEnd, s')
    else
      let event : Event :=
        { personId, period, time := eventTime, lens,
          fromState := cur, direction }
      let next := transition cur direction
      loop next eventTime s' (acc.push event)
  loop state start s #[]

end ObsTeach.Trace
