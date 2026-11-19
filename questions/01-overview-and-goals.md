# Category 1 — Overview & Goals

Purpose: capture the business context, users, and what success looks like.

## Questions to ask

### Opening (always ask)
1. **One-line pitch:** "In one sentence, what does this product do?"
2. **Who is the client / sponsor?** (name + role)
3. **Who built or sold this idea internally?** (sponsor, product owner)
4. **What problem does it solve?** (business problem, not technical)
5. **Who uses it?** (list distinct user groups)
6. **What exists today that this replaces or improves?** (current process / tool)

### Context
7. **Why now?** (deadline driver, regulatory, competitive?)
8. **What happens if we don't build this?** (cost of inaction)
9. **Who benefits — client, end users, or both?**
10. **Is this an MVP for a larger vision, or a complete product?**

### Success metrics
11. **How will we know this is successful 6 months after launch?**
12. **Any measurable targets?** (adoption, time saved, error rate, cost)
13. **Any KPIs the client already tracks that this should move?**

### Platforms + reach
14. **Target platforms:** web / mobile / PWA / native iOS / native Android / mix?
15. **Why that platform choice?** (constraint, preference, user context)
16. **Expected concurrent users?** (ballpark — 10, 100, 1000, 10000?)
17. **Geographic reach?** (single country / EU / global?)

### Constraints
18. **Any pre-decided tech stack?** (must use X, must NOT use Y)
19. **Any non-negotiable timeline?** (demo date, go-live, regulatory deadline)
20. **Any budget constraints that shape scope?**
21. **Any infrastructure the client already owns?** (cloud account, DB, auth provider)

## What to extract into the spec

- Product name + codename → header
- One-line pitch → header
- Overview paragraph → Section 1
- Target users → Section 1 + role list for Section 2
- Platforms → header
- Success metrics → Section 1.2 (if any)
- Known constraints → Section 1 overview OR open decisions

## Red flags to probe

- "We'll figure out users later" → bad. Users shape everything. Probe.
- "It needs to be flexible / configurable" → bad. Push for specifics. What specifically needs to vary?
- "Like X but for Y" → OK start, but extract specific features of X that must be present.
- No deadline → fine, but check if any downstream dependency assumes a date.
- No success metrics → push gently. Without metrics the product has no definition of success.

## Example output snippet

```markdown
## 1. Overview

CAMS is an offline-first attendance system for construction workers. Workers at
building sites check in and out using a Progressive Web App on their phones;
each event requires a live photograph and optional GPS snapshot. Administrators
manage workers, projects, sites, and attendance review via a web portal.
Attendance data flows to PostgreSQL (authoritative) and to a client-owned
Google Sheet (secondary reporting).

Replaces paper-based attendance that is manually entered into spreadsheets.
Target users: construction site workers (primary) and site administrators
(secondary). Launching in Netherlands with EN + NL support; architecture
supports additional languages via translation files only.

### 1.1 System modules
1. **Worker PWA** — offline-first attendance capture with live camera
2. **Admin portal** — employee/project/site management, attendance review
3. **Backend** — Supabase Auth + Postgres + Storage + Edge Functions
```
