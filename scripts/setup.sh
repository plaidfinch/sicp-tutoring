#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== SICP Tutoring Setup ==="

# === Dependency Check (early exit if missing) ===
MISSING_DEPS=()

command -v git &>/dev/null || MISSING_DEPS+=("git")
command -v pandoc &>/dev/null || MISSING_DEPS+=("pandoc")
command -v racket &>/dev/null || MISSING_DEPS+=("racket")
command -v curl &>/dev/null || MISSING_DEPS+=("curl")
command -v unzip &>/dev/null || MISSING_DEPS+=("unzip")

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "MISSING_DEPENDENCIES: ${MISSING_DEPS[*]}"
    echo ""
    echo "The tutor needs these tools installed. Claude will help install them."
    exit 1
fi

# === All dependencies present, proceed with setup ===

# Check/install SICP Racket package
if racket -e '(require sicp)' 2>/dev/null; then
    echo "✓ SICP package installed"
else
    echo "Installing SICP package..."
    raco pkg install sicp
fi

# Initialize submodule
if [ ! -f "$PROJECT_DIR/book/sicp-source/html/index.xhtml" ]; then
    echo "Initializing SICP book submodule..."
    git -C "$PROJECT_DIR" submodule update --init --depth 1 book/sicp-source
    echo "✓ Book submodule initialized"
else
    echo "✓ Book submodule present"
fi

# Process to markdown (one-time, requires pandoc)
PROCESSED_MARKER="$PROJECT_DIR/book/text/.processed"
if [ ! -f "$PROCESSED_MARKER" ]; then
    echo "Processing book to markdown..."
    "$PROJECT_DIR/scripts/process-book.sh"
    mkdir -p "$PROJECT_DIR/book/text"
    touch "$PROCESSED_MARKER"
    touch "$PROJECT_DIR/.tutor-verify-book"
    echo "✓ Book processed to markdown"
else
    echo "✓ Book already processed"
fi

# Fetch problem sets and code from MIT (not in sarabander repo)
MIT_MARKER="$PROJECT_DIR/book/.mit-fetched"
if [ ! -f "$MIT_MARKER" ]; then
    echo "Fetching problem sets and code from MIT..."
    mkdir -p "$PROJECT_DIR/book"
    curl -sL -o /tmp/sicp.zip \
        "https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip"
    # Extract only psets and code directories
    unzip -o -q /tmp/sicp.zip "psets/*" "code/*" -d "$PROJECT_DIR/book/" 2>/dev/null || true
    rm /tmp/sicp.zip
    # Extract the .scm source files
    if [ -f "$PROJECT_DIR/book/code/allcode.zip" ]; then
        mkdir -p "$PROJECT_DIR/book/code/extracted"
        unzip -o -q "$PROJECT_DIR/book/code/allcode.zip" -d "$PROJECT_DIR/book/code/extracted/"
    fi
    touch "$MIT_MARKER"
    echo "✓ Problem sets and code fetched"
else
    echo "✓ Problem sets and code present"
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
mkdir -p "$PROJECT_DIR/work"
if [ -d "$PROJECT_DIR/work/.git" ]; then
    echo "✓ work/ git initialized"
else
    touch "$PROJECT_DIR/work/.gitkeep"
    cd "$PROJECT_DIR/work" && git init && git add -A && git commit -m "Initial setup"
    echo "✓ work/ git initialized"
fi

echo ""
echo "Setup complete! Open this directory in Claude Code to begin."
