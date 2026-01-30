#!/usr/bin/env bash
#
# Reset the tutoring environment to pre-first-interaction state.
#
# This script:
# - Archives current TA context to a named branch in .tutor/
# - Resets .tutor/ knowledge files to initial placeholders
# - Removes derived book content (text/, code/, psets/)
# - Removes setup markers
# - PRESERVES student work in work/
#
# Usage: ./scripts/reset.sh [archive-name]
#   archive-name: Branch name for archived state (default: archive-YYYY-MM-DD-HHMMSS)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Archive name (argument or timestamp)
ARCHIVE_NAME="${1:-archive-$(date +%Y-%m-%d-%H%M%S)}"

echo "=== SICP Tutoring Environment Reset ==="
echo ""
echo "This will:"
echo "  • Archive .tutor/ state to branch: $ARCHIVE_NAME"
echo "  • Reset all TA knowledge to initial state"
echo "  • Remove cached book content (text/, code/, psets/)"
echo "  • Remove setup markers"
echo ""
echo "This will NOT touch:"
echo "  • work/ (student code)"
echo "  • book/sicp-source/ (submodule)"
echo ""
read -p "Continue? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# =============================================================================
# Phase 1: Archive .tutor/ to a named branch
# =============================================================================

echo ""
echo ">>> Archiving .tutor/ to branch: $ARCHIVE_NAME"

if [[ -d .tutor/.git ]]; then
    cd .tutor

    # Commit any uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
        echo "    Committing uncommitted changes..."
        git add -A
        git commit -m "State before reset to $ARCHIVE_NAME" || true
    fi

    # Create archive branch from current state
    CURRENT_BRANCH=$(git branch --show-current)
    git branch "$ARCHIVE_NAME" 2>/dev/null || {
        echo "    Warning: Branch $ARCHIVE_NAME already exists, using ${ARCHIVE_NAME}-new"
        ARCHIVE_NAME="${ARCHIVE_NAME}-new"
        git branch "$ARCHIVE_NAME"
    }
    echo "    Created branch: $ARCHIVE_NAME"

    cd "$PROJECT_ROOT"
else
    echo "    Warning: .tutor/ is not a git repo, skipping archive"
fi

# =============================================================================
# Phase 2: Reset .tutor/ knowledge files
# =============================================================================

echo ""
echo ">>> Resetting .tutor/ knowledge to initial state"

# preferences.md
cat > .tutor/knowledge/preferences.md << 'EOF'
# Student Preferences

## Identity
- **Name**: [To be filled in first session]
- **Preferred address**: [To be filled in first session]
- **Background**: [To be filled in first session]

## Learning Style
- **Examples**: [Does the student prefer many small examples or fewer comprehensive ones?]
- **Guidance**: [More Socratic questioning or more direct hints?]
- **Analogies**: [Helpful? From what domains?]

## Session Preferences
- [To be filled in first session]

## Communication
- [To be filled in first session]
EOF
echo "    Reset preferences.md"

# progress.json
cat > .tutor/knowledge/progress.json << 'EOF'
{
  "current_chapter": 1,
  "current_section": "1.1",
  "exercises": {
    "completed": [],
    "in_progress": [],
    "skipped": []
  },
  "sessions": {
    "last_session": null,
    "total_sessions": 0
  },
  "concepts": {
    "substitution_model": "not_yet_introduced",
    "recursion": "not_yet_introduced",
    "higher_order_procedures": "not_yet_introduced",
    "data_abstraction": "not_yet_introduced"
  },
  "notes": "Initialized for new student"
}
EOF
echo "    Reset progress.json"

# concepts.md
cat > .tutor/knowledge/concepts.md << 'EOF'
# Conceptual Discussions

This file records substantive "why" questions and deeper explorations.
EOF
echo "    Reset concepts.md"

# struggles.md
cat > .tutor/knowledge/struggles.md << 'EOF'
# Recurring Struggles

Track patterns of confusion that recur across sessions.
EOF
echo "    Reset struggles.md"

# Clear sessions
rm -rf .tutor/knowledge/sessions/*
echo "    Cleared sessions/"

# Clear notes (TA's chapter preparation)
rm -rf .tutor/notes/*
echo "    Cleared notes/"

# Clear scratch
rm -rf .tutor/scratch/*
echo "    Cleared scratch/"

# Commit the reset state
if [[ -d .tutor/.git ]]; then
    cd .tutor
    git add -A
    git commit -m "Reset to initial state (archived to $ARCHIVE_NAME)" || true
    cd "$PROJECT_ROOT"
fi

# =============================================================================
# Phase 3: Remove derived book content
# =============================================================================

echo ""
echo ">>> Removing derived book content"

if [[ -d book/text ]]; then
    rm -rf book/text
    echo "    Removed book/text/"
fi

if [[ -d book/code ]]; then
    rm -rf book/code
    echo "    Removed book/code/"
fi

if [[ -d book/psets ]]; then
    rm -rf book/psets
    echo "    Removed book/psets/"
fi

# Keep book/sicp-source/ (the submodule)
echo "    Preserved book/sicp-source/"

# =============================================================================
# Phase 4: Remove setup markers
# =============================================================================

echo ""
echo ">>> Removing setup markers"

if [[ -d .setup-markers ]]; then
    rm -rf .setup-markers
    echo "    Removed .setup-markers/"
else
    echo "    No .setup-markers/ found"
fi

# Remove any tutor verification marker
if [[ -f .tutor-verify-book ]]; then
    rm -f .tutor-verify-book
    echo "    Removed .tutor-verify-book"
fi

# =============================================================================
# Done
# =============================================================================

echo ""
echo "=== Reset Complete ==="
echo ""
echo "Archived state: .tutor/ branch '$ARCHIVE_NAME'"
echo ""
echo "To restore archived state:"
echo "  cd .tutor && git checkout $ARCHIVE_NAME"
echo ""
echo "To start fresh, run:"
echo "  ./scripts/setup.sh"
echo ""
