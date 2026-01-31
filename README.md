# SICP Tutoring Environment

A Claude Code skill for tutoring through [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html).

## Quick Start

1. Run `./tutor` — installs Claude Code if needed, then guides you through setup (including Racket/DrRacket)
2. Open DrRacket, pick up [the book](https://web.mit.edu/6.001/6.037/sicp.pdf), and get to work!

## Directory Overview

- `work/` — Your code and other work for the course (git repository initialized by Claude on first setup)
- `.claude/skills/sicp-tutor/` — Detailed instructions teaching Claude how to be your TA
- `.tutor/` — Claude's private workspace (knowledge, notes, scratch, might contain spoilers or solutions)
- `book/` — SICP book resources (auto-fetched on first setup)

**You should do all your work in `work/`**, so Claude can see what you're doing.
Claude is instructed to never write your code for you, only to act as a teaching assistant, so from
Claude's perspective, `work/` is read-only.

I recommend tracking your progressive work using `git`; Claude can help you learn to do that if you are new to
using version control.
