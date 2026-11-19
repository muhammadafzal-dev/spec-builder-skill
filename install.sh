#!/usr/bin/env bash
# spec-builder — install / update script
# Re-run this script any time to update to the latest version.
# Idempotent: existing installation is overwritten, user drafts preserved.

set -euo pipefail

SKILL_NAME="spec-builder"
SKILL_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
SKILL_TARGET_DIR="$CLAUDE_SKILLS_DIR/$SKILL_NAME"

green() { printf '\033[0;32m%s\033[0m\n' "$1"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$1"; }
red() { printf '\033[0;31m%s\033[0m\n' "$1"; }

echo
green "spec-builder installer"
echo "Source:  $SKILL_SOURCE_DIR"
echo "Target:  $SKILL_TARGET_DIR"
echo

# Pre-flight checks
if [[ ! -f "$SKILL_SOURCE_DIR/SKILL.md" ]]; then
    red "ERROR: SKILL.md not found in $SKILL_SOURCE_DIR"
    red "Run this script from inside the spec-builder-skill folder."
    exit 1
fi

mkdir -p "$CLAUDE_SKILLS_DIR"

# Detect install mode
MODE="install"
if [[ -d "$SKILL_TARGET_DIR" ]]; then
    MODE="update"
    yellow "Existing installation detected — updating."
fi

# Sync files. rsync preserves user-added files not in source, unless we use --delete.
# We want clean sync (so removed questions disappear), but we PRESERVE any drafts/ folder
# the user might have created inside the install target for working copies.
if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete \
        --exclude 'drafts/' \
        --exclude '.git/' \
        --exclude 'install.sh' \
        "$SKILL_SOURCE_DIR/" "$SKILL_TARGET_DIR/"
else
    # Fallback for systems without rsync
    mkdir -p "$SKILL_TARGET_DIR"
    # Preserve drafts
    if [[ -d "$SKILL_TARGET_DIR/drafts" ]]; then
        mv "$SKILL_TARGET_DIR/drafts" "/tmp/spec-builder-drafts-$$"
    fi
    rm -rf "$SKILL_TARGET_DIR"/*
    cp -R "$SKILL_SOURCE_DIR"/* "$SKILL_TARGET_DIR/"
    rm -f "$SKILL_TARGET_DIR/install.sh"
    # Restore drafts
    if [[ -d "/tmp/spec-builder-drafts-$$" ]]; then
        mv "/tmp/spec-builder-drafts-$$" "$SKILL_TARGET_DIR/drafts"
    fi
fi

# Sanity check
if [[ ! -f "$SKILL_TARGET_DIR/SKILL.md" ]]; then
    red "ERROR: Install failed — SKILL.md missing in target."
    exit 1
fi

green "spec-builder ${MODE}ed successfully."
echo
echo "Invoke in Claude Code with:"
echo "    /spec-builder"
echo "or by asking:"
echo "    \"Help me spec out a new project\""
echo
echo "To update later, re-run: $SKILL_SOURCE_DIR/install.sh"
echo "To uninstall: rm -rf $SKILL_TARGET_DIR"
echo
