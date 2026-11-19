# Agent Notes — For Future Claude Sessions

This file is for **you (Claude)** when you're invoked via `/spec-builder` in a future session. It documents known issues, unverified assumptions, and self-repair guidance. Read this before running the skill's workflow for the first time in a session.

---

## Status at initial release (v1.0.0, 2026-11-19)

### What was built
- SKILL.md with 12-category workflow + R&D/POC identification step
- 12 question files in `questions/`
- Template in `templates/spec-template.md`
- Reference guide in `reference/spec-anatomy.md`
- One example in `examples/cams-excerpt.md`
- Idempotent `install.sh` + MIT LICENSE + CHANGELOG.md

### What was NOT verified end-to-end
- **The skill has not been run against a real new-project interview from scratch.**
  Only static validation was done (files exist, frontmatter parses, template loads).
- No automated test suite exists.
- The skill was built for Claude Code; behavior in other harnesses (Cursor, etc.) is unknown.

---

## Self-check on first invocation

When invoked in a fresh session, before asking the user anything:

1. **Verify your folder is reachable.** You should be in `~/.claude/skills/spec-builder/`. Run:
   ```
   ls ~/.claude/skills/spec-builder/
   ```
   Expected: `SKILL.md`, `README.md`, `templates/`, `questions/`, `reference/`, `examples/`.

2. **Load all 12 question files once.** If any fails to load, note it and continue with what's available. Tell the user which categories are degraded.

3. **Load `templates/spec-template.md`.** If it fails, fall back to the structure described in `reference/spec-anatomy.md` section "Standard sections".

4. **Load `reference/spec-anatomy.md`.** This is the authoritative anatomy guide; use it as backup if any question file is missing.

---

## Known issues / likely gotchas

### 1. Interview feels like a questionnaire
- **Symptom:** User fatigues, gives short answers, stops engaging.
- **Fix:** Don't ask all questions in a category at once. Pick the 2-3 most important, ask conversationally, follow up based on answer. Load the question file as guidance, not a script.

### 2. User can't articulate requirements
- **Symptom:** "I don't know yet", "whatever you think".
- **Fix:** Pick a sensible default, flag as `[OPEN DECISION — default: X]`, move on. Don't block.
- **Red flag:** If > 40% of FRs have open decisions, the project isn't ready to spec — suggest a discovery session.

### 3. Tech stack leaks into business sections
- **Symptom:** User describes solution ("use Supabase"), not problem.
- **Fix:** Redirect: "Noted as a constraint. What's the business behavior we need?" Capture tech in Section 18 (Technical Recommendations — optional) OR in Section 1 as a constraint. NEVER in FRs.

### 4. Edge cases missed
- **Symptom:** User sees edge cases table with < 10 entries and approves.
- **Fix:** Push harder. Walk the systematic prompts in `questions/10-edge-cases.md` section "Systematic prompts". Every workflow gets boundary/null/timing/connectivity/concurrency probes.

### 5. R&D / POC skipped due to confidence
- **Symptom:** "The team knows how to do this."
- **Fix:** Ask specifically: "Has the team shipped this exact capability on the exact target platform recently?" If no → POC. Confidence without evidence is the #1 cause of project failure.

### 6. Output file path confusion
- **Symptom:** User didn't specify where to save, skill writes to unexpected location.
- **Fix:** Always ask explicitly at step 5 of workflow. Default: `<cwd>/SPEC.md`. Confirm before writing.

### 7. Section 18 (Technical Recommendations) feature creep
- **Symptom:** Section 18 grows into a full tech spec with code snippets + version numbers.
- **Fix:** Section 18 is OPTIONAL and must stay high-level (rationale only). Full tech spec belongs in a separate `IMPLEMENTATION.md`. Suggest creating that separately.

### 8. User wants to modify the skill
- **Symptom:** "Can we skip category X?" / "Add category Y."
- **Fix:** First release — honor request in current spec but don't modify the skill itself. If pattern recurs, suggest updating the skill files + re-running `./install.sh`.

### 9. Version drift between source and installed copy
- **Symptom:** Skill behaves oddly; frontmatter version doesn't match CHANGELOG.
- **Fix:** Run `diff -r <repo-path> ~/.claude/skills/spec-builder/` to detect drift. Re-run `./install.sh` from repo.

### 10. Multiple interviews in parallel
- **Symptom:** User starts spec-builder for Project A, then switches to Project B mid-flow.
- **Fix:** Current design assumes one project per session. If user context-switches, save current draft before switching. Suggest the user name the output file explicitly (`SPEC-projectA.md`, `SPEC-projectB.md`).

---

## Self-improvement loop

If you notice a recurring friction during an interview, update the skill:

1. Make the edit in `/Users/gsoft/Desktop/gsoft/spec-builder-skill/` (or wherever the repo is cloned)
2. Bump version in `SKILL.md` frontmatter + add entry to `CHANGELOG.md`
3. Run `./install.sh` to redeploy
4. Commit + push to `muhammadafzal-dev/spec-builder-skill`

Before making a skill change, ask the user — don't modify the skill mid-interview without consent.

---

## Expected behavior checklist

A healthy spec-builder session should:

- [ ] Start by loading reference + template + question files
- [ ] Ask the user for mode (fresh/continue/review)
- [ ] Capture project basics in ~5-8 exchanges (not 20)
- [ ] Walk the 12 categories conversationally, not as a questionnaire wall
- [ ] Flag R&D/POC needs as they emerge (categories 4, 8, 9)
- [ ] Write the spec incrementally to the target file
- [ ] Highlight all `[OPEN DECISION]` items at end
- [ ] Present POC list before baseline
- [ ] Run quality self-check against anatomy guide
- [ ] Baseline as v1.0 only after user confirms
- [ ] Suggest next steps (implementation doc, task breakdown, client review)

If you find yourself deviating significantly from this, pause and re-read `SKILL.md`.

---

## What to tell the user if something breaks

1. **Skill file missing:** "I'm missing [file]. Can you re-run `./install.sh` from the skill repo?"
2. **Template unreadable:** "I'll use the inline fallback structure from the anatomy reference. Output may be less polished."
3. **Too many open decisions:** "40%+ of FRs have open decisions — this project isn't ready to spec yet. Recommend a product discovery session first."
4. **User wants to skip quality checks:** "I can skip, but the spec won't be baseline-ready. Mark as DRAFT until gaps are filled."

---

## Report issues

If you encounter a reproducible issue not covered here:

1. Tell the user what happened
2. Suggest they open an issue at https://github.com/muhammadafzal-dev/spec-builder-skill/issues
3. Offer to draft the issue body with repro steps + expected vs actual behavior
4. Add a note to this file in the repo if the fix is clear

---

## File inventory (for quick reference)

```
SKILL.md                              — workflow definition, read first
README.md                             — human-facing overview
install.sh                            — idempotent install/update
LICENSE                               — MIT
CHANGELOG.md                          — version history
AGENT-NOTES.md                        — this file (agent troubleshooting)
.gitignore                            — ignores drafts/, OS files
templates/spec-template.md            — 18-section output skeleton
reference/spec-anatomy.md             — full anatomy + style + quality gates
examples/cams-excerpt.md              — real-world example
questions/
├── 01-overview-and-goals.md
├── 02-roles-and-permissions.md
├── 03-core-principles.md
├── 04-workflows-and-features.md
├── 05-entity-data-model.md
├── 06-state-machines.md
├── 07-business-rules.md
├── 08-integrations.md
├── 09-non-functional.md
├── 10-edge-cases.md
├── 11-scope-boundaries.md
└── 12-open-decisions.md
```

---

**Last updated:** 2026-11-19 (initial release)
**Updated by:** future sessions should append entries + bump the date
