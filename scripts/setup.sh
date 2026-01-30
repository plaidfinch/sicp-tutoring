#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== SICP Tutoring Setup ==="

# Check Racket
if command -v racket &>/dev/null; then
    echo "✓ Racket found: $(racket --version | head -1)"
else
    echo "✗ Racket not found - install from https://racket-lang.org/"
    MISSING_RACKET=1
fi

# Check/install SICP package
if command -v racket &>/dev/null; then
    if racket -e '(require sicp)' 2>/dev/null; then
        echo "✓ SICP package installed"
    else
        echo "Installing SICP package..."
        raco pkg install sicp
    fi
fi

# Fetch book
if [ -d "$PROJECT_DIR/book/full-text" ]; then
    echo "✓ Book already fetched"
else
    echo "Fetching SICP book from MIT..."
    curl -L -o /tmp/sicp.zip \
        "https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip"
    unzip -q /tmp/sicp.zip -d "$PROJECT_DIR/book/"
    rm /tmp/sicp.zip
    [ -f "$PROJECT_DIR/book/code/allcode/allcode.zip" ] && \
        unzip -q "$PROJECT_DIR/book/code/allcode/allcode.zip" -d "$PROJECT_DIR/book/code/extracted/"
    echo "✓ Book fetched"
fi

# Initialize tutor workspace (.tutor/)
if [ -d "$PROJECT_DIR/.tutor/.git" ]; then
    echo "✓ .tutor/ git initialized"
else
    echo "Initializing tutor workspace..."
    mkdir -p "$PROJECT_DIR/.tutor/knowledge/sessions"
    mkdir -p "$PROJECT_DIR/.tutor/notes"
    mkdir -p "$PROJECT_DIR/.tutor/scratch"

    # Create initial files from templates
    cat > "$PROJECT_DIR/.tutor/knowledge/preferences.md" << 'PREFEOF'
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
PREFEOF

    cat > "$PROJECT_DIR/.tutor/knowledge/progress.json" << 'PROGEOF'
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
PROGEOF

    cat > "$PROJECT_DIR/.tutor/knowledge/concepts.md" << 'CONCEOF'
# Conceptual Discussions

This file records substantive "why" questions and deeper explorations.
CONCEOF

    cat > "$PROJECT_DIR/.tutor/knowledge/struggles.md" << 'STRUGEOF'
# Recurring Struggles

Track patterns of confusion that recur across sessions.
STRUGEOF

    cd "$PROJECT_DIR/.tutor" && git init && git add -A && git commit -m "Initial tutor workspace"
    echo "✓ .tutor/ git initialized"
fi

# Initialize student workspace (work/)
if [ -d "$PROJECT_DIR/work/.git" ]; then
    echo "✓ work/ git initialized"
else
    cd "$PROJECT_DIR/work" && git init && git add -A && git commit -m "Initial setup"
    echo "✓ work/ git initialized"
fi

echo ""
echo "Setup complete! Open this directory in Claude Code to begin."
[ "${MISSING_RACKET:-0}" = "1" ] && echo "⚠ Install Racket before tutoring."
