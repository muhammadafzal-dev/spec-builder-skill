# Category 9 — Non-Functional Requirements

Purpose: performance, availability, scale, offline, i18n, accessibility, security, privacy, compliance. Everything that isn't a feature but shapes the product.

## Questions to ask

### Performance
1. **Cold-load target?** (first load on 3G, 4G, wifi)
2. **Cached-load target?** (subsequent opens)
3. **End-to-end action latency?** (e.g. check-in under 5s)
4. **API p99 latency target?**
5. **Payload size caps?** (per request, per upload)

### Scale
6. **Concurrent users expected?** (daily active, peak concurrent)
7. **Data volume?** (records per year, storage GB)
8. **Growth projection?** (2x? 10x?)
9. **Geographic distribution?** (single region, multi-region CDN?)

### Availability
10. **Uptime target?** (99%, 99.5%, 99.9%)
11. **Planned maintenance windows allowed?**
12. **Degraded mode acceptable?** (read-only when DB down, offline-only for workers)

### Offline
13. **Must the product work offline?** (fully / partially / not at all)
14. **For how long offline?** (minutes, hours, days)
15. **What data must be available offline?**
16. **What actions must be possible offline?**
17. **How is sync handled on reconnection?**
18. **Risk of data loss acceptable?** (never, after device clear, etc.)

### Internationalization
19. **Languages at launch?**
20. **Fallback language?**
21. **What gets translated?** (UI only? Error codes? Email templates?)
22. **What doesn't?** (user-entered names)
23. **RTL support anticipated?**
24. **Date/number/currency formatting?** (business locale or UI locale)
25. **Timezone handling?** (business timezone, user timezone, mixed)

### Accessibility
26. **Target compliance level?** (WCAG 2.1 A / AA / AAA)
27. **Specific user needs?** (large touch targets for workers, high contrast)
28. **Screen reader support required?**
29. **Keyboard-only navigation required?**

### Security
30. **Authentication method?**
31. **Session timeout?**
32. **2FA / MFA required?** (per role or global)
33. **Password policy?**
34. **Rate limiting on auth endpoints?**
35. **Encryption at rest?** (DB, storage)
36. **Encryption in transit?** (TLS, mTLS)
37. **Secrets rotation plan?**
38. **CSP / security headers?**

### Privacy / Compliance
39. **Applicable regulations?** (GDPR, HIPAA, PCI, SOC2, local)
40. **Lawful basis for processing?** (consent, legitimate interest, contract)
41. **Data subject rights process?** (access, deletion, portability requests)
42. **Retention policy per data type?** (photos N years, logs N months)
43. **Right to be forgotten workflow?** (anonymize vs delete)
44. **Data residency requirements?** (EU-only, country-specific)
45. **Data processing agreements needed?** (with sub-processors)
46. **Workplace monitoring consultation required?** (works council / union sign-off in EU)
47. **Privacy notice visible to users?**

### Audit + logging
48. **What actions must be auditable?** (every admin change? every login?)
49. **Audit log retention?**
50. **Log aggregation requirements?** (shipping to SIEM?)
51. **PII in logs allowed?** (should be no)
52. **Anonymization vs pseudonymization?**

### Backup / DR
53. **Backup frequency?**
54. **Restore RTO / RPO?** (recovery time + point objectives)
55. **Off-site / cross-region backups required?**
56. **DR drill frequency?**

### Device / Browser targets
57. **Supported browsers?** (names + minimum versions)
58. **Supported OS versions?** (iOS N+, Android N+)
59. **Device hardware constraints?** (low-end phones?)
60. **Network conditions?** (slow 3G support?)

## What to extract

- Section 11 (Non-functional requirements) — the table of targets
- Section 10 (Security & privacy) — auth, authz, retention, audit, compliance
- Section 9 (Multilingual) — languages + rules
- Any compliance obligations → surface as principles in Section 3

## Red flags

- No performance targets → "fast" isn't testable
- "Must work offline" with no scope → unpack what offline means exactly
- "GDPR compliant" with no specific actions → list required flows (export, deletion, notice)
- No backup / restore plan → ops nightmare
- "Secure" with no specifics → unpack threat model

## R&D / POC triggers

Mark `[R&D RECOMMENDED]` on any of these if the team hasn't shipped it before:
- Offline sync with conflict resolution at scale
- iOS installed PWA with background sync (uncertain)
- Native camera + permission flows on both platforms
- WebRTC / real-time
- Performance targets on low-end devices
- Multi-region data residency
- GDPR data subject request flows at scale

## Example output snippet

```markdown
## 11. Non-functional requirements

| Requirement | Target |
|---|---|
| PWA cold load (uncached, 3G) | < 3s FCP |
| PWA cached load | < 500ms |
| Check-in end-to-end (online) | < 5s |
| API p99 latency (non-photo) | < 500ms |
| Photo upload success rate | > 99% after retries |
| Sync success rate | > 99.5% after retries |
| Availability (platform SLAs combined) | > 99.9% monthly |
| Offline duration supported | 8+ hours typical shift |
| Concurrent workers (initial) | 100-500 per deployment |
| Data growth | ~110 GB/year photos per 500 workers |
| Backup frequency | Daily automatic |
| Restore RTO | 4 hours |
| Restore RPO | 24 hours (previous day backup) |

## 10. Security and privacy

### 10.1 Authentication
- Email + password managed by Supabase Auth
- Access tokens short-lived (15 min); refresh tokens rotated on use
- Login rate limit: 5 attempts/min/IP

### 10.2 Authorization
- Role-based (ADMIN, WORKER) + resource-level (worker↔site assignment)
- Enforced in backend on every endpoint; RLS + Edge Function validation

### 10.3 Data classification
- **Sensitive:** attendance photos, worker personal names
- **PII:** email, full_name
- **Audit:** admin corrections, name changes, deactivation

### 10.4 Compliance
- GDPR applicable (EU workers, EU data residency via Supabase EU region)
- Lawful basis: legitimate interest (employer attendance monitoring)
- Privacy notice page accessible from both apps
- Data subject access: `/admin/workers/{id}/export` returns JSON
- Right to be forgotten: `/admin/workers/{id}/purge` anonymizes events, deletes photos

### 10.5 Retention
- Photos: configurable `photo_retention_days` (default 730)
- Audit logs: retained for lifetime of system
- Access logs: 90 days

### 10.6 Audit
- All material admin actions logged: invitation CRUD, worker edits, deactivation,
  assignment changes, attendance corrections, settings changes
- Immutable (no DELETE policy on audit_logs)

## 9. Multilingual support

- **Launch:** English (en) + Dutch (nl)
- **Fallback:** English on missing keys
- **Translated:** UI labels, buttons, errors, validations, email templates
- **Not translated:** user-entered project names, site names, worker names
- **Timezone:** Business timezone configured per deployment (Europe/Amsterdam default)
- **Dates:** Formatted in user locale, in business timezone
- **RTL:** Architecture supports (direction-aware layout) but no RTL language at launch
```
