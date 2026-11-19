# Category 6 — State Machines

Purpose: for anything with a lifecycle (invitation, shift, order, review), explicitly define states + allowed transitions.

## When to add a state machine

Add one for every entity that has:
- A `status` field with multiple values
- A workflow that moves through stages
- Approval / review gates
- Lifecycle events (created → active → archived)

## Questions to ask

1. **What are the possible states?** (list them as an enum)
2. **What's the initial state?** (when created)
3. **For each state, what actions are allowed?** (and by which role?)
4. **What are the terminal states?** (nothing after them)
5. **Which transitions are allowed?** (draw arrows)
6. **Which transitions are forbidden?** (must reject)
7. **What triggers each transition?** (user action, system event, scheduled)
8. **Does any transition require audit?** (log who/when/why)
9. **Can transitions be reversed?** (ACCEPTED → PENDING? usually no)
10. **Are there time-based transitions?** (PENDING → EXPIRED after N days)
11. **Can transitions happen offline?** (and what happens on reconciliation)

## What to extract

- One subsection per stateful entity in Section 6
- State diagram (ASCII arrows)
- Allowed transitions table
- Forbidden transitions table (with expected behavior on attempt)
- Trigger notes
- Audit requirements

## Writing style

- **Enum values uppercase.** `PENDING`, `ACCEPTED`, not `pending`.
- **Transitions arrow notation.** `PENDING → ACCEPTED`
- **Triggers on arrows.** `PENDING → ACCEPTED (worker accepts invite)`

## Red flags

- State machine missing for an entity with a `status` field
- Transitions diagram with cycles that shouldn't cycle (revive deleted?)
- Forbidden transitions not listed — they will happen; spec what happens
- Time-based transitions without a mechanism (who decides when PENDING becomes EXPIRED?)

## Example output snippet

```markdown
## 6. State machines

### 6.1 Invitation

```
PENDING ──→ ACCEPTED       (worker completes registration)
    │
    ├──→ EXPIRED           (automatic after expires_at)
    │
    └──→ REVOKED           (admin action)
```

| From | To | Trigger | Audit required? |
|---|---|---|---|
| (none) | PENDING | Admin creates invitation | Yes |
| PENDING | ACCEPTED | Worker completes registration | Yes |
| PENDING | EXPIRED | Scheduled job, when now > expires_at | No (bulk) |
| PENDING | REVOKED | Admin action | Yes |

**Forbidden transitions:**
- ACCEPTED → anything (terminal)
- EXPIRED → anything (terminal, create new invite)
- REVOKED → anything (terminal, create new invite)

### 6.2 Shift

```
                ┌──→ COMPLETED
OPEN  ──────────┤
                └──→ REQUIRES_REVIEW
```

| From | To | Trigger | Audit |
|---|---|---|---|
| (none) | OPEN | Worker check-in | Yes |
| OPEN | COMPLETED | Worker check-out | Yes |
| OPEN | REQUIRES_REVIEW | Server validation flag (unassigned site, suspicious data) | Yes |
| REQUIRES_REVIEW | COMPLETED | Admin correction with reason | Yes (correction) |

**Constraint:** at most one OPEN shift per worker across all sites. Enforced at database level with partial unique index.
```
