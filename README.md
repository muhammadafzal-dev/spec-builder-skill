# spec-builder

A Claude Code skill that turns an unstructured project discussion into a complete, stack-agnostic business/product specification.

## What it does

Guides the AI through a structured interview with you covering:

1. Project overview + goals
2. Roles + permissions
3. Core principles / non-negotiables
4. Workflows + functional requirements
5. Entity + data model
6. State machines
7. Business rules + calculations
8. Integrations
9. Non-functional requirements (offline, i18n, performance, security, GDPR)
10. Edge cases + failure modes
11. Scope boundaries (in-scope / out-of-scope)
12. Open decisions for product owner

Produces a numbered-FR spec that could be handed to any dev team in any tech stack.

## Install

```bash
./install.sh
```

Copies the skill into `~/.claude/skills/spec-builder/`. Claude Code picks it up automatically.

## Update

Re-run the same script — it's idempotent.

```bash
./install.sh
```

Existing drafts in `~/.claude/skills/spec-builder/drafts/` are preserved; everything else is overwritten with the latest version.

## Uninstall

```bash
rm -rf ~/.claude/skills/spec-builder
```

## Use

In any Claude Code session:

```
/spec-builder
```

Or just say: *"Help me spec out a new project."*

The skill then:
1. Asks whether starting fresh / continuing / reviewing
2. Gathers project basics (name, platforms, languages, constraints)
3. Walks through 12 question categories
4. Writes the spec incrementally to `SPEC.md` (or path you specify)
5. Reviews with you, highlights open decisions
6. Baselines as v1.0

## Folder structure

```
spec-builder-skill/
├── SKILL.md                    skill definition read by Claude Code
├── README.md                   this file
├── install.sh                  install / update script (idempotent)
├── templates/
│   └── spec-template.md        output skeleton
├── questions/                  question library — one file per category
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
│   └── spec-anatomy.md         full anatomy of a good spec
└── examples/
    └── cams-excerpt.md         real-world example from a construction attendance project
```

## Principles the skill enforces

- Spec says WHAT, not HOW. No tech stack in business sections.
- Every functional requirement numbered (`FR-001`, `FR-002`, ...) and testable.
- Every edge case documented with expected behavior.
- Explicit out-of-scope list (prevents scope creep).
- Open decisions tracked with sensible defaults (prevents blocking).
- Stack-agnostic entity model — no SQL types, no framework names.

## Contributing

Edit files in this folder, then run `./install.sh` to deploy. For sharing updates with others, this folder is a standard git repo — push to any remote.

## License

Use freely. No warranty.
