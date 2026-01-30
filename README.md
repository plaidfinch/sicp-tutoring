# SICP Tutoring Environment

A Claude Code skill for tutoring through *Structure and Interpretation of Computer Programs*.

## Quick Start

1. **Install Racket** from https://racket-lang.org/
2. **Run setup:**
   ```bash
   ./scripts/setup.sh
   ```
3. **Open in Claude Code** and start learning!

The setup script handles:
- Installing the SICP language package
- Fetching the complete book from MIT
- Initializing git repos

## Directory Overview

- `.claude/skills/sicp-tutor/` — Tutoring skill (Claude reads this)
- `.tutor/` — Tutor's private workspace (knowledge, notes, scratch)
- `book/` — SICP book resources (auto-fetched)
- `work/` — Your code (git repo)

## Using DrRacket

DrRacket is your primary environment for writing code:
1. Start each file with `#lang sicp`
2. Use the stepper (Debug → Step) to trace evaluation

See the SICP skill for full tutoring methodology.
