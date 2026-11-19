# [Product Name] — Software Requirements Specification (SRS)

**Version:** 1.0 — DRAFT
**Status:** Draft / In review / Baseline / Superseded
**Date:** YYYY-MM-DD
**Author:** [name]
**Client / Sponsor:** [name]
**Platforms:** [web / mobile / PWA / native / etc.]
**Languages at launch:** [en, nl, ...]
**One-line pitch:** [What the product does in one sentence]

---

## 1. Overview

[2-3 paragraphs: the business problem, who uses the product, what it replaces or improves, big constraints up front.]

### 1.1 System modules

1. **[Module name]:** [one-line description]
2. **[Module name]:** [one-line description]
3. **[Module name]:** [one-line description]

### 1.2 Success metrics (optional)

- [Measurable outcome #1]
- [Measurable outcome #2]

---

## 2. Roles and permissions

| Capability | [Role A] | [Role B] | [Role C] |
|---|---|---|---|
| [Capability 1] | Yes | No | No |
| [Capability 2] | Yes | Yes | No |
| [Capability 3] | No | Yes | No |

### 2.1 Authority model

[Role-based? Attribute-based? Resource-level? Describe briefly.]

### 2.2 Role definitions

- **[Role A]:** [Who they are, what they do]
- **[Role B]:** [Who they are, what they do]

---

## 3. Core principles

Non-negotiables that shape every decision:

- [Principle 1]
- [Principle 2]
- [Principle 3]

---

## 4. Functional requirements

### FR-001 — [Feature name]

**Actor:** [Role]
**Goal:** [What they're trying to achieve]
**Steps:**
1. [Step]
2. [Step]
3. [Step]

**Data captured:** [list of fields]
**Validation rules:** [what must be true]
**Acceptance:** [concrete pass/fail condition]

### FR-002 — [Feature name]

...

[Continue grouping FRs by workflow: onboarding, core actions, data mgmt, reports, settings, etc.]

---

## 5. Entity / data model

Stack-agnostic. Just: what things exist, what fields they have, how they relate.

### [Entity 1]
- **Fields:** id, [field], [field], [field]
- **Relationships:** [this entity relates to X via Y]

### [Entity 2]
- **Fields:** ...

### Relationship diagram (optional)

```
[Entity A] 1---* [Entity B]
    |
    |
[Entity C]
```

---

## 6. State machines

For anything with a lifecycle:

### [Entity] status

```
NEW → ACTIVE → COMPLETED
       |
       └─→ CANCELLED
```

**Allowed transitions:**

| From | To | Trigger |
|---|---|---|
| NEW | ACTIVE | [action] |
| ACTIVE | COMPLETED | [action] |

**Forbidden transitions** (must reject): [list]

---

## 7. Business rules

### 7.1 [Rule name]

[Formula or threshold with example]

Example: *"Duration = checkout - checkin, calculated with full timestamps for overnight shifts."*

### 7.2 [Rule name]

...

---

## 8. Integrations

### 8.1 [External system name]

- **Purpose:** [what it's used for]
- **Direction:** [we push / we pull / bidirectional]
- **Failure behavior:** [what happens if it's down]
- **Authentication:** [how we authenticate]

---

## 9. Multilingual support

- **Languages at launch:** [list]
- **Fallback:** [which locale]
- **What gets translated:** UI labels, error messages, notifications
- **What doesn't:** user-entered names (projects, people, places)
- **Future languages:** [RTL support? extensibility?]

---

## 10. Security and privacy

### 10.1 Authentication
[Method: email/password, SSO, OAuth, etc.]

### 10.2 Authorization
[Model: RBAC, ABAC, resource-level?]

### 10.3 Data classification
- **Sensitive:** [list]
- **PII:** [list]
- **Public:** [list]

### 10.4 Compliance
- [ ] GDPR applicable
- [ ] HIPAA applicable
- [ ] Other: [list]

### 10.5 Retention
[How long each data type is kept]

### 10.6 Audit requirements
[What actions must be logged, kept how long]

---

## 11. Non-functional requirements

| Requirement | Target |
|---|---|
| Availability | [uptime target] |
| Response time p99 | [latency] |
| Offline capability | [yes/no + scope] |
| Concurrent users | [number] |
| Data growth | [rate per year] |
| Backup frequency | [daily/hourly/...] |

---

## 12. Edge cases and expected handling

| Condition | Required behavior |
|---|---|
| User has no [thing] | Show empty state, block action |
| Connection lost mid-save | Save locally, sync on reconnect |
| Duplicate submission | One event only (idempotent) |
| Invalid input | Reject with localized error |
| Session expired | Prompt re-login, preserve work |
| Permission revoked while using | Flag for review, don't delete |
| [Add more] | [Expected behavior] |

---

## 13. Acceptance tests

Per-feature checklist. All items must pass for release.

### [Feature group]
- [ ] [Testable condition 1]
- [ ] [Testable condition 2]

### [Feature group]
- [ ] ...

---

## 14. Definition of done

Top-level release criteria:

1. [Criterion 1]
2. [Criterion 2]
3. [Criterion 3]

---

## 15. Out of scope (explicitly excluded)

The product does NOT:
- [Excluded feature 1]
- [Excluded feature 2]
- [Excluded feature 3]

These may be added in future releases but are not part of v1.

---

## 16. Open decisions for product owner

Each with a sensible default — product owner must confirm or override before freeze.

1. [Question] (Default: [assumption])
2. [Question] (Default: [assumption])
3. [Question] (Default: [assumption])

---

## 17. Glossary

Domain-specific terms:

- **[Term]:** [definition]
- **[Term]:** [definition]

---

## 18. Technical recommendations (OPTIONAL — skip if client has separate tech doc)

**If included, keep high-level. No code, no specific libraries. Rationale only.**

| Concern | Recommendation | Why |
|---|---|---|
| Frontend | [tech] | [reason] |
| Backend | [tech] | [reason] |
| Database | [tech] | [reason] |
| Hosting | [tech] | [reason] |

Detailed tech stack, versions, package lists, and architecture decisions live in a separate `IMPLEMENTATION.md` or `docs/` folder — NOT here.

---

## Changelog

| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | [name] | Baseline |

---

## Sign-off

**Product owner:** _______________ **Date:** _____
**Technical lead:** ______________ **Date:** _____
**Client representative:** _______ **Date:** _____
