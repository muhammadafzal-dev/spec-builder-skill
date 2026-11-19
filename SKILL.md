---
name: spec-builder
description: Interactive business/product specification builder. Use when the user starts a new project discussion and wants to create a complete SRS (Software Requirements Specification) before implementation. Walks through structured questions covering roles, workflows, data model, integrations, non-functional requirements, edge cases, and scope boundaries. Produces a stack-agnostic business spec that can be handed to any dev team. Triggers on "/spec-builder", "new project spec", "build a spec", "create requirements doc", "let's spec out X", or when the user describes a new product idea and wants structured capture.
---

# Spec Builder

Interactive skill for creating a complete, stack-agnostic business/product specification.

## When to invoke

- User says `/spec-builder`, `/spec`, `/new-spec`
- User mentions new project idea and asks to capture requirements
- User asks "help me write a spec" / "finalize scope before building"
- User wants to document project after discussion

## Do NOT invoke

- For implementation planning (use `plan` skill)
- For architectural decisions on existing code
- For code reviews
- For writing technical design docs (those come AFTER the business spec)

## Core principles you must follow

1. **Spec says WHAT the product does, not HOW it's built.** Keep tech stack out of the spec body. Tech recommendation goes in optional Section 18.
2. **Interview the user systematically.** Walk through the question categories in order. Don't skip.
3. **Mark assumptions explicitly.** If the user doesn't know, write `[OPEN DECISION — default: X]` and keep moving. Don't block on unknowns.
4. **Number every functional requirement** `FR-001`, `FR-002`, etc. Never renumber after baselined.
5. **Every FR must be testable.** If you can't define an acceptance condition, rewrite it.
6. **Comprehensive edge cases > perfect code.** Press the user to think through failure modes.
7. **Explicit out-of-scope list** — what the product does NOT do.
8. **One source of truth per concern.** Don't duplicate across sections.

## Workflow

### Step 1 — Load context + reference

Before asking the first question, read these in the skill folder:

- `reference/spec-anatomy.md` — the full anatomy of a good spec
- `templates/spec-template.md` — the output template
- All files in `questions/` — question library for each section

### Step 2 — Determine mode

Ask the user:

> Are we:
> 1. Starting a fresh spec (new project)
> 2. Continuing / updating an existing spec (point me at the file)
> 3. Reviewing an existing spec for gaps

If option 2 or 3, read the existing file first before asking questions.

### Step 3 — Ask for project basics

Get these up front:
- Product name + codename
- One-line pitch ("what does it do in one sentence?")
- Who is the client / sponsor?
- Target platforms (web, mobile, PWA, native, mix)
- Languages at launch
- Rough team size + timeline (informational)
- Any hard constraints already decided (e.g. "must use Supabase", "must work offline")

Write these into the spec header.

### Step 4 — Walk the question categories

Go through these in order. Each category has a question file in `questions/`:

1. `01-overview-and-goals.md` — business problem, users, success metrics
2. `02-roles-and-permissions.md` — role matrix, authority model
3. `03-core-principles.md` — non-negotiables that shape every decision
4. `04-workflows-and-features.md` — walk each workflow, extract FRs
5. `05-entity-data-model.md` — things that exist + relationships
6. `06-state-machines.md` — lifecycles for things with states
7. `07-business-rules.md` — formulas, thresholds, calculations
8. `08-integrations.md` — external systems
9. `09-non-functional.md` — offline, i18n, performance, security, GDPR
10. `10-edge-cases.md` — failure modes, invalid states
11. `11-scope-boundaries.md` — explicitly in-scope vs out-of-scope + **R&D / POC needs**
12. `12-open-decisions.md` — questions the product owner must answer

For each category:
- Load the question file for guidance
- Ask the user the relevant questions conversationally (not a questionnaire wall)
- Capture answers in the growing spec
- Confirm before moving to next category
- Mark unknowns as `[OPEN DECISION]` with a sensible default

### Step 4.5 — R&D / POC identification (CRITICAL, don't skip)

While walking categories 4 (workflows), 8 (integrations), and 9 (non-functional), continuously flag items that need validation BEFORE full implementation. Add `[R&D REQUIRED]` tag on the FR and track in a running POC list.

Triggers for POC:
- Platform capability team hasn't verified on target device (iOS PWA background, native camera authenticity, GPS indoors)
- Third-party API team hasn't used (uncertain rate limits, auth model, data retention)
- Performance target that's a stretch for current stack
- Novel UX pattern team hasn't shipped
- Hardware integration (printer, scanner, biometric, Bluetooth, NFC)
- Offline + sync at scale with conflict resolution
- Any "it should also" from client that sounds complex

For each POC, document in Section 20 (or a new Section — call it "Pre-build POC scope"):

```markdown
### POC-01 — [Feature name]

**Question to answer:** [single yes/no]
**GO criteria:** [what must work to proceed]
**NO-GO criteria:** [what triggers a rethink]
**Scope (minimal):** [what will be tested / NOT tested]
**Timebox:** [max days, usually 3-5]
**Owner:** [who runs it]
**Fallback if NO-GO:** [plan B — defer, simplify, change stack]
```

**Before baselining the spec, present the POC list to the user.** Explain each is a gate before committing the full build. User can accept POC list, or push back on specific items ("we're confident, skip POC-03 — document as risk"). Capture that decision in the spec.

This prevents the biggest category of project failure: building a feature on an unverified assumption.

### Step 5 — Draft the spec incrementally

As you gather answers, write each section into the output file. Don't wait until the end. User can watch the spec grow.

Output file default: `<cwd>/SPEC.md` — ask user to override if they want a different path.

### Step 6 — Review + lock

After all categories:
1. Show the user the full spec
2. Highlight all `[OPEN DECISION]` items
3. Ask them to resolve or confirm defaults
4. Ask if they want Section 18 (Technical Recommendations) added — OPTIONAL
5. On confirm, save as `v1.0` baseline

### Step 7 — Quality self-check

Before declaring complete, verify:

- [ ] Every FR has a number + testable acceptance criteria
- [ ] Role matrix table present
- [ ] Entity model is stack-agnostic (no SQL types, no framework names)
- [ ] State machines drawn for anything with lifecycle
- [ ] Edge cases table has 10+ entries
- [ ] Out-of-scope list is explicit
- [ ] Open decisions tracked with defaults
- [ ] Glossary added if domain-specific terms exist

If any item fails, go back and fix.

### Step 8 — Suggest next steps

After the spec is baselined, suggest:
- Add a `docs/implementation/` folder for tech-specific docs
- Create tasks from FRs for the dev team
- Schedule a client review session

## Output format

Final spec follows `templates/spec-template.md` exactly. Markdown. UTF-8. ISO dates. No images embedded (link externally).

Section numbering is fixed (1–17 mandatory, 18 optional). Within sections, FRs are numbered per-section (FR-001 under FRs, not "section 5 item 3").

## Rules for AI behavior during this skill

- **Do not invent requirements.** If the user didn't mention it, ask — don't assume.
- **Do not inject tech stack into business sections.** Never write "we'll use Postgres" in Section 7.
- **Do not skip edge cases.** Push the user: "what if the user is offline? what if they double-tap?"
- **Do not write vague FRs.** Reject "system handles X" — replace with specific action + actor + outcome.
- **Preserve user's wording for business terms.** If they say "crew" don't translate to "team".
- **Do not finalize if open decisions block core workflows.** Flag them and surface the risk.
- **Cite the reference where you learned something** (e.g. "per answer in step 4.3").
- **Update, don't replace.** When resuming, read existing content first, then extend.

## Files in this skill

```
spec-builder/
├── SKILL.md                    (this file)
├── README.md                   (human overview)
├── install.sh                  (install / update)
├── templates/
│   └── spec-template.md        (output skeleton)
├── questions/
│   ├── 01-overview-and-goals.md
│   ├── 02-roles-and-permissions.md
│   ├── 03-core-principles.md
│   ├── 04-workflows-and-features.md
│   ├── 05-entity-data-model.md
│   ├── 06-state-machines.md
│   ├── 07-business-rules.md
│   ├── 08-integrations.md
│   ├── 09-non-functional.md
│   ├── 10-edge-cases.md
│   ├── 11-scope-boundaries.md
│   └── 12-open-decisions.md
├── reference/
│   └── spec-anatomy.md         (full anatomy guide)
└── examples/
    └── cams-excerpt.md         (real-world example)
```
