# Category 7 — Business Rules & Calculations

Purpose: explicit formulas, thresholds, and calculations. Not implementation — just the math and policy.

## Questions to ask

1. **Any computed fields?** (duration, total, average, status derived)
2. **Any formulas?** (write them out — avoid "obvious")
3. **Any thresholds or limits?** (max file size, min password length, max items per page)
4. **Any time-based rules?** (overnight shifts, business hours, retention)
5. **Any rounding conventions?** (minutes rounded up/down, currency to 2 decimals)
6. **Any ordering rules?** (newest first, status priority, alphabetical)
7. **Any validation beyond field types?** (email format, phone format, dates in future)
8. **Any inclusion/exclusion rules?** (open shifts excluded from hour totals)
9. **Any thresholds for alerts/flags?** (clock drift > 1h → flag, duration > 16h → review)
10. **Any policy choices disguised as technical decisions?** (how many retry attempts = policy, not code)

## What to extract

- One sub-section per rule in Section 7 (Business Rules)
- Include formula + example
- State the policy choice explicitly, even if "obvious"

## Writing style

- **State the formula.** `duration_minutes = effective_checkout_at - effective_checkin_at` not "calculate duration".
- **Give an example.** `Example: check-in 22:00, check-out 06:00 next day → duration = 8h.`
- **Name the edge.** `For overnight shifts, use full timestamps (not just time-of-day).`
- **State the exclusion.** `Open shifts excluded from hour totals until resolved.`

## Red flags

- Rules not written down — they'll be inconsistent across code
- Rules assumed to be "obvious" (rounding, timezone) — never assume
- Rules deferred to implementation ("the dev will decide") — that's a policy decision
- Formula without example → unclear

## Example output snippet

```markdown
## 7. Business rules

### 7.1 Shift duration

```
duration_minutes = effective_checkout_at - effective_checkin_at
```

Calculated with full UTC timestamps (not time-of-day), so overnight shifts work:
- Example: check-in 22:00 Monday, check-out 06:00 Tuesday → duration = 480 minutes (8h).

Open shifts have null duration until completed.

### 7.2 Hour totals

Totals per worker/project/site exclude OPEN shifts. Report shows:
- `total_minutes` — sum of completed shifts in range
- `incomplete_count` — count of OPEN shifts in range (reported separately)

### 7.3 Photo size target

Compressed JPEG, long edge ≤ 1280 px, quality ~0.85. Target 150-400 KB.
Hard limit 5 MB — reject larger uploads at `/media/upload-intent`.

### 7.4 Timestamp sanity flags

Flag event for admin review (not reject) when:
- `device_captured_at` more than 24h in the future
- `|device_captured_at - server_received_at| > 7 days` (offline too long)
- `photo_captured_at > device_captured_at` (shutter after confirmation — impossible)

### 7.5 Invitation expiry

Default: 7 days (configurable per deployment). After expiry, `PENDING` invitations
are auto-marked `EXPIRED` by a scheduled job. Admin can re-issue to same email.
```

## What NOT to include here

- ❌ Specific retry counts for server failures (that's implementation)
- ❌ Caching durations (that's implementation)
- ❌ Database query plans
- ❌ UI formatting (currency symbols, date display format go in UI principles or localization)

## Judgment call

Some things sit on the business/implementation border:
- "Session timeout" — business rule (security policy) OR implementation detail?
  - If the client has a security policy that mandates it — business rule
  - If the dev team is free to pick — implementation detail
- "Max concurrent users" — non-functional requirement, not business rule
- "Rate limits" — mostly implementation, but if client has policy ("prevent abuse from a single IP") note here

When in doubt: if it's a policy the client has an opinion about, it's a business rule. If it's a technical default the dev picks, skip it.
