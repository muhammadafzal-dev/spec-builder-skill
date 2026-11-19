# Category 4 — Workflows & Features → Functional Requirements

Purpose: extract every feature as a numbered, testable FR. This is the heart of the spec.

## Interview strategy

### Step 1 — List every workflow
"Walk me through a day in the life of each user. Start to finish."

Capture each distinct workflow as a heading. Examples:
- Onboarding (invitation + registration)
- Authentication (login, logout, reset)
- Core action (the main thing users do)
- Data management (CRUD on entities)
- Reports / exports
- Settings / configuration
- Corrections / admin overrides

### Step 2 — For each workflow, extract FRs

For each step in the workflow, ask:
1. **Who performs this?** (actor / role)
2. **What triggers it?** (button tap, scheduled, system event)
3. **What are the preconditions?** (what must be true to start)
4. **What are the steps?** (sequence of interactions)
5. **What data is captured?** (field list)
6. **What validation rules apply?** (what must be true)
7. **What's the success outcome?** (end state)
8. **What can go wrong?** (branch to edge cases)
9. **What's the acceptance condition?** (pass/fail test)

### Step 3 — Number sequentially

`FR-001`, `FR-002`, ... Grouped by workflow but numbered globally.

### Step 4 — Prioritize

Ask: "If we had to cut half the features, which would be in v1?" — surface MUST vs NICE-TO-HAVE.

Tag each FR:
- `[MUST]` — v1 blocker
- `[SHOULD]` — v1 if time
- `[COULD]` — v2 candidate

## What to probe for each workflow

- **Alternative paths:** happy path first, then variants
- **Error paths:** what if the action fails mid-way?
- **Concurrency:** what if two users do this simultaneously?
- **Interruption:** what if the user closes the app mid-action?
- **Identity:** who does the system attribute this to? (actor)
- **Immutability:** can this be edited later? by whom? audited?
- **Idempotency:** safe to retry? same result?

## Writing style for FRs

- **Actor + verb + object.** "The worker captures a photograph."
- **Numbered steps.** 1, 2, 3.
- **Explicit preconditions.** "Worker must have at least one assigned site."
- **Explicit data fields.** Not "some metadata" — list every field.
- **Testable acceptance.** "Worker can complete flow in under 10s" is testable. "Worker is satisfied" is not.

## Red flags to probe

- Vague FRs ("system handles X") → rewrite with specific actor + action
- FRs without actors → every FR has an actor
- FRs without acceptance → not testable = not done
- Features without edge cases → push harder
- "The system should be smart about..." → never. Spec explicit behavior.

## R&D / POC triggers

Mark an FR with `[R&D REQUIRED]` if any of these are true:
- Involves a platform capability that may not work as expected (iOS PWA background, native camera authenticity, OS-level APIs)
- Depends on a third-party API with uncertain limits or auth model
- Requires performance you can't guarantee without testing (large file upload, real-time)
- Novel UX pattern the team hasn't shipped before
- Hardware integration (printer, scanner, biometric)
- Offline + sync at scale with conflict resolution

For `[R&D REQUIRED]` items, note in Section 15 (POC scope) — see `questions/11-scope-boundaries.md`.

## Example output snippet

```markdown
### FR-010 — Check-in [MUST]

**Actor:** Worker (role=WORKER, status=ACTIVE)
**Precondition:** Worker has at least one active site assignment.
**Trigger:** Worker taps "Check In" on dashboard.
**Steps:**
1. Worker selects an authorized site from their assignment list
2. Worker taps the Check In button (large touch target)
3. System opens live camera preview (rear-facing preferred)
4. Worker captures a photograph
5. System shows preview with Retake / Confirm options
6. Worker confirms
7. System captures device UTC time + timezone + optional GPS snapshot at shutter
8. System atomically persists event metadata + photo + shift to local storage
9. System displays "Saved on this device" after local write succeeds
10. System triggers sync if connected

**Data captured:** event_id, shift_id, site_id, worker_id, event_type=CHECK_IN,
photo_captured_at, device_captured_at, timezone_offset, photo reference, optional
GPS, sync_state=PENDING.

**Validation:**
- Site must be in active assignments
- No existing OPEN shift for this worker
- Photo must be captured + compressed + saved
- Device timestamp cannot be >24h in future

**Acceptance:**
- [ ] Flow completes in under 10s on tested devices
- [ ] Transaction is atomic on local save
- [ ] Second check-in while OPEN is rejected with localized error
- [ ] Captured timestamp preserved separately from server-received time
```
