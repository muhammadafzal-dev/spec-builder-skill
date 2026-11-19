# Category 8 — Integrations

Purpose: list every external system the product talks to, what flows, what happens on failure.

## Questions to ask

For each integration:

1. **What external system?** (name, vendor)
2. **Purpose?** (why we integrate)
3. **Direction of data flow?** (we push / we pull / bidirectional)
4. **What data crosses the boundary?** (fields, not whole entities if sensitive)
5. **Authentication method?** (API key, OAuth, service account, basic auth)
6. **Who owns the account / credentials?** (client / us / shared)
7. **Sync cadence?** (real-time, every N minutes, daily batch, on-demand)
8. **What happens if the external system is down?** (fail silently, retry, block user?)
9. **Rate limits to respect?** (requests/minute, bandwidth caps)
10. **Is the external system the source of truth?** (or are we)
11. **Audit trail of integration events?** (log each sync attempt?)
12. **Credential rotation plan?** (how often, by whom)
13. **Does the integration need its own feature flag?** (to enable/disable per environment)

## System-specific prompts

Common integrations and what to probe:

### Email / SMTP
- Transactional only, or marketing too?
- Who's the sender identity? (client domain or shared)
- Bounce / complaint handling?
- Templates in how many languages?

### Payment gateway
- Which provider?
- Who owns the merchant account?
- Refund policy?
- PCI compliance posture?
- Idempotency keys handled?

### SMS
- Which country regulators apply?
- Opt-out mechanism?
- Rate limits per recipient?

### Storage (S3 / Blob / etc.)
- Private / public access?
- Encryption at rest?
- Lifecycle rules (cold storage, deletion)?

### Analytics
- What events tracked?
- PII in events? (should be no)
- GDPR cookie consent flow?

### CRM / ERP
- Which system?
- Bidirectional fields or one-way?
- Conflict resolution (who wins on edit?)

### Export destinations (Sheets, CSV, FTP)
- Reporting-only or authoritative?
- Can users edit the destination? (if yes → risk)
- Sync cadence?

### Webhooks (outbound)
- Who consumes?
- Delivery guarantees? (at-least-once, at-most-once)
- Retry policy?
- Signature for verification?

### Webhooks (inbound)
- Who sends?
- IP whitelist or signature verification?
- Idempotency? (replay protection)

### Maps / Geocoding
- Which provider?
- Usage-based billing?
- Fallback if quota exceeded?

### AI / LLM
- Which provider?
- Data retention by provider?
- PII sent in prompts?
- Cost per call?

## What to extract

- One subsection per integration in Section 8
- Table summarizing all integrations (name, direction, failure behavior)

## Red flags

- "It just syncs" — no, probe the details
- No failure plan — what if the API is down?
- No rate limit awareness — will hit limits in production
- Credentials shared via email / Slack — document secure handoff
- Integration is critical but has no fallback — flag as risk
- Integration adds compliance scope (e.g. PCI, GDPR processor) — note in Section 10

## R&D / POC trigger

Mark `[R&D RECOMMENDED]` for integrations where:
- You've never used this API before
- Rate limits are unclear
- Auth model is unusual (mTLS, service accounts, OAuth with custom scopes)
- Billing model has unknown multipliers
- The integration is critical path (blocking core workflows)

For `[R&D RECOMMENDED]` integrations, add a POC entry in Section 15 or 20 (open decisions).

## Example output snippet

```markdown
## 8. Integrations

### 8.1 Google Sheets

- **Purpose:** Secondary reporting destination for completed + corrected shifts.
- **Direction:** One-way push from our DB.
- **Data crossed:** shift_id, worker name, project, site, timestamps, photo link,
  total hours, status, last updated.
- **Authentication:** Google Cloud service account (JSON key). Credentials stored
  as server-only secret.
- **Owner:** Client owns Google workspace + target spreadsheet; shares sheet
  with service account email.
- **Sync cadence:** Asynchronous — every minute via scheduled job, drains an
  `export_jobs` outbox.
- **Failure behavior:** Attendance continues to be captured and stored in DB.
  Failed exports are retried with exponential backoff. Admin UI shows failed
  export count + retry button. Sheet unavailable NEVER blocks attendance.
- **Rate limits:** Google Sheets API — 60 writes/minute/user. Worker batches and
  backs off on 429.
- **Source of truth:** DB. Manual edits to the Sheet do NOT propagate back.
- **Audit:** Each export attempt logged with attempt count, last error.

### 8.2 Email (transactional)

- **Purpose:** Invitation emails, password resets.
- **Direction:** Outbound only.
- **Provider:** [to be decided — see Section 16 open decisions]
- **Authentication:** API key (Postmark / Resend) or SMTP credentials (SendGrid).
- **Templates:** HTML + text, EN + NL versions. Managed in the auth provider's
  template system.
- **Failure behavior:** Invitation / reset request succeeds in DB regardless of
  email delivery. User sees generic success message (anti-enumeration). Failed
  deliveries logged.
```

## Summary table (always include)

```markdown
| Integration | Direction | Critical? | Failure behavior | Source of truth |
|---|---|---|---|---|
| Google Sheets | Outbound | No | Retry queue | Us |
| Email | Outbound | Yes for onboarding | Log + user retry | N/A |
| [Other] | | | | |
```
