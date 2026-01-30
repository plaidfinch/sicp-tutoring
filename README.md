# SICP Tutoring Environment

A Claude Code skill for tutoring through *Structure and Interpretation of Computer Programs*.

## Quick Start

1. **Install Racket** from https://racket-lang.org/
2. **Run setup:**
   ```bash
   ./scripts/setup.sh
   ```
3. **Open Claude Code** and start learning!

The setup script handles:

- Installing the SICP language package
- Fetching the complete book from MIT
- Initializing git repos

## Directory Overview

- `.claude/skills/sicp-tutor/` — Tutoring skill (Claude reads this)
- `.tutor/` — Tutor's private workspace (knowledge, notes, scratch)
- `book/` — SICP book resources (auto-fetched)
- `work/` — Your code (git repo)

You should do all your work in `work/`, so Claude can see what you're doing. Claude is instructed
to never write your code for you, only to act as a teaching assistant.
