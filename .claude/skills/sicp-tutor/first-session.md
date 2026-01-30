# First Session Protocol

> Read this file only when `.tutor/knowledge/preferences.md` contains placeholder text.

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
