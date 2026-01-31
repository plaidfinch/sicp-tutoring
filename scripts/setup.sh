#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Parse arguments
REPAIR_MODE=false
for arg in "$@"; do
    case $arg in
        --repair)
            REPAIR_MODE=true
            shift
            ;;
    esac
done

echo "=== SICP Tutoring Setup ==="
if $REPAIR_MODE; then
    echo "(Repair mode: re-checking all phases)"
fi

# === Dependency Check (early exit if missing) ===
MISSING_DEPS=()

command -v git &>/dev/null || MISSING_DEPS+=("git")
command -v pandoc &>/dev/null || MISSING_DEPS+=("pandoc")
command -v curl &>/dev/null || MISSING_DEPS+=("curl")
command -v unzip &>/dev/null || MISSING_DEPS+=("unzip")

# Check for Racket with DrRacket (full installation, not minimal)
if ! command -v racket &>/dev/null; then
    MISSING_DEPS+=("racket (full installation with DrRacket)")
elif ! command -v drracket &>/dev/null && [ ! -d "/Applications/DrRacket.app" ]; then
    # Has racket but not DrRacket - likely minimal installation
    MISSING_DEPS+=("drracket (need full Racket installation, not minimal)")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "MISSING_DEPENDENCIES: ${MISSING_DEPS[*]}"
    echo ""
    echo "The tutor needs these tools installed. Claude will help install them."
    exit 1
fi

# === All dependencies present, proceed with setup ===

# Check/install SICP Racket package
RACKET_MARKER="$PROJECT_DIR/.setup-markers/racket-sicp"
if [ -f "$RACKET_MARKER" ] && ! $REPAIR_MODE; then
    echo "✓ SICP package installed"
elif racket -e '(require sicp)' 2>/dev/null; then
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$RACKET_MARKER"
    echo "✓ SICP package installed"
else
    echo "Installing SICP package..."
    raco pkg install --auto --scope installation sicp
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$RACKET_MARKER"
fi

# Initialize submodule
SUBMODULE_MARKER="$PROJECT_DIR/.setup-markers/submodule"
if [ -f "$SUBMODULE_MARKER" ] && ! $REPAIR_MODE; then
    echo "✓ Book submodule present"
elif [ -f "$PROJECT_DIR/book/sicp-source/html/index.xhtml" ]; then
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$SUBMODULE_MARKER"
    echo "✓ Book submodule present"
else
    echo "Initializing SICP book submodule..."
    git -C "$PROJECT_DIR" submodule update --init --depth 1 book/sicp-source
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$SUBMODULE_MARKER"
    echo "✓ Book submodule initialized"
fi

# Process to markdown (one-time, requires pandoc)
PROCESSED_MARKER="$PROJECT_DIR/.setup-markers/book-processed"
if [ -f "$PROCESSED_MARKER" ] && ! $REPAIR_MODE; then
    echo "✓ Book already processed"
elif [ -d "$PROJECT_DIR/book/text" ] && [ -n "$(ls -A "$PROJECT_DIR/book/text" 2>/dev/null)" ]; then
    # Content exists but marker doesn't—fix the marker
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$PROCESSED_MARKER"
    echo "✓ Book already processed"
else
    echo "Processing book to markdown..."
    "$PROJECT_DIR/scripts/process-book.sh"
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$PROCESSED_MARKER"
    touch "$PROJECT_DIR/.setup-markers/tutor-verify-book"
    echo "✓ Book processed to markdown"
fi

# Initialize tutor workspace (.tutor/)
# This must happen before the MIT fetch — the fetch can hang/fail,
# and the workspaces are critical for the tutor to function.
TUTOR_MARKER="$PROJECT_DIR/.setup-markers/tutor-workspace"
if [ -f "$TUTOR_MARKER" ] && ! $REPAIR_MODE; then
    echo "✓ .tutor/ git initialized"
elif [ -d "$PROJECT_DIR/.tutor/.git" ]; then
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$TUTOR_MARKER"
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
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$TUTOR_MARKER"
    echo "✓ .tutor/ git initialized"
fi

# Initialize student workspace (work/)
WORK_MARKER="$PROJECT_DIR/.setup-markers/work-workspace"
mkdir -p "$PROJECT_DIR/work"
if [ -f "$WORK_MARKER" ] && ! $REPAIR_MODE; then
    echo "✓ work/ git initialized"
elif [ -d "$PROJECT_DIR/work/.git" ]; then
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$WORK_MARKER"
    echo "✓ work/ git initialized"
else
    touch "$PROJECT_DIR/work/.gitkeep"
    cd "$PROJECT_DIR/work" && git init && git add -A && git commit -m "Initial setup"
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$WORK_MARKER"
    echo "✓ work/ git initialized"
fi

# Fetch problem sets and code from MIT (not in sarabander repo)
# This is last because the MIT server can be slow/unreliable,
# and everything above is sufficient to start tutoring.
MIT_MARKER="$PROJECT_DIR/.setup-markers/mit-fetched"
if [ -f "$MIT_MARKER" ] && ! $REPAIR_MODE; then
    echo "✓ Problem sets and code present"
elif [ -d "$PROJECT_DIR/book/psets" ] && [ -d "$PROJECT_DIR/book/code" ]; then
    # Content exists but marker doesn't—fix the marker
    mkdir -p "$PROJECT_DIR/.setup-markers"
    touch "$MIT_MARKER"
    echo "✓ Problem sets and code present"
else
    echo "Fetching problem sets and code from MIT..."
    mkdir -p "$PROJECT_DIR/book"
    if curl -sL --max-time 60 -o /tmp/sicp.zip \
        "https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip"; then
        # Extract only psets and code directories
        unzip -o -q /tmp/sicp.zip "psets/*" "code/*" -d "$PROJECT_DIR/book/" 2>/dev/null || true
        rm -f /tmp/sicp.zip
        # Extract the .scm source files
        if [ -f "$PROJECT_DIR/book/code/allcode.zip" ]; then
            mkdir -p "$PROJECT_DIR/book/code/extracted"
            unzip -o -q "$PROJECT_DIR/book/code/allcode.zip" -d "$PROJECT_DIR/book/code/extracted/"
        fi
        mkdir -p "$PROJECT_DIR/.setup-markers"
        touch "$MIT_MARKER"
        echo "✓ Problem sets and code fetched"
    else
        echo "⚠ MIT fetch timed out (problem sets unavailable, not critical)"
    fi
fi

echo ""
echo "Setup complete! Open this directory in Claude Code to begin."
