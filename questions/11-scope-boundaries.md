# Category 11 — Scope Boundaries & R&D / POC Needs

Purpose: define what's in / out for v1. Identify features that need R&D or a standalone POC before committing to full implementation.

## Questions to ask — IN scope

1. **What's the smallest thing that must exist for launch?** (MVP boundary)
2. **For each major feature, is it `[MUST]`, `[SHOULD]`, or `[COULD]` for v1?**
3. **Which features are explicitly promised to the client?**
4. **Which features can be deferred to v1.1?**

## Questions to ask — OUT of scope

5. **What did the client mention but we're NOT doing in v1?** (list explicitly)
6. **What alternative solutions exist that we're not building?** (context for why)
7. **What's often expected from similar products but we're not providing?**

Common exclusions to confirm with client:
- Native mobile apps (if PWA-only)
- GPS geofencing enforcement (if GPS is optional metadata only)
- Face recognition / biometric verification
- Payroll / invoicing / overtime calculation
- Multi-tenant (if single-tenant)
- SSO / LDAP (if email-password only)
- Advanced reporting / BI dashboards
- Push notifications
- Email digests / subscriptions
- Mobile offline on specific platforms
- Historical data migration from previous system

## Questions to ask — R&D / POC needs

8. **Any feature you're uncertain the stack can deliver?**
9. **Any platform capability you haven't verified on the target devices?**
10. **Any third-party API you've never used?**
11. **Any performance requirement that assumes an untested path?**
12. **Any novel UX pattern the team hasn't shipped before?**
13. **Any hardware integration (camera, GPS, Bluetooth, NFC, printer)?**
14. **Anything the client described as "it should also" that's actually complex?**

## Decision tree for POC

For each feature in doubt, ask:

```
Does the team have direct, recent experience shipping this on the exact target platform/stack?
├── YES → No POC needed, document assumptions
└── NO  → Risk level?
         ├── LOW  (small feature, fallback exists) → POC optional, flag as risk
         └── HIGH (core workflow, no fallback)     → POC REQUIRED before commit
```

**Examples that typically need a POC:**
- Offline-first sync with photo blobs on iOS PWA (the CAMS case)
- Background sync while app is closed on iOS
- Native camera authenticity in a PWA
- Real-time features (WebRTC, websocket scale)
- Large file upload with resume
- GPS accuracy indoors
- Push notifications on iOS web
- OAuth with a specific uncommon provider
- Payment flow with 3DS / SCA
- Document signing integration
- SSO with enterprise identity provider
- Bluetooth / NFC on web
- Camera-based scanning (barcode, OCR, document)

**Examples that typically DON'T need a POC:**
- Standard CRUD with REST
- Email + password login
- CSV export
- Admin dashboard with tables
- RBAC with 2-3 roles
- Static i18n with 2 languages

## POC scope template

If a POC is needed, document:

```markdown
### POC-01 — [Feature name]

**Question to answer:** [What's the single yes/no question this POC resolves?]

**Acceptance for GO:** [What must work to proceed with full build]
**Acceptance for NO-GO:** [What triggers a rethink]

**Scope (keep minimal):**
- [Tested on specific device A]
- [Tested with specific flow B]
- [NOT testing C, D, E]

**Timebox:** [Max days before decision — often 3-5]
**Owner:** [who does it]

**Fallback if NO-GO:** [plan B — defer? simplify? change stack?]
```

## What to extract

- Section 15 (Out of scope) — bullet list of explicit exclusions
- Section 4 (FRs) — tag each FR as `[MUST]`, `[SHOULD]`, `[COULD]`
- Section 4 (FRs) — tag risky FRs as `[R&D REQUIRED]`
- A new POC subsection or Section 20 — list of POCs needed before full build

## Red flags

- Empty "out of scope" list → scope WILL creep
- Every feature is `[MUST]` → not real prioritization
- "The team can figure it out" for a risky unknown → POC it
- POC skipped due to time pressure → biggest source of failed deliveries

## Example output snippet

```markdown
## 15. Out of scope (explicitly excluded)

The product does NOT:
- Provide separate native Android/iOS applications (PWA only)
- Enforce GPS/geofencing on attendance (GPS is optional metadata, allow-and-flag)
- Perform face recognition or biometric identity verification
- Calculate payroll, wages, shift premiums, overtime, or invoicing
- Support QR code attendance
- Provide advanced staff scheduling
- Guarantee background sync when the PWA is fully closed
- Guarantee tamper-proof photo provenance in a browser
- Guarantee survival of unsynced data after browser storage eviction or device loss
- Translate user-entered names (worker names, project names, site names)

These may be considered in future releases but are architecturally not v1.

## 20. Proof-of-concept scope (pre-build gates)

### POC-01 — Offline-first PWA on installed iPhone

**Question:** Can an installed iPhone PWA reliably store photos + events
offline for a full shift (8+ hours) and sync on reopen?

**GO:** Capture 2 events offline, force-close app, airplane mode, reopen,
reconnect — all events synced with original timestamps, no data loss.
**NO-GO:** Any data loss, any persistence failure, any photo corruption.

**Scope:**
- iPhone 15 Safari (iOS 17+), installed Home Screen PWA
- 2 check-in/checkout cycles with camera photo
- Force-close between cycles
- Confirmed sync on reconnect with correct server_received_at

**Timebox:** 3 days
**Owner:** [FE lead]

**Fallback if NO-GO:** Scope iOS to foreground-only sync; document clearly;
consider React Native hybrid for iOS later.

### POC-02 — GPS fix quality on construction sites

**Question:** Can we get GPS fixes with < 50m accuracy on active construction
sites (metal, concrete, indoor areas)?

**GO:** Median accuracy < 50m across 3 tested sites; failure modes recoverable.
**NO-GO:** Median accuracy > 100m or > 30% of fixes fail → GPS unreliable as
attendance signal; de-scope.

**Timebox:** 2 days
**Owner:** [FE lead + client contact at construction site]
```
