# A Labour-Market and Prison Demo of System Composition

**Companion to [`system-composition-demo.md`](system-composition-demo.md).**
That file used a traffic light and a pedestrian to show the smallest
possible compositional demo. This file applies the same recipe to a
domain-relevant pair: a **justice** subsystem (free / accused /
imprisoned) and a **labour-force** subsystem (working / unemployed /
NILF). Together they reproduce the central worked example from
[`index.md`](index.md): an imprisoned person cannot also be working,
and a released person should re-enter the labour force.

The full Python source is inline. It also lives next to this file as
[`labour_prison_demo.py`](labour_prison_demo.py); both are kept in
sync.

---

## Table of contents

- [1. What we're demonstrating](#1-what-were-demonstrating)
- [2. The two subsystems](#2-the-two-subsystems)
- [3. The "maybe fire" rule (unchanged)](#3-the-maybe-fire-rule-unchanged)
- [4. Running them uncoupled](#4-running-them-uncoupled)
- [5. Observing the problem](#5-observing-the-problem)
- [6. Two flavours of wiring](#6-two-flavours-of-wiring)
- [7. Running the wired version](#7-running-the-wired-version)
- [8. What changed, line by line, in the joint loop](#8-what-changed-line-by-line-in-the-joint-loop)
- [9. Calibration consequences](#9-calibration-consequences)
- [10. The complete file](#10-the-complete-file)

---

## 1. What we're demonstrating

This demo has the same shape as the traffic-light one: two state
machines, one joint loop, a before/after triggered by adding wirings.
The difference is the domain — and one new pedagogical point:

> [!tip]
> **Two flavours of wiring.** Some cross-system rules describe a
> *state invariant* ("imprisoned implies NILF"). Others describe a
> *transition consequence* ("on release, become unemployed"). Both
> show up in this demo, and they look different in code.

We will see:

1. Each subsystem defined independently.
2. A naive joint run producing nonsense joint states like `imprisoned,
   working`.
3. **One state-based wiring** that enforces `imprisoned ⇒ NILF`.
4. **One event-based wiring** that turns release into unemployment.
5. The wired run, where the illegal cells vanish and release re-enters
   the labour force cleanly.

---

## 2. The two subsystems

Imports and seed:

```python
import random

random.seed(5)
```

The justice transition table. Each state has its own labelled events
and a next state per event.

```python
JUSTICE_EVENTS = {
    "free":       {"free_to_accused":       "accused"},
    "accused":    {"accused_to_imprisoned": "imprisoned",
                   "accused_to_free":       "free"},
    "imprisoned": {"imprisoned_to_free":    "free"},
}
```

The labour-force transition table.

```python
LABOUR_EVENTS = {
    "working":    {"lose_job":       "unemployed",
                   "leave_force":    "NILF"},
    "unemployed": {"find_job":       "working",
                   "give_up":        "NILF"},
    "NILF":       {"return_to_work": "working"},
}
```

> [!note]
> Both tables match the shape in `index.md`'s Module 1. Each table is
> a tiny polynomial coalgebra: positions on the outside, named
> directions out of each position. Calibration would later count
> events by name, which is why every transition has a label.

The Cartesian product of these two state spaces has `3 × 3 = 9` cells.
But three of those cells are illegal by domain rule:

| Justice | Labour | Legal? |
| --- | --- | --- |
| free | working | yes |
| free | unemployed | yes |
| free | NILF | yes |
| accused | working | yes |
| accused | unemployed | yes |
| accused | NILF | yes |
| imprisoned | working | **no** |
| imprisoned | unemployed | **no** |
| imprisoned | NILF | yes |

The wirings we will add cut the joint state space from 9 cells down to
the 7 legal ones.

---

## 3. The "maybe fire" rule (unchanged)

Same forward dynamics as the traffic-light demo: with some probability,
fire one randomly chosen valid event from the current state.

```python
def maybe_fire(state, events_table, fire_prob):
    """With probability fire_prob, fire a random valid event from state."""
    if random.random() >= fire_prob:
        return None, state
    options = events_table[state]
    event = random.choice(list(options.keys()))
    return event, options[event]
```

Why the same helper works for both demos: every subsystem in either
demo is a transition table of the same shape, so the firing rule is
generic.

---

## 4. Running them uncoupled

The naive joint run. Both subsystems step every tick, with no
awareness of each other. We flag any cell that violates the
`imprisoned ⇒ NILF` rule.

```python
def run_uncoupled(steps=20, fire_prob=0.5):
    justice = "free"
    labour  = "working"
    print(f"{'t':>3}  {'justice':<11}  {'labour':<11}  {'illegal?':<8}")
    for t in range(steps):
        _, justice = maybe_fire(justice, JUSTICE_EVENTS, fire_prob)
        _, labour  = maybe_fire(labour,  LABOUR_EVENTS,  fire_prob)
        illegal = (justice == "imprisoned" and labour != "NILF")
        flag    = "ILLEGAL" if illegal else ""
        print(f"{t:>3}  {justice:<11}  {labour:<11}  {flag}")
```

Invoke with the seed reset for determinism:

```python
random.seed(5)
run_uncoupled()
```

---

## 5. Observing the problem

```
=== Uncoupled (no wiring) ===
  t  justice      labour       illegal?
  0  free         working
  1  free         working
  2  free         working
  3  accused      working
  4  imprisoned   working      ILLEGAL
  5  free         working
  6  accused      working
  7  imprisoned   unemployed   ILLEGAL
  8  imprisoned   unemployed   ILLEGAL
  9  free         NILF
 10  accused      NILF
 11  imprisoned   NILF
 12  free         working
 13  free         working
 14  accused      working
 15  accused      NILF
 16  imprisoned   working      ILLEGAL
 17  free         working
 18  free         NILF
 19  free         working
```

Four ticks (`t = 4, 7, 8, 16`) are flagged. The simulator happily
records people as "imprisoned and working" or "imprisoned and
unemployed." Neither subsystem is wrong on its own — both transition
tables are perfectly sensible. The problem lives in the gap between
them.

> [!warning]
> Notice that at `t = 11` the uncoupled simulation gets the joint state
> right (`imprisoned, NILF`) **by accident** — because the labour
> subsystem happened to wander into NILF on its own. This is exactly
> the kind of accidental correctness that an unconstrained simulation
> produces. Sometimes the joint state is right; sometimes it isn't.
> Calibration built on top of this would over-count `imprisoned,
> working` events that never occur in real data.

---

## 6. Two flavours of wiring

The first wiring is a **state invariant**: at every tick, if justice is
`imprisoned`, then labour must be `NILF`. It does not care which event
fired; it just enforces the rule.

```python
def wire_imprisonment_to_labour(justice_state, labour_state):
    """While imprisoned, labour status is forced to NILF."""
    if justice_state == "imprisoned":
        return "NILF"
    return labour_state
```

The second wiring is an **event consequence**: when the specific event
`imprisoned_to_free` fires, the released person enters the labour
force as `unemployed`. Without this, a released person would stay
`NILF` simply because the imprisonment wiring last forced them there.

```python
def wire_release_to_labour(justice_event, labour_state):
    """On release, the person becomes 'unemployed' rather than stay NILF."""
    if justice_event == "imprisoned_to_free":
        return "unemployed"
    return labour_state
```

> [!summary] State-based vs event-based wirings
>
> | Aspect | State wiring | Event wiring |
> | --- | --- | --- |
> | Reads | another system's **state** | another system's **event** |
> | Fires | every tick that the invariant matters | only when the trigger event fires |
> | Use it for | invariants ("X implies Y") | transition consequences ("when X happens, do Y") |
>
> Both are total functions of typed inputs. Both are independent of
> each subsystem's transition table. Both can be added or removed
> without rewriting the joint loop.

---

## 7. Running the wired version

The wired loop adds two lines to the uncoupled loop — one per wiring.

```python
def run_wired(steps=20, fire_prob=0.5):
    justice = "free"
    labour  = "working"
    print(f"{'t':>3}  {'justice':<11}  {'labour':<11}  {'illegal?':<8}")
    for t in range(steps):
        justice_event, justice = maybe_fire(justice, JUSTICE_EVENTS, fire_prob)
        _,             labour  = maybe_fire(labour,  LABOUR_EVENTS,  fire_prob)
        labour = wire_release_to_labour(justice_event, labour)
        labour = wire_imprisonment_to_labour(justice, labour)
        illegal = (justice == "imprisoned" and labour != "NILF")
        flag    = "ILLEGAL" if illegal else ""
        print(f"{t:>3}  {justice:<11}  {labour:<11}  {flag}")
```

The release wiring is applied **before** the imprisonment wiring on
purpose: release first, then enforce the invariant for whatever the
new justice state is.

Run it with the same seed:

```python
random.seed(5)
run_wired()
```

Output:

```
=== Wired (justice -> labour) ===
  t  justice      labour       illegal?
  0  free         working
  1  free         working
  2  free         working
  3  accused      working
  4  imprisoned   NILF
  5  free         unemployed
  6  accused      unemployed
  7  imprisoned   NILF
  8  imprisoned   NILF
  9  free         unemployed
 10  accused      unemployed
 11  imprisoned   NILF
 12  free         unemployed
 13  free         unemployed
 14  accused      unemployed
 15  accused      NILF
 16  imprisoned   NILF
 17  free         unemployed
 18  free         NILF
 19  free         working
```

Zero `ILLEGAL` rows. And the release wiring is visible at `t = 5`,
`t = 9`, `t = 12`, and `t = 17`: each time someone leaves prison
(`imprisoned` at tick `n`, `free` at tick `n+1`), they appear as
`unemployed`, not `NILF`.

> [!tip]
> Compare `t = 4` in the two runs:
> - Uncoupled: `imprisoned, working` (illegal — clearly nonsense).
> - Wired: `imprisoned, NILF` (the state wiring snapped labour to NILF).
>
> And compare `t = 5`:
> - Uncoupled: `free, working` (labour was never disturbed).
> - Wired: `free, unemployed` (the event wiring caught the release).

---

## 8. What changed, line by line, in the joint loop

The diff between `run_uncoupled` and `run_wired` is two lines:

```diff
-        _, justice = maybe_fire(justice, JUSTICE_EVENTS, fire_prob)
+        justice_event, justice = maybe_fire(justice, JUSTICE_EVENTS, fire_prob)
         _,             labour  = maybe_fire(labour,  LABOUR_EVENTS,  fire_prob)
+        labour = wire_release_to_labour(justice_event, labour)
+        labour = wire_imprisonment_to_labour(justice, labour)
```

That is the entire mechanical cost of composing two subsystems
correctly. Each new wiring is one function definition and one call
site. Adding an Education subsystem next would add one transition
table, one `maybe_fire` call, and a wiring per cross-effect — and would
not touch any of the code already written.

---

## 9. Calibration consequences

The same illegal/legal distinction shows up in calibration. Suppose
the simulator collects events into a counts table indexed by the
joint state at the moment of firing. Uncoupled, you would see entries
for joint states like `(imprisoned, working) → lose_job`. Wired, those
cells are unreachable, so the counts table never accumulates against
them.

> [!note]
> This is why the main book emphasises labelled directions. If the
> labour and justice systems each emit named events, the calibration
> table groups by `(joint_state, fired_event)`. The wirings prune the
> joint state space; the labels make the counts groupable; the
> back-leg in Module 10 takes those counts and updates parameters. The
> three pieces line up cleanly only because each subsystem keeps its
> typed interface.

If you later add a soft coupling — say, the rate of `find_job` depends
on `justice_state` — the calibration table simply grows by one
grouping dimension, exactly the case discussed in §6.3 of
[`lens-composition-guide.md`](lens-composition-guide.md).

---

## 10. The complete file

For convenience, the entire script in one block. Save as
`labour_prison_demo.py` (or run the copy already saved alongside this
document) and execute with `python3 labour_prison_demo.py`.

```python
"""A second compositional-system demonstration: justice + labour.

Two state machines (justice status and labour-force status) are run side
by side. Without coupling, the joint state can become e.g.
(imprisoned, working) — someone holding a job while in prison. With a
single state-based wiring saying "imprisoned implies NILF", the illegal
joint states vanish.

A second, event-based wiring is added at the end: when someone is
released from prison, they re-enter the labour force as 'unemployed'
rather than remaining 'NILF'.
"""

import random

random.seed(5)

# ----------------------------------------------------------------------
# STEP 1: each subsystem is a transition table.
#   state -> { event_name -> next_state }
# ----------------------------------------------------------------------

JUSTICE_EVENTS = {
    "free":       {"free_to_accused":       "accused"},
    "accused":    {"accused_to_imprisoned": "imprisoned",
                   "accused_to_free":       "free"},
    "imprisoned": {"imprisoned_to_free":    "free"},
}

LABOUR_EVENTS = {
    "working":    {"lose_job":       "unemployed",
                   "leave_force":    "NILF"},
    "unemployed": {"find_job":       "working",
                   "give_up":        "NILF"},
    "NILF":       {"return_to_work": "working"},
}

# ----------------------------------------------------------------------
# STEP 2: a generic "maybe fire one event this tick" rule.
# ----------------------------------------------------------------------

def maybe_fire(state, events_table, fire_prob):
    """With probability fire_prob, fire a random valid event from state."""
    if random.random() >= fire_prob:
        return None, state
    options = events_table[state]
    event = random.choice(list(options.keys()))
    return event, options[event]

# ----------------------------------------------------------------------
# STEP 3: run the two systems side by side, with no coupling.
# ----------------------------------------------------------------------

def run_uncoupled(steps=20, fire_prob=0.5):
    justice = "free"
    labour  = "working"
    print(f"{'t':>3}  {'justice':<11}  {'labour':<11}  {'illegal?':<8}")
    for t in range(steps):
        _, justice = maybe_fire(justice, JUSTICE_EVENTS, fire_prob)
        _, labour  = maybe_fire(labour,  LABOUR_EVENTS,  fire_prob)
        illegal = (justice == "imprisoned" and labour != "NILF")
        flag    = "ILLEGAL" if illegal else ""
        print(f"{t:>3}  {justice:<11}  {labour:<11}  {flag}")

# ----------------------------------------------------------------------
# STEP 4: a state-based wiring — imprisoned implies NILF.
# ----------------------------------------------------------------------

def wire_imprisonment_to_labour(justice_state, labour_state):
    """While imprisoned, labour status is forced to NILF."""
    if justice_state == "imprisoned":
        return "NILF"
    return labour_state

# ----------------------------------------------------------------------
# STEP 5: an event-based wiring — release re-enters the labour force.
# ----------------------------------------------------------------------

def wire_release_to_labour(justice_event, labour_state):
    """On release, the person becomes 'unemployed' rather than stay NILF."""
    if justice_event == "imprisoned_to_free":
        return "unemployed"
    return labour_state

# ----------------------------------------------------------------------
# STEP 6: run again with both wirings applied each tick.
# ----------------------------------------------------------------------

def run_wired(steps=20, fire_prob=0.5):
    justice = "free"
    labour  = "working"
    print(f"{'t':>3}  {'justice':<11}  {'labour':<11}  {'illegal?':<8}")
    for t in range(steps):
        justice_event, justice = maybe_fire(justice, JUSTICE_EVENTS, fire_prob)
        _,             labour  = maybe_fire(labour,  LABOUR_EVENTS,  fire_prob)
        labour = wire_release_to_labour(justice_event, labour)
        labour = wire_imprisonment_to_labour(justice, labour)
        illegal = (justice == "imprisoned" and labour != "NILF")
        flag    = "ILLEGAL" if illegal else ""
        print(f"{t:>3}  {justice:<11}  {labour:<11}  {flag}")

if __name__ == "__main__":
    print("=== Uncoupled (no wiring) ===")
    random.seed(5)
    run_uncoupled()
    print()
    print("=== Wired (justice -> labour) ===")
    random.seed(5)
    run_wired()
```

Two machines, two wirings (one state-based, one event-based), one
before/after. The illegal joint cells go from four to zero, and the
release transition correctly re-enters the labour force.
