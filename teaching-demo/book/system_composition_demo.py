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
