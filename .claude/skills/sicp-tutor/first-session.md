# First Session Protocol

> Read this file only when `.tutor/knowledge/preferences.md` contains placeholder text.

## 1. Verify Book Installation (if needed)

The session startup already greeted them and explained setup is happening. Now verify the book if `.tutor-verify-book` exists:

1. **Examine the book directory structure:**
   ```bash
   ls -la book/
   ls -la book/sicp-source/html/ | head -10
   ls book/text/ | head -20
   ```

2. **Verify key files exist:**
   - `book/sicp-source/html/index.xhtml` (source XHTML)
   - `book/text/` directory with processed markdown files (e.g., `1_002e1.md`)
   - `book/code/extracted/` directory with .scm source files (e.g., ch1.scm)
   - `book/psets/` directory with problem sets

3. **Spot-check content** by reading a small portion of Chapter 1 markdown to confirm it's the actual SICP text (not an error page or corrupted conversion).

4. **If everything looks good:**
   - Delete the marker: `rm .tutor-verify-book`
   - Proceed to the welcome interview

5. **If something is wrong:**
   - Inform the user what's missing or corrupted
   - For submodule issues: `git submodule update --init book/sicp-source`
   - For markdown issues: `rm book/text/.processed` then `./scripts/setup.sh`
   - For MIT content: `rm book/.mit-fetched` then `./scripts/setup.sh`

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

## 3. Initialize Knowledge Base

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
