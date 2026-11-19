# Category 10 — Edge Cases

Purpose: document failure modes, invalid states, concurrency hazards, and what the system does in each. **The more edge cases documented, the fewer bugs in production.**

## Systematic prompts (use ALL of these)

For every workflow, walk through these categories:

### Boundaries
- What if the input is empty?
- What if it's at the min / max allowed?
- What about zero / negative / very large values?
- What if it's one character / 10,000 characters?

### Nulls and absence
- What if an optional field is missing?
- What if a required dependency is absent? (worker has no sites)
- What if a reference points to a deleted entity?
- What if a user has no history?

### Timing
- What if the action is slow? (progress indicator)
- What if the action times out? (retry? cancel?)
- What if two users do this at the same time?
- What if the user double-taps?
- What if the clock is wrong?
- What if time crosses a timezone boundary?
- What if it's overnight (crosses midnight)?

### Connectivity
- What if offline?
- What if connection drops mid-action?
- What if offline for hours / days?
- What if connection returns while the app is closed?
- What if the connection is slow (not down)?

### Device / browser
- What if storage quota is exceeded?
- What if camera permission denied?
- What if GPS permission denied / timeout?
- What if the device is low on battery?
- What if the browser clears storage?
- What if the user uninstalls / reinstalls the PWA?
- What if two tabs open simultaneously?

### Permissions
- What if the user's role changes mid-session?
- What if assignments are revoked while offline?
- What if the user is deactivated?
- What if the user logs in from a new device?
- What if the user logs in while another session is active elsewhere?

### State
- What if the action is attempted in the wrong state? (checkout without check-in)
- What if an invalid transition is attempted?
- What if a terminal state is attempted to be exited?
- What if an operation is retried on a success? (idempotency)
- What if an operation is retried on a failure? (idempotency)

### Input validation
- What if the input is malformed?
- What if it contains dangerous chars (SQL, HTML, scripts)?
- What if unicode / emoji?
- What if the file type is wrong? (photo upload accepts non-images)
- What if the file is corrupted?

### Dependencies
- What if an external API is down?
- What if a response is lost? (we sent, didn't get reply)
- What if the API returns unexpected format?
- What if the API is rate-limited?
- What if credentials expire?

### Concurrency
- What if two admins edit the same record?
- What if a worker checks in twice from two devices?
- What if a correction happens during a sync?
- What if two sync processes run in parallel?

### Session
- What if the session expires mid-workflow?
- What if the user logs out with unsaved work?
- What if the browser crashes mid-action?

### Data integrity
- What if saved data is corrupt on next load?
- What if a transaction partially commits?
- What if a photo uploads but the event fails to commit? (orphan)
- What if an event commits but the response is lost? (replay)

## Writing style for edge cases

Table format. Columns: **Condition** | **Expected behavior**.

Required behavior must be:
- **Specific.** "Reject" or "silently queue" — not "handle gracefully".
- **Testable.** A test can prove the behavior.
- **User-visible OR user-invisible.** State which.

## Red flags

- Edge case table with < 10 entries → not thorough enough
- "The system handles X appropriately" → rewrite with specific behavior
- Edge cases documented but no acceptance tests → add tests
- No concurrency edge cases → there WILL be concurrency bugs

## Example output snippet

```markdown
## 12. Edge cases and expected handling

| Condition | Required behavior |
|---|---|
| Worker has no assigned sites | Show localized empty state; no check-in allowed |
| Worker tries to check in at unassigned site | Server denies 403; local event flagged REQUIRES_REVIEW if captured offline |
| Camera permission denied | Explain how to grant access; block event (no silent gallery fallback) |
| GPS permission denied | Continue with location_status=DENIED; attendance still valid |
| Photo not saved locally (quota exceeded) | Show failure; do NOT claim check-in succeeded |
| Rapid repeated tap on Check In | One event only (idempotent via client-generated UUID) |
| Sync succeeds but response lost | Retry with same event_id; server returns existing result (200 duplicate) |
| Photo uploaded but event commit fails | Retry event with same photo_id; orphan photo cleaned up after 24h |
| App restarted while offline | Restore committed pending events from IndexedDB on next open |
| Worker attempts second check-in while OPEN | Block locally AND server-side (DB unique constraint); localized error |
| Missing checkout (worker forgot to check out) | Shift remains OPEN; admin corrects with reason + audit |
| Site deactivated while worker offline | On sync, mark event REQUIRES_REVIEW; admin decides accept/reject |
| Worker deactivated while offline | Same — queued events marked REQUIRES_REVIEW on sync |
| Device clock set incorrectly | Preserve reported time; server flags if drift > 24h |
| Google Sheets unavailable | Attendance persists; export retries independently |
| Logout with unsynced data | Warn user; never silently erase evidence |
| Device/browser data cleared | Explain unavoidable risk during onboarding and before logout |
| Overnight shift | Calculate duration using full UTC timestamps |
| Network returns while PWA closed | No guaranteed upload until app reopens |
| Second worker logs in on shared device | Separate caches by user ID; never show Worker A's data to Worker B |
| Two admins correct same shift simultaneously | Last write wins; both corrections logged in audit trail |
| Photo upload > 5 MB | Reject with 400 at upload-intent |
| Photo MIME type not image/jpeg or image/webp | Reject at upload-intent |
```

## Minimum thresholds

For a spec to be considered "edge-case complete":
- At least 15 entries in the table
- Covers: boundaries, nulls, timing, connectivity, permissions, state, concurrency, device
- At least 3 entries specific to this product's riskiest workflow
- At least 1 entry per integration (what if X is down)
