# Category 12 — Open Decisions

Purpose: capture everything the product owner / client still needs to decide, with a sensible default so implementation isn't blocked.

## When to flag an open decision

Flag during any earlier category when:
- Client says "I'll decide later" or "whatever you think"
- You asked a direct question and got an ambiguous answer
- Multiple reasonable options exist and the choice is policy, not technical
- A decision has compliance / legal implications and the client hasn't consulted
- A decision has cost implications the client should weigh
- A decision affects the user experience in a way only the client should own

## Writing style for open decisions

```markdown
1. **[Question]** (Default: [assumption])
```

Each entry has:
- **Question** — specific, answerable yes/no or short answer
- **Default** — what we'll do until the client decides otherwise
- **(Optional) Deadline** — when a decision must be made to avoid blocking
- **(Optional) Owner** — who the client-side decision maker is
- **(Optional) Impact** — what changes based on the answer

## Common open decisions by category

### Onboarding
- Email vs phone registration?
- Who sends invitation emails (we / client / managed service)?
- Invitation expiry duration?
- Password policy strictness?

### Data
- Retention period for each data type?
- Deletion policy (soft / hard / anonymize)?
- Backup strategy ownership?
- Data residency requirement?
- Can admins delete their own actions? (bad idea usually)

### UX
- What must each photo show? (worker / site / both)
- Which language is default?
- Timezone displayed? (business / user / mixed)
- Date format? (DD/MM/YYYY vs MM/DD/YYYY vs ISO)

### Business rules
- Rounding conventions for hours?
- Breaks counted or excluded?
- Overtime calculation (if in scope)?
- Minimum shift duration?
- Concurrent shifts across sites (allowed / blocked)?

### Integrations
- Who owns the Google Sheets / destination accounts?
- Who owns SMTP / email provider account?
- Who provides OAuth credentials?

### Security
- 2FA for admins (required / optional)?
- Session timeout per role?
- Audit log retention?
- Incident response contact?

### Compliance (jurisdiction-specific)
- GDPR lawful basis — legitimate interest or consent?
- Works council consultation completed? (EU workplace monitoring)
- Data Processing Agreement in place?
- Privacy notice published?

### Operations
- Who's on call for production incidents?
- Escalation path?
- Deployment approval process?
- Change management for admin role assignments?

## Red flags

- No open decisions documented → unrealistic; every project has unknowns
- Open decisions with no default → blocks implementation
- Open decisions with no owner → nobody decides → stays open forever
- Open decisions that are actually in-scope features in disguise

## Example output snippet

```markdown
## 16. Open decisions for product owner

Resolve before v1.0 baseline. Default assumptions applied until each item is closed.

1. **Registration method** (Default: invited email + password)
   - Alternative: phone-based sign-in
   - Owner: Client product owner
   - Impact: changes auth flow + invitation template

2. **Photo content requirement** (Default: show the construction site)
   - Alternative: worker selfie, or both
   - Owner: Client + legal (workplace monitoring consultation)
   - Impact: changes worker guidance + UI copy + privacy notice

3. **Business timezone** (Default: Europe/Amsterdam)
   - Owner: Client ops
   - Impact: affects all displayed times + shift date assignment

4. **Photo retention period** (Default: 730 days / 2 years)
   - Owner: Client legal + privacy officer
   - Impact: affects storage cost + GDPR retention compliance

5. **Who approves attendance corrections** (Default: any ADMIN role)
   - Alternative: dedicated "SUPERVISOR" sub-role with separate audit stream
   - Owner: Client ops lead
   - Impact: adds a role if sub-role chosen

6. **Breaks policy** (Default: excluded from v1 — shifts are continuous)
   - Alternative: support break events in v1.1
   - Owner: Client ops + payroll
   - Impact: data model change if breaks added later

7. **Google Sheets + infrastructure ownership** (Default: client owns all accounts)
   - Alternative: we host under our account initially
   - Owner: Client IT
   - Impact: handoff / offboarding complexity
```

## Rule for finalizing spec

**Spec can be baselined as v1.0 if:**
- All open decisions have defaults applied
- No open decision blocks a MUST-have workflow

**Spec must NOT be baselined if:**
- An open decision affects a MUST-have workflow AND the default is uncertain
  (e.g. "do we use SSO? default: no" — but client said "SSO is required" earlier
  → conflict, must resolve before baseline)

When conflict detected, surface loudly: "Spec contains conflicting assumption on X. Must resolve before baseline."
