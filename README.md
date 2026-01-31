# SICP Tutoring Environment

A Claude Code skill for tutoring through [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html).

## Quick Start

1. Install [git](https://git-scm.com/install/) so you can clone this repository and track your changes as you progress through the book
2. Open a terminal and clone this repository to your computer by running this command in whatever directory you want to work in (e.g. your documents directory):
   `git clone https://github.com/plaidfinch/sicp-tutoring`
4. Run `./tutor` in your terminal from the `sicp-tutoring` directory you just cloned: this installs [Claude Code](https://claude.com/product/claude-code) if needed, then guides you through setup (including [Racket/DrRacket](https://www.racket-lang.org/))
5. Open the DrRacket app for editing and running your code, pick up [the book](https://web.mit.edu/6.001/6.037/sicp.pdf), and get to work!

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
