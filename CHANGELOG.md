# Changelog

All notable changes to spec-builder are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/). This project uses [Semantic Versioning](https://semver.org/).

## [1.0.0] — 2026-11-19

Initial public release.

### Added
- SKILL.md with full workflow definition (12 question categories + R&D/POC identification step)
- `install.sh` — idempotent install/update script that copies the skill to `~/.claude/skills/spec-builder/`
- 12 question category files in `questions/`:
  1. Overview & goals
  2. Roles & permissions
  3. Core principles
  4. Workflows & features (FR extraction)
  5. Entity / data model
  6. State machines
  7. Business rules
  8. Integrations
  9. Non-functional requirements
  10. Edge cases
  11. Scope boundaries + R&D / POC identification
  12. Open decisions
- `templates/spec-template.md` — 18-section output skeleton
- `reference/spec-anatomy.md` — full anatomy + writing style + quality gates
- `examples/cams-excerpt.md` — real CAMS (Construction Attendance) example
- MIT LICENSE
- `.gitignore` preserving user drafts and excluding OS/editor artifacts

### Design decisions
- Stack-agnostic entity model (no SQL types, no framework names in spec body)
- Testable acceptance criteria required for every FR
- Minimum 10+ edge cases per spec
- Explicit out-of-scope list required
- Open decisions tracked with sensible defaults (never block implementation)
- R&D/POC gates identified before full build commitment
