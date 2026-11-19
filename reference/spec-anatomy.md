# Spec Anatomy — Reference Guide

Full reference the AI reads before conducting a spec interview. Covers principles, structure, writing rules, and quality gates.

---

## Core principle

```
Spec says WHAT the system does, not HOW it's built.
```

If the spec can't be used to rebuild the product in a different tech stack, it has tech-stack leakage.

## Why specs matter

- **Permanent knowledge** — code is replaceable, specs are not
- **Independent testability** — every requirement should have an acceptance condition
- **Scope control** — explicit out-of-scope prevents scope creep
- **Onboarding** — new devs can build from spec alone
- **Audit** — regulators and auditors read specs, not code

---

## Standard sections (in order)

### 1. Header / Metadata
Product name, version, status, date, platforms, languages, one-line pitch.

### 2. Overview
2-3 paragraphs. Business problem + users + big constraints.

### 3. System Modules
High-level breakdown. Each module = one paragraph.

### 4. Roles & Permissions
Role matrix table + authority model description.

### 5. Core Principles
Non-negotiables that shape every decision.

### 6. Functional Requirements (FRs)
Numbered. Grouped by workflow. Each testable.

### 7. Entity / Data Model
What things exist, their fields, relationships. Stack-agnostic.

### 8. State Machines
For anything with a lifecycle.

### 9. Business Rules
Formulas, thresholds, calculations.

### 10. Integrations
External systems.

### 11. Multilingual
Languages, fallback, what gets translated.

### 12. Security & Privacy
Auth, authz, compliance, retention, audit.

### 13. Non-Functional Requirements
Performance, availability, scale targets.

### 14. Edge Cases
Table of conditions + expected behavior.

### 15. Acceptance Tests
Per-feature pass/fail checklist.

### 16. Definition of Done
Top-level release criteria.

### 17. Out of Scope
Explicit exclusions.

### 18. Open Decisions
Questions + default assumptions.

### 19. Glossary
Domain terms.

### 20. (Optional) Technical Recommendations
High-level stack suggestion if client wants it. No code.

---

## Writing style rules

1. **Short sentences.** Spec gets read under pressure.
2. **Imperative mood.** "The system must..." not "it would be nice if..."
3. **Numbered requirements.** `FR-001`, never reused, never renumbered.
4. **Tables for comparison.** Role matrix, state transitions, edge cases.
5. **Examples for ambiguity.** "Overnight shift example: 22:00 check-in, 06:00 checkout = 8h."
6. **No pronouns without antecedent.** Repeat the noun.
7. **Consistent terms.** Pick one — stick with it. Define in glossary.
8. **Mark assumptions.** `[OPEN DECISION — default: X]`.
9. **No stack leakage.** Never write "Postgres" or "React" in business sections.
10. **Testable verbs.** "Validates" / "rejects" / "displays" — not "handles" / "manages".

---

## Anti-patterns (reject these)

- ❌ Implementation details in FRs ("call Supabase API", "use JWT")
- ❌ Visual mockups mixed with behavior rules (link to Figma separately)
- ❌ Vague verbs ("system handles errors appropriately")
- ❌ FRs without acceptance criteria
- ❌ No edge cases — they'll surface in production
- ❌ No versioning — nobody knows which is current
- ❌ Features described from system perspective instead of actor perspective

---

## Quality gates (before marking "baseline")

Run through these before declaring the spec done:

- [ ] Every FR has a number + testable acceptance criteria
- [ ] Role matrix table present with every capability
- [ ] Entity model stack-agnostic (no SQL types, no framework names)
- [ ] State machines drawn for anything with lifecycle
- [ ] Edge cases table has 10+ entries
- [ ] Out-of-scope list is explicit and not empty
- [ ] Open decisions tracked with defaults
- [ ] Glossary added if domain-specific terms exist
- [ ] Non-functional targets quantified (not just "fast")
- [ ] Security section covers auth + authz + retention + audit
- [ ] Could a new dev build it from this spec alone? YES
- [ ] Could I rebuild in a different stack from this spec alone? YES

---

## How to interview

### Open with scope
- "What's the one-line pitch?"
- "Who uses it?"
- "What exists today that this replaces?"
- "What's the single most important thing it must do?"

### Walk the workflow
Pick the most important user and walk through their day using the product start to finish. Each step becomes an FR.

### Push on edge cases
- "What happens if the user is offline?"
- "What if they close the app mid-action?"
- "What if two people do this at the same time?"
- "What if the connection drops?"
- "What if the input is invalid?"
- "What if permissions change while they're using it?"

### Push on scope
- "Is this in scope for v1?"
- "What's explicitly out of scope?"
- "What might be added in v2?"

### Push on data
- "What fields must this capture?"
- "Which are required vs optional?"
- "Who owns the data?"
- "How long must it be kept?"
- "Can it be deleted? Modified? Audited?"

### Push on integrations
- "What systems does this talk to?"
- "What happens if that system is down?"
- "How often does data sync?"
- "What's the authoritative source?"

### Close with opens
- "What do we still not know?"
- "Who decides that?"
- "By when?"

---

## Example — well-formed FR

```markdown
### FR-012 — Worker check-in with photograph

**Actor:** Worker (role=WORKER, status=ACTIVE)
**Precondition:** Worker is assigned to at least one active site.
**Steps:**
1. Worker selects an authorized site from their assigned list
2. Worker taps the "Check In" button
3. System opens live camera (rear-facing preferred)
4. Worker captures a photograph
5. System shows preview with "Retake" and "Confirm" options
6. Worker confirms
7. System captures device time + timezone + GPS snapshot (if enabled)
8. System atomically saves event + photo locally
9. System displays "Saved on this device — pending sync"
10. System attempts server upload if online

**Data captured:**
- event_id (UUID, client-generated)
- shift_id (UUID, client-generated)
- site_id (reference)
- worker_id (derived from session)
- event_type: CHECK_IN
- photo_captured_at (ISO UTC)
- device_captured_at (ISO UTC)
- timezone_offset_minutes
- photo reference
- optional GPS: location_status + lat/lng/accuracy/fix_at
- sync_state: PENDING

**Validation:**
- Site must be in worker's active assignments
- No existing OPEN shift for this worker
- Photo must be successfully captured + compressed + saved
- Device timestamp cannot be more than 24h in the future

**Acceptance:**
- [ ] Worker can complete flow in under 10 seconds end to end
- [ ] Transaction is atomic — no partial state on failure
- [ ] Worker sees local save confirmation before any server attempt
- [ ] Attempting a second check-in while OPEN is rejected with localized error
- [ ] Captured timestamp is preserved separately from server-received time
```

---

## Example — well-formed role matrix

```markdown
| Capability | Admin | Worker | Guest |
|---|---|---|---|
| Invite/revoke employees | Yes | No | No |
| Manage projects/sites | Yes | No | No |
| View all attendance | Yes | No | No |
| View own attendance | Yes | Yes | No |
| Check in at assigned site | No | Yes | No |
| Correct attendance (audited) | Yes | No | No |
| Switch language | Yes | Yes | Yes |
```

Every capability has a clear yes/no for every role. No gaps, no ambiguity.

---

## Example — well-formed edge case table

```markdown
| Condition | Required behavior |
|---|---|
| Worker has no assigned sites | Show empty state, no check-in |
| Worker tries unassigned site | Server denies; offline conflict flagged |
| Camera permission denied | Explain how to grant access, block event |
| Photo not saved / quota exceeded | Show failure; do NOT claim check-in succeeded |
| Rapid repeated tap | One event only (idempotent) |
| Sync succeeds but response lost | Retry same UUID; server returns existing result |
| App restarted while offline | Restore committed pending events |
| Device/browser data cleared | Explain unavoidable risk; warn before logout with pending data |
| Clock manipulated backward | Preserve reported time, flag for review |
| Network returns while PWA closed | No guaranteed upload until app reopens |
```

Specific. Testable. Covers failures, not just happy paths.

---

## When to add Section 18 (Technical Recommendations)

- Client has no in-house tech team
- Client specifically requests tech advice
- Spec being used as a proposal to prospective vendors

**Keep it high level.** No specific libraries, no versions. Rationale only. The implementation team writes the detailed tech spec separately.

If the client already has a tech preference — document it as a constraint in Section 1 (overview), not in Section 18.
