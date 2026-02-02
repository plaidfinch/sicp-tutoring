# [Claude](https://claude.com/product/claude-code) is your TA for [SICP](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html)

[*Structure and Interpretation of Computer Programs (SICP)*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html) planted the seed of a love for programming languages within my heart, and to this day I'm grateful I crossed its path.

When I first took this course as a college freshman in 2012, the transformer architecture that powers modern large language models was still 5 years in the future.
As of this writing in 2026, large language models are rapidly increasing in capability for sometimes quite competent code generation.
For a student of computer science, it's never been easier to sidestep the vital process of grappling with hard problems until they yield into earned insight: an LLM can solve your homework for you, and it might often get it right, but you will have stolen from yourself the opportunity for deep knowing.

I worry a lot about the cumulative effect of this, both inside and beyond the classroom, but I also have hope that there might be a silver lining.
This project is an experiment to see what it takes to turn an always-available coding assistant into an effective tutor that, rather than detracting from learning, helps a student learn even more effectively.

This repository teaches [Claude Code](https://claude.com/product/claude-code) how to be an effective teaching assistant for SICP, based on my own experience as a TA for the course.
Because the Claude Code environment runs on the student's machine, it can read their work, run their programs, and even write its own programs in a private workspace to prepare examples and test scenarios.
The tutor is also equipped with a note-taking system that allows it to continuously learn about the student and their learning style, keeping track of struggles, insights, and patterns.

In a sense, this is an exploration to see if the time is ripe for Neal Stephenson's [Young Lady's Illustrated Primer](https://www.goodreads.com/book/show/827.The_Diamond_Age), at least writ small.

## Quick Start

If you'd like to try it yourself:

1. Install [git](https://git-scm.com/install/) so you can clone this repository and track your changes as you progress through the book
2. Open a terminal and clone this repository to your computer by running this command in whatever directory you want to work in (e.g. your documents directory):
   `git clone https://github.com/plaidfinch/sicp-tutoring`
4. Run `./tutor` in your terminal from the `sicp-tutoring` directory you just cloned: this installs Claude Code if needed, then guides you through setup (including [Racket/DrRacket](https://www.racket-lang.org/))
5. Open the DrRacket app for editing and running your code, pick up [the book](https://web.mit.edu/6.001/6.037/sicp.pdf), and get to work!

Please report any issues; I'd love to improve this tool!

## Directory Overview

- `work/` — Your code and other work for the course (git repository created by Claude on first setup).
  I recommend tracking your progressive work using `git`; Claude can help you learn to do that if you are new to
using version control.
- `.claude/skills/sicp-tutor/` — Detailed instructions teaching Claude how to be your TA
- `.tutor/` — Claude's private workspace (knowledge, notes, scratch, might contain spoilers or solutions)
- `book/` — SICP book resources (auto-fetched on first setup)

**You should do all your work in `work/`**, so Claude can see what you're doing.

Claude is instructed to never write your code for you, only to act as a teaching assistant, so from
Claude's perspective, `work/` is read-only.
