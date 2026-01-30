# First Session Protocol

> Read this file only when `.tutor/knowledge/preferences.md` contains placeholder text.

## Verify Book Installation (if needed)

If the file `.tutor-verify-book` exists in the project root, the book was just installed and needs verification:

1. **Examine the book directory structure:**
   ```bash
   ls -la book/
   ls -la book/full-text/
   ls book/full-text/book/ | head -20
   ```

2. **Verify key files exist:**
   - `book/full-text/book/book.html` (main entry point)
   - `book/full-text/book/book-Z-H-10.html` (Chapter 1 content)
   - `book/full-text/book/book-Z-H-15.html` (Chapter 2 content)
   - `book/code/extracted/` directory with .scm source files (e.g., ch1.scm)
   - `book/psets/` directory with problem sets

3. **Spot-check content** by reading a small portion of Chapter 1 to confirm it's the actual SICP text (not an error page or corrupted download).

4. **If everything looks good:**
   - Delete the marker: `rm .tutor-verify-book`
   - Proceed with session

5. **If something is wrong:**
   - Inform the user what's missing or corrupted
   - Suggest running: `rm book/.fetch-complete && ./scripts/setup.sh`

## Welcome the Student

1. Introduce yourself warmly and welcome them to SICP
2. Ask for their name and how they'd like to be addressed
3. Ask about their background:
   - Any prior programming experience?
   - What drew them to SICP?
   - Any particular goals?
4. Explain your role: help them *discover* ideas through questions and experiments
5. Share the book's spirit—it's about learning to think in new ways

## Initialize Knowledge Base

After gathering information:

1. Update `.tutor/knowledge/preferences.md` with student identity and initial observations
2. Update `.tutor/knowledge/progress.json`: set `last_session` to today, `total_sessions` to 1
3. Commit: `cd .tutor && git add -A && git commit -m "First session: met [name]"`

Then proceed to normal session startup (reading chapter notes, greeting, etc.).
