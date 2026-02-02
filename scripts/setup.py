#!/usr/bin/env python3
"""SICP Tutoring Environment Setup Script"""

import json
import os
import subprocess
import sys
import shutil
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent.resolve()
PROJECT_DIR = SCRIPT_DIR.parent
MARKERS_DIR = PROJECT_DIR / ".setup-markers"


def run(cmd, check=True, capture=False, **kwargs):
    """Run a shell command."""
    if capture:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, **kwargs)
        return result
    else:
        return subprocess.run(cmd, shell=True, check=check, **kwargs)


def command_exists(cmd):
    """Check if a command exists."""
    return shutil.which(cmd) is not None


def marker_exists(name):
    """Check if a setup marker exists."""
    return (MARKERS_DIR / name).exists()


def create_marker(name):
    """Create a setup marker."""
    MARKERS_DIR.mkdir(parents=True, exist_ok=True)
    (MARKERS_DIR / name).touch()


def check_dependencies():
    """Check for required dependencies, exit early if missing."""
    missing = []

    if not command_exists("git"):
        missing.append("git")
    if not command_exists("pandoc"):
        missing.append("pandoc")
    if not command_exists("curl"):
        missing.append("curl")
    if not command_exists("unzip"):
        missing.append("unzip")

    # Check for Racket with DrRacket (full installation)
    if not command_exists("racket"):
        missing.append("racket (full installation with DrRacket)")
    elif not command_exists("drracket") and not Path("/Applications/DrRacket.app").exists():
        missing.append("drracket (need full Racket installation, not minimal)")

    if missing:
        print(f"MISSING_DEPENDENCIES: {' '.join(missing)}")
        print()
        print("The tutor needs these tools installed. Claude will help install them.")
        sys.exit(1)


def setup_racket_sicp(repair_mode):
    """Check/install SICP Racket package."""
    marker = "racket-sicp"

    if marker_exists(marker) and not repair_mode:
        print("✓ SICP package installed")
        return

    # Check if already installed
    result = run("racket -e '(require sicp)'", check=False, capture=True)
    if result.returncode == 0:
        create_marker(marker)
        print("✓ SICP package installed")
        return

    print("Installing SICP package...")
    run("raco pkg install --auto --scope installation sicp")
    create_marker(marker)


def setup_submodule(repair_mode):
    """Initialize the book submodule."""
    marker = "submodule"
    book_index = PROJECT_DIR / "book/sicp-source/html/index.xhtml"

    if marker_exists(marker) and not repair_mode:
        print("✓ Book submodule present")
        return

    if book_index.exists():
        create_marker(marker)
        print("✓ Book submodule present")
        return

    print("Initializing SICP book submodule...")
    run(f"git -C '{PROJECT_DIR}' submodule update --init --depth 1 book/sicp-source")
    create_marker(marker)
    print("✓ Book submodule initialized")


def setup_book_processing(repair_mode):
    """Process book to markdown."""
    marker = "book-processed"
    text_dir = PROJECT_DIR / "book/text"

    if marker_exists(marker) and not repair_mode:
        print("✓ Book already processed")
        return

    if text_dir.exists() and any(text_dir.iterdir()):
        create_marker(marker)
        print("✓ Book already processed")
        return

    print("Processing book to markdown...")
    run(f"'{PROJECT_DIR}/scripts/process-book.sh'")
    create_marker(marker)
    (MARKERS_DIR / "tutor-verify-book").touch()
    print("✓ Book processed to markdown")


def setup_tutor_workspace(repair_mode):
    """Initialize the .tutor/ workspace."""
    marker = "tutor-workspace"
    tutor_dir = PROJECT_DIR / ".tutor"

    if marker_exists(marker) and not repair_mode:
        print("✓ .tutor/ git initialized")
        return

    if (tutor_dir / ".git").exists():
        create_marker(marker)
        print("✓ .tutor/ git initialized")
        return

    print("Initializing tutor workspace...")

    # Create directories
    (tutor_dir / "knowledge/sessions").mkdir(parents=True, exist_ok=True)
    (tutor_dir / "notes").mkdir(parents=True, exist_ok=True)
    (tutor_dir / "scratch").mkdir(parents=True, exist_ok=True)
    (tutor_dir / "transcripts").mkdir(parents=True, exist_ok=True)

    # Create preferences.md
    (tutor_dir / "knowledge/preferences.md").write_text("""\
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
""")

    # Create progress.json
    (tutor_dir / "knowledge/progress.json").write_text(json.dumps({
        "current_chapter": 1,
        "current_section": "1.1",
        "exercises": {
            "completed": [],
            "in_progress": [],
            "skipped": []
        },
        "sessions": {
            "last_session": None,
            "total_sessions": 0
        },
        "concepts": {
            "substitution_model": "not_yet_introduced",
            "recursion": "not_yet_introduced",
            "higher_order_procedures": "not_yet_introduced",
            "data_abstraction": "not_yet_introduced"
        },
        "notes": "Initialized for new student"
    }, indent=2) + "\n")

    # Create concepts.md
    (tutor_dir / "knowledge/concepts.md").write_text("""\
# Conceptual Discussions

This file records substantive "why" questions and deeper explorations.
""")

    # Create struggles.md
    (tutor_dir / "knowledge/struggles.md").write_text("""\
# Recurring Struggles

Track patterns of confusion that recur across sessions.
""")

    # Initialize git repo
    run(f"cd '{tutor_dir}' && git init && git add -A && git commit -m 'Initial tutor workspace'")
    create_marker(marker)
    print("✓ .tutor/ git initialized")


def setup_work_workspace(repair_mode):
    """Initialize the work/ workspace."""
    marker = "work-workspace"
    work_dir = PROJECT_DIR / "work"
    work_dir.mkdir(exist_ok=True)

    if marker_exists(marker) and not repair_mode:
        print("✓ work/ git initialized")
        return

    if (work_dir / ".git").exists():
        create_marker(marker)
        print("✓ work/ git initialized")
        return

    (work_dir / ".gitkeep").touch()
    run(f"cd '{work_dir}' && git init && git add -A && git commit -m 'Initial setup'")
    create_marker(marker)
    print("✓ work/ git initialized")


def setup_mit_content(repair_mode):
    """Ensure problem sets and code are present.

    These files are committed to the repo (book/psets/, book/code/) so this
    typically does nothing. The MIT fetch is a fallback if files are missing.
    """
    marker = "mit-fetched"
    psets_dir = PROJECT_DIR / "book/psets"
    code_dir = PROJECT_DIR / "book/code"

    if marker_exists(marker) and not repair_mode:
        print("✓ Problem sets and code present")
        return

    if psets_dir.exists() and code_dir.exists():
        create_marker(marker)
        print("✓ Problem sets and code present (from git)")
        return

    print("Fetching problem sets and code from MIT (fallback)...")
    (PROJECT_DIR / "book").mkdir(exist_ok=True)

    result = run(
        "curl -sL --max-time 60 -o /tmp/sicp.zip "
        "'https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip'",
        check=False
    )

    if result.returncode == 0:
        run(f"unzip -o -q /tmp/sicp.zip 'psets/*' 'code/*' -d '{PROJECT_DIR}/book/' 2>/dev/null || true")
        os.remove("/tmp/sicp.zip")

        # Extract source files
        allcode_zip = PROJECT_DIR / "book/code/allcode.zip"
        if allcode_zip.exists():
            extracted_dir = PROJECT_DIR / "book/code/extracted"
            extracted_dir.mkdir(exist_ok=True)
            run(f"unzip -o -q '{allcode_zip}' -d '{extracted_dir}/'")

        create_marker(marker)
        print("✓ Problem sets and code fetched")
    else:
        print("⚠ MIT fetch timed out (problem sets unavailable, not critical)")


def setup_local_docs_permission(repair_mode):
    """Configure local Racket docs permission in settings.local.json."""
    marker = "docs-permission"

    if marker_exists(marker) and not repair_mode:
        print("✓ Local docs permission configured")
        return

    # Get Racket docs path
    result = run(
        "racket -e '(require setup/dirs) (displayln (path->string (find-doc-dir)))'",
        check=False,
        capture=True
    )

    if result.returncode != 0 or not result.stdout.strip():
        print("⚠ Could not detect Racket docs path (local docs unavailable)")
        return

    docs_path = result.stdout.strip()
    if not Path(docs_path).is_dir():
        print("⚠ Could not detect Racket docs path (local docs unavailable)")
        return

    local_settings_path = PROJECT_DIR / ".claude/settings.local.json"

    # Load existing settings or create empty structure
    if local_settings_path.exists():
        with open(local_settings_path, 'r') as f:
            settings = json.load(f)
    else:
        settings = {}

    # Check if already configured
    existing_dirs = settings.get('permissions', {}).get('additionalDirectories', [])
    if docs_path in existing_dirs:
        create_marker(marker)
        print("✓ Local docs permission already configured")
        return

    # Ensure permissions structure exists
    if 'permissions' not in settings:
        settings['permissions'] = {}

    # Add additionalDirectories
    if 'additionalDirectories' not in settings['permissions']:
        settings['permissions']['additionalDirectories'] = []
    if docs_path not in settings['permissions']['additionalDirectories']:
        settings['permissions']['additionalDirectories'].append(docs_path)

    # Add allow rules (// prefix for absolute paths)
    if 'allow' not in settings['permissions']:
        settings['permissions']['allow'] = []
    allow_rules = [
        f"Read(/{docs_path}/**)",
        f"Grep(/{docs_path}/**)",
        f"Glob(/{docs_path}/**)"
    ]
    for rule in allow_rules:
        if rule not in settings['permissions']['allow']:
            settings['permissions']['allow'].append(rule)

    # Write back
    local_settings_path.parent.mkdir(parents=True, exist_ok=True)
    with open(local_settings_path, 'w') as f:
        json.dump(settings, f, indent=2)
        f.write('\n')

    create_marker(marker)
    print("✓ Local docs permission configured")
    print("  ↳ Restart Claude Code session for local docs access to take effect")


def main():
    repair_mode = "--repair" in sys.argv

    print("=== SICP Tutoring Setup ===")
    if repair_mode:
        print("(Repair mode: re-checking all phases)")

    # Check dependencies first (exits if missing)
    check_dependencies()

    # Run all setup phases
    setup_racket_sicp(repair_mode)
    setup_submodule(repair_mode)
    setup_book_processing(repair_mode)
    setup_tutor_workspace(repair_mode)
    setup_work_workspace(repair_mode)
    setup_mit_content(repair_mode)
    setup_local_docs_permission(repair_mode)

    print()
    print("Setup complete! Open this directory in Claude Code to begin.")


if __name__ == "__main__":
    main()
