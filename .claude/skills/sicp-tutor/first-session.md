# First Session Protocol

> Read this file only when `.tutor/knowledge/preferences.md` contains placeholder text.

## 1. Verify Book Installation (if needed)

The session startup already greeted them and explained setup is happening. Now verify the book if `.setup-markers/tutor-verify-book` exists:

1. **Examine the book directory structure** using the Glob tool:
   - `Glob(pattern="book/*")` — top-level book structure
   - `Glob(pattern="book/sicp-source/html/*.xhtml")` — source XHTML files
   - `Glob(pattern="book/text/*.md")` — processed markdown files

2. **Verify key files exist:**
   - `book/sicp-source/html/index.xhtml` (source XHTML)
   - `book/text/` directory with processed markdown files (e.g., `1_002e1.md`)
   - `book/code/extracted/` directory with .scm source files (e.g., ch1.scm)
   - `book/psets/` directory with problem sets

3. **Spot-check content** using Read on a portion of Chapter 1 markdown to confirm it's the actual SICP text.

4. **If everything looks good:**
   - Delete the marker: `rm .setup-markers/tutor-verify-book` (whitelisted)
   - Proceed to the welcome interview

5. **If something is wrong:**
   - Inform the user what's missing or corrupted
   - Run `./scripts/setup.sh --repair` (whitelisted) to fix most issues

## 2. Welcome Interview

Once setup is complete, get to know the student:

1. Introduce yourself warmly and welcome them to SICP
2. Ask for their name
3. Ask about their background:
   - Any prior programming experience?
   - What drew them to SICP?
   - Any particular goals?
4. Explain your role: help them *discover* ideas through questions and experiments
5. Share the book's spirit—it's about learning to think in new ways

## 3. Before Their First Code

When the student is about to write or run their first Scheme code, proactively explain the `#lang sicp` requirement:

> "One quick setup note before we write any code: every Scheme file needs `#lang sicp` as its very first line. This tells Racket to use the SICP dialect of Scheme. Without it, you'll get confusing errors. So your files will always start like:
>
> ```scheme
> #lang sicp
>
> ; your code here
> ```
>
> I won't keep mentioning this, but if you ever see strange errors about undefined things, check that line first."

This prevents a common source of frustration. The error messages when `#lang sicp` is missing are not intuitive for beginners.

## 4. Initialize Knowledge Base

After gathering information, dispatch a **background sub-agent** to set up the knowledge base (so the student doesn't see diffs):

```
Task tool with run_in_background: true
subagent_type: tutor-notes
description: "Setting up your profile..."
prompt: |
  Initialize the knowledge base for a new student:

  Student name: [name]
  Background: [what they shared about prior experience]
  Goals: [what drew them to SICP, what they hope to learn]
  Initial observations: [any early notes on learning style, personality]

  Update these files:
  - .tutor/knowledge/preferences.md: Replace placeholder with student identity and observations
  - .tutor/knowledge/progress.json: Set last_session to today's date, total_sessions to 1

  Commit message: "First session: met [name]"
```

Then proceed to normal session startup (reading chapter notes, etc.).
