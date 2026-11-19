# Category 3 — Core Principles

Purpose: capture non-negotiables that shape every decision. If a dev proposes something that violates these, the spec answers "no".

## Questions to ask

1. **What's the single most important constraint on this product?**
2. **Is there a "source of truth" rule?** (e.g. "DB is authoritative, spreadsheet is reporting only")
3. **Are there data integrity rules you cannot violate?** (atomicity, idempotency, immutability)
4. **Any UX principles that can't be compromised?** (e.g. "workers need < 3 taps to check in")
5. **Any security principles?** (e.g. "service keys never in browser", "photos always private")
6. **Any compliance principles?** (e.g. "all admin changes must be audited", "PII never in logs")
7. **Any performance principles?** (e.g. "app must open in under 3s on 3G")
8. **Any offline/connectivity principles?** (e.g. "must work with no internet for 8+ hours")
9. **Any accessibility principles?** (e.g. "WCAG 2.1 AA minimum")
10. **Any localization principles?** (e.g. "no hardcoded strings, ever")
11. **Any trust boundaries?** (e.g. "frontend filtering is not a security boundary")
12. **What are you explicitly NOT going to promise?** (e.g. "no guaranteed background sync when app is closed")

## What to extract

- 5-10 short non-negotiable statements → Section 3 bullet list
- Any "we will never" statements → also Section 3
- Trust boundaries → Section 10 (security)

## Red flags to probe

- No principles stated — probe. Without principles, every meeting re-litigates basics.
- Principles that conflict ("offline-first" + "always synced") — surface the trade-off.
- Principles stated but not enforceable ("secure") — rewrite as testable constraint.

## Writing style for principles

- **Short imperative statements.** "The database is the system of record."
- **Avoid adjectives.** "Fast" is not a principle. "p99 < 500ms" is.
- **Prefer "do not" formulations when they're genuinely non-negotiable.** "Do not promise background sync when app is closed."
- **One principle = one statement.** Don't compound.

## Example output snippet

```markdown
## 3. Core principles

- Worker interface must prioritize large buttons, clear icons, minimal text,
  and a short check-in/out flow.
- Employees only see sites explicitly assigned by an administrator.
- Every attendance event and photo is first saved together locally; server sync
  is separate.
- The backend database is the system of record; Google Sheets is a secondary
  reporting destination.
- All user-facing application strings are localized using translation keys.
- Do not promise guaranteed background sync when the PWA is closed, or
  tamper-proof camera provenance in a browser.
- Frontend filtering is not a security boundary.
```
