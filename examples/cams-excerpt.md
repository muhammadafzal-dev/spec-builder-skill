# Example — CAMS (Construction Attendance Management System)

Excerpt from a real-world spec produced using this skill. Shows quality bar + style.

This excerpt is partial — the real CAMS spec is ~87 KB covering all 17 sections.

---

## Header

```
# Construction Site Attendance Management System

**Software Requirements Specification (SRS)**
**Version:** 1.6
**Status:** Consolidated functional + technical implementation specification
**Platforms:** Offline-first Worker Progressive Web App (PWA), responsive Web Admin Portal
**Languages at launch:** English (en) and Dutch (nl)
```

## Section 1 — Overview

> Build an easy-to-use attendance system for construction workers and
> subcontractors who record arrival/departure at assigned construction sites.
> Each event requires a newly captured photograph. The worker PWA must operate
> offline after initial setup, preserve locally captured timestamps and photos,
> and synchronize pending records when connectivity returns and the app is
> available. Administrators manage employees, secure invitations, projects,
> sites, assignments, attendance, corrections, reporting, and Google Sheets
> integration.

**Note the quality:** business problem first, user context, big constraints
up front (offline-first, photos required, Google Sheets destination).

## Section 2 — Roles matrix

| Capability | Admin | Worker |
|---|---|---|
| Invite/revoke employees | Yes | No |
| Manage employees and names | Yes | No |
| Manage projects/sites | Yes | No |
| Assign workers to sites | Yes | No |
| View all attendance/photos | Yes | No |
| View own attendance | Yes | Yes |
| Check in/out at assigned sites | No by default | Yes |
| Correct attendance with audit reason | Yes | No |
| View statistics and exports | Yes | No |
| Switch language | Yes | Yes |

Plus authority model statement:

> Enforce permissions in the backend on every endpoint. Frontend filtering
> is not a security boundary. Workers cannot edit their official name, event
> timestamps, or photos. Administrators can correct a name and attendance
> values, but such changes must be audited.

## Section 3 — Core principles (non-negotiables)

> - Worker interface must prioritize large buttons, clear icons, minimal text,
>   and a short check-in/out flow.
> - Employees only see sites explicitly assigned by an administrator.
> - Every attendance event and photo is first saved together locally; server
>   sync is separate.
> - The backend database is the system of record; Google Sheets is a secondary
>   reporting destination.
> - All user-facing application strings are localized using translation keys.
> - Do not promise guaranteed background sync when the PWA is closed, or
>   tamper-proof camera provenance in a browser.

Note: each principle is a short, enforceable statement.

## Section 4 — Example FR

```markdown
### FR-010 — Check-in

1. Select authorized site; tap large **Check In** button.
2. Open live camera preview, preferably rear camera.
3. Capture a **new** photograph, preview it, allow retake, and confirm.
4. Generate client UUIDs for shift_id and event_id, capture device UTC time
   and timezone offset.
5. Atomically persist event metadata and photo Blob to IndexedDB.
6. Display "Saved on this device" only after local write succeeds; show
   separate sync state.
7. Sync automatically if connected and running.

Required event metadata: event ID, shift ID, authenticated worker ID
(server-derived), name snapshot, project/site IDs, CHECK_IN, original
captured timestamp, timezone offset, photo reference, sync state. No
worker-editable fields for name/timestamps. Block duplicate tap submissions
and a second active shift.
```

Observations:
- Numbered steps
- Explicit field list
- Trust boundary noted ("server-derived")
- Edge cases referenced ("block duplicate", "block second active shift")

## Section 16 — Edge cases table

| Condition | Required behavior |
|---|---|
| Worker has no assigned sites | Show empty state, no check-in |
| Worker tries unassigned site | Deny on server; offline conflict flagged |
| Camera permission denied | Explain how to grant access, block event |
| Photo not saved / quota exceeded | Show failure; do **not** claim check-in succeeded |
| Rapid repeated tap | One event only |
| Sync succeeds but response lost | Retry same UUID, server returns existing result |
| Photo uploaded, event fails | Reuse/cleanup photo safely; preserve local queue |
| App restarted while offline | Restore committed pending events |
| Worker attempts second check-in | Block until checkout/correction |
| Missing checkout | Shift remains OPEN, admin may correct with audit |
| Site/employee deactivated while offline | Server review/reject based on policy |
| Offline device clock incorrect | Preserve reported time, flag suspicious data |
| Google Sheets unavailable | Attendance persists; export retries independently |
| Logout with unsynced data | Warn; never silently erase pending evidence |
| Device/browser data cleared | Explain unavoidable risk of unsynced data loss |
| Overnight shift | Calculate using full timestamps |
| Network returns while PWA closed | No guaranteed upload until app reopens |

17 entries. Each specific + testable.

## Section 19 — Out of scope

> Separate native Android/iOS applications; payroll, wage/shift premiums,
> overtime, breaks or invoicing; Mandatory GPS/geofencing enforcement; face
> recognition or biometric identity; QR attendance; advanced staff scheduling;
> guarantees of closed-app background sync or tamper-proof photos; guarantees
> against device loss/browser eviction of unsynced data.

Explicit and unambiguous.

## Section 20 — Open decisions (sample)

> 1. Should registration require individual employee email accounts, or will
>    phone-based sign-in be needed? (Default: invited email/password.)
> 2. What must each photo show: the construction site, the worker, or both?
>    (Default: site.)
> 3. What are the business timezone and photo/attendance retention policy?
> 4. Which administrators can approve attendance corrections?
> 5. Should shift totals exclude breaks or support distinct break events later?
>    (Excluded from current scope.)
> 6. Who will own Google Sheets, infrastructure accounts, and photo storage?
>    (Default: client.)

Pattern: question + default + (sometimes) impact.

## Section 21 — PoC-validated constraints (added in v1.5)

CAMS went through a validated PoC. The spec includes explicit sections for:
- 21.1 — What is proven vs what must be proven again (table)
- 21.3 — Canonical sync protocol (exact retry semantics)
- 21.5 — GPS as optional feature with allow-and-flag
- 21.8 — 10-step mandatory real-device release gate
- 21.9 — P0/P1 risk register

Template for POC in spec:

```markdown
### POC-01 — iOS installed PWA offline storage of photo blobs

**Question:** Can iOS Safari store photo Blobs in IndexedDB reliably after
force-close + reopen?

**Finding:** NO. Blob storage failed. Workaround: convert to ArrayBuffer
before Dexie transaction.

**Status:** Resolved. Non-negotiable pattern added to code architecture rules.
```

---

## Key takeaways from CAMS spec

1. **Section 3 principles** prevented debates: "frontend filtering is not a security boundary" settled every "can we just..." conversation.
2. **Role × capability matrix** caught 2 permission bugs in review before any code was written.
3. **Explicit edge cases table** (17+ entries) reduced production bug rate significantly.
4. **Open decisions list** (section 20) surfaced 6 client decisions that would have blocked dev if discovered late.
5. **POC section (21)** validated iOS behavior BEFORE commit — found a Blob-storage failure that would have been a show-stopper if discovered after full build.
6. **Out-of-scope section** prevented 3 scope-creep conversations about native apps, GPS enforcement, and payroll.

Use this pattern.
