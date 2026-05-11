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
