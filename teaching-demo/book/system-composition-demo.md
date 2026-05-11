# A Tiny Demo of System Composition

**Companion to [`lens-composition-guide.md`](lens-composition-guide.md) and
[`index.md`](index.md).** The other two files explain what compositional
system design *is*; this file shows it running. The example is the
smallest one that still has a point: two state machines, one wiring, and
a before/after that you can run yourself.

The full Python source is reproduced inline. It also lives next to this
file as [`system_composition_demo.py`](system_composition_demo.py); the
two are kept in sync.

---

## Table of contents

- [1. What we're demonstrating](#1-what-were-demonstrating)
- [2. Two subsystems as transition tables](#2-two-subsystems-as-transition-tables)
- [3. A generic "fire one event" rule](#3-a-generic-fire-one-event-rule)
- [4. Running the systems side by side, with no coupling](#4-running-the-systems-side-by-side-with-no-coupling)
- [5. Observing the problem](#5-observing-the-problem)
- [6. Adding a wiring](#6-adding-a-wiring)
- [7. Running again, with the wiring in place](#7-running-again-with-the-wiring-in-place)
- [8. What this scales to](#8-what-this-scales-to)
- [9. The complete file](#9-the-complete-file)

---

## 1. What we're demonstrating

The slogan from the companion guide was:

> Build each part as a small machine, then declare how the machines are
> wired together.

To make that concrete we need:

1. **Two small machines.** Independent, with their own states and
   labelled transitions. We use a traffic light and a pedestrian.
2. **A naive joint run.** Step both machines independently, watch
   nonsense joint states arise (pedestrian crossing while the light is
   green).
3. **One typed wiring.** A small rule saying "when the light turns
   green, force the pedestrian back to waiting."
4. **A wired joint run.** Same code, same machines, same random seed —
   but the nonsense states never appear.

That is the whole story. The point is to feel the size of each piece:
the machines are tiny, the wiring is one function, and yet the joint
behaviour they produce is meaningfully different.

---

## 2. Two subsystems as transition tables

We start with imports and a fixed random seed so the output is
reproducible.

```python
import random

random.seed(7)
```

Each subsystem is a transition table: from each state, the events you
can fire and the next state each event produces.

```python
LIGHT_EVENTS = {
    "green": {"green_to_red":  "red"},
    "red":   {"red_to_green":  "green"},
}

PED_EVENTS = {
    "waiting":  {"start_crossing":  "crossing"},
    "crossing": {"finish_crossing": "waiting"},
}
```

> [!note]
> The events have **names**. That matters: when we later collect events
> for calibration, the names are exactly what we'd count. Bare integers
> or anonymous probabilities would lose the labels and break the
> calibration story from Module 10.

Read these as small polynomial functors. `LIGHT_EVENTS["green"]` is the
direction set at position `green`; the value `"red"` is the next-state
function applied to the single direction.

---

## 3. A generic "fire one event" rule

We need one piece of dynamics. With some probability the system fires
an event; otherwise it stays put.

```python
def maybe_fire(state, events_table, fire_prob):
    """With probability fire_prob, fire a random valid event from state."""
    if random.random() >= fire_prob:
        return None, state
    options = events_table[state]
    event = random.choice(list(options.keys()))
    return event, options[event]
```

This function is the closest thing to a "forward leg" in this tiny demo.
It returns two things:

- the **event** that fired (or `None`),
- the **next state**.

That is precisely the polynomial-lens-style pair: a labelled direction
plus a next position.

---

## 4. Running the systems side by side, with no coupling

Now the naive joint run. Both subsystems step every tick, with no
awareness of each other. We also flag any tick where the joint state is
something a sensible model should not allow:

```python
def run_uncoupled(steps=12, fire_prob=0.7):
    light = "red"
    ped   = "waiting"
    print(f"{'t':>3}  {'light':<5}  {'ped':<8}  {'illegal?':<8}")
    for t in range(steps):
        _, light = maybe_fire(light, LIGHT_EVENTS, fire_prob)
        _, ped   = maybe_fire(ped,   PED_EVENTS,   fire_prob)
        illegal  = (light == "green" and ped == "crossing")
        flag     = "ILLEGAL" if illegal else ""
        print(f"{t:>3}  {light:<5}  {ped:<8}  {flag}")
```

We invoke it with the seed reset so the output is deterministic:

```python
random.seed(7)
run_uncoupled()
```

---

## 5. Observing the problem

Running the file produces this:

```
=== Uncoupled (no wiring) ===
  t  light  ped       illegal?
  0  green  crossing  ILLEGAL
  1  red    waiting
  2  red    crossing
  3  green  waiting
  4  red    waiting
  5  green  crossing  ILLEGAL
  6  red    waiting
  7  green  crossing  ILLEGAL
  8  red    waiting
  9  green  crossing  ILLEGAL
 10  red    crossing
 11  green  waiting
```

Four out of twelve ticks are flagged. The Cartesian product of the two
state spaces has four cells, and all four are reachable — including the
one we'd like to rule out.

> [!warning]
> This is exactly the failure mode the main book warns about: the raw
> parallel product of two subsystems is **too permissive**. It allows
> joint states that the modelled domain shouldn't allow.

The fix is *not* to redesign either subsystem. Both are correct on their
own. The fix lives in the gap between them.

---

## 6. Adding a wiring

A **wiring** is a small total function that says: when this event fires
in one subsystem, here is the constraint it imposes on another.

```python
def wire_light_to_ped(light_event, ped_state):
    """When the light turns green, force the pedestrian back to waiting."""
    if light_event == "red_to_green":
        return "waiting"
    return ped_state
```

That is one function, four lines, one branch. Notice what is *not* in
it:

- No reference to the pedestrian's transition table.
- No reference to the light's transition table.
- No reference to the random number generator.
- No reference to time, ticks, or simulation drivers.

The wiring is purely a typed cross-system rule.

---

## 7. Running again, with the wiring in place

The wired loop is the uncoupled loop with one extra line: after both
subsystems have stepped, apply the wiring.

```python
def run_wired(steps=12, fire_prob=0.7):
    light = "red"
    ped   = "waiting"
    print(f"{'t':>3}  {'light':<5}  {'ped':<8}  {'illegal?':<8}")
    for t in range(steps):
        light_event, light = maybe_fire(light, LIGHT_EVENTS, fire_prob)
        _,           ped   = maybe_fire(ped,   PED_EVENTS,   fire_prob)
        ped = wire_light_to_ped(light_event, ped)
        illegal = (light == "green" and ped == "crossing")
        flag    = "ILLEGAL" if illegal else ""
        print(f"{t:>3}  {light:<5}  {ped:<8}  {flag}")
```

Run it with the same seed:

```python
random.seed(7)
run_wired()
```

Output:

```
=== Wired (light_to_ped) ===
  t  light  ped       illegal?
  0  green  waiting
  1  red    crossing
  2  red    waiting
  3  green  waiting
  4  red    waiting
  5  green  waiting
  6  red    crossing
  7  green  waiting
  8  red    crossing
  9  green  waiting
 10  red    waiting
 11  green  waiting
```

No `ILLEGAL` rows. The four impossible-cell visits from before are
replaced by `green, waiting`.

> [!tip]
> The two simulations used the same seed, the same machines, and the
> same dynamics. The *only* difference is the wiring. Composition,
> here, literally means "one extra function."

---

## 8. What this scales to

This is a deliberately tiny example. The scaling story is what makes it
worth the abstraction.

### Adding a third subsystem

Suppose we add a `Car` subsystem with states `stopped | moving`. The
domain rule is: cars stop when the light is red, move when it's green.
We don't touch `LIGHT_EVENTS`, `PED_EVENTS`, or either wiring already
defined. We add:

```python
CAR_EVENTS = {
    "stopped": {"start_moving": "moving"},
    "moving":  {"stop":         "stopped"},
}

def wire_light_to_car(light_event, car_state):
    if light_event == "green_to_red":
        return "stopped"
    if light_event == "red_to_green":
        return "moving"
    return car_state
```

The simulation loop grows by exactly one `maybe_fire` call and one
wiring application per added subsystem. The existing code is untouched.

### Why this matters for the main book

This demo is the smallest, most concrete version of the architecture
that the rest of the book is built on:

- The transition tables are **polynomial coalgebras** (Module 1).
- `maybe_fire` is a discrete-time stand-in for the **rate kernel**
  (Module 4) that picks among competing exponential clocks.
- `wire_light_to_ped` is the kind of object you find in the
  **wirings / double categories** chapter (Module 7).
- The `ILLEGAL` flag is what you'd later replace with a typed schema
  that simply makes the bad cells unrepresentable.
- The seed-locked before/after is how you'd debug a calibration that
  is mysteriously over-counting joint cells: usually a missing wiring.

> [!summary]
> Two machines, one wiring, one before/after. That is system
> composition. Everything else in the main book is this same shape,
> with richer machinery in each slot.

---

## 9. The complete file

For convenience, here is the entire script in one block. Copy it into
`system_composition_demo.py` (or just run the copy already saved
alongside this document) and execute it with `python3
system_composition_demo.py`.

```python
"""A minimal compositional-system demonstration.

Two tiny state machines (a traffic light and a pedestrian) are first run
side by side without any coordination. That produces illegal joint states
(pedestrian crossing while the light is green). Then a single wiring is
added that forces the pedestrian back to 'waiting' whenever the light
turns green. The illegal states disappear.
"""

import random

random.seed(7)

# ----------------------------------------------------------------------
# STEP 1: each subsystem is just a transition table.
#   state -> { event_name -> next_state }
# ----------------------------------------------------------------------

LIGHT_EVENTS = {
    "green": {"green_to_red":  "red"},
    "red":   {"red_to_green":  "green"},
}

PED_EVENTS = {
    "waiting":  {"start_crossing":  "crossing"},
    "crossing": {"finish_crossing": "waiting"},
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

def run_uncoupled(steps=12, fire_prob=0.7):
    light = "red"
    ped   = "waiting"
    print(f"{'t':>3}  {'light':<5}  {'ped':<8}  {'illegal?':<8}")
    for t in range(steps):
        _, light = maybe_fire(light, LIGHT_EVENTS, fire_prob)
        _, ped   = maybe_fire(ped,   PED_EVENTS,   fire_prob)
        illegal  = (light == "green" and ped == "crossing")
        flag     = "ILLEGAL" if illegal else ""
        print(f"{t:>3}  {light:<5}  {ped:<8}  {flag}")

# ----------------------------------------------------------------------
# STEP 4: a wiring is a small rule about how one system's events
# constrain another system's state.
# ----------------------------------------------------------------------

def wire_light_to_ped(light_event, ped_state):
    """When the light turns green, force the pedestrian back to waiting."""
    if light_event == "red_to_green":
        return "waiting"
    return ped_state

# ----------------------------------------------------------------------
# STEP 5: run again, but this time apply the wiring each tick.
# ----------------------------------------------------------------------

def run_wired(steps=12, fire_prob=0.7):
    light = "red"
    ped   = "waiting"
    print(f"{'t':>3}  {'light':<5}  {'ped':<8}  {'illegal?':<8}")
    for t in range(steps):
        light_event, light = maybe_fire(light, LIGHT_EVENTS, fire_prob)
        _,           ped   = maybe_fire(ped,   PED_EVENTS,   fire_prob)
        ped = wire_light_to_ped(light_event, ped)
        illegal = (light == "green" and ped == "crossing")
        flag    = "ILLEGAL" if illegal else ""
        print(f"{t:>3}  {light:<5}  {ped:<8}  {flag}")

if __name__ == "__main__":
    print("=== Uncoupled (no wiring) ===")
    random.seed(7)
    run_uncoupled()
    print()
    print("=== Wired (light_to_ped) ===")
    random.seed(7)
    run_wired()
```

That's all of it. Two machines, one wiring, one before/after.
