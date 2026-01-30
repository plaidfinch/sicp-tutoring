# Session Notes Guide

Templates and guidance for maintaining continuity across tutoring sessions.

## Directory Structure

```
.tutor/
├── knowledge/
│   ├── sessions/YYYY-MM-DD-NN.md   # Session notes
│   ├── progress.json                # Curriculum position
│   ├── preferences.md               # Student style (mandatory read)
│   ├── concepts.md                  # Deep conceptual discussions
│   └── struggles.md                 # Recurring difficulties
├── notes/
│   ├── ch1/notes.md                 # Your chapter 1 preparation
│   ├── ch2/notes.md                 # Your chapter 2 preparation
│   └── ...
└── scratch/
    └── YYYY-MM-DD/                  # Daily exploration workspace
```

## Session Notes Template

**Write notes continuously** throughout the session, not just at the end. Commit at natural breakpoints.

```markdown
# Session: YYYY-MM-DD

## Topics Covered
- Sections and exercises discussed

## Key Moments
- Breakthroughs—when something clicked
- Points of confusion and how they resolved

## Exercises
- Exercise X.Y: [completed/in-progress/struggled]

## Observations
- Learning style notes (visual/verbal, abstract/concrete, pace preferences)
- What explanations or framings worked well
- Affective notes (energy level, confidence, what frustrated or delighted them)
- Personality observations (helps calibrate tone and approach over time)

## For Next Time
- Where to pick up
- Concepts to reinforce
```

## Example Entry

```markdown
# Session: 2025-01-15

## Topics Covered
- Section 1.2.1 (linear recursion), Exercise 1.9

## Key Moments
- Breakthrough: Finally saw the difference between recursive process and recursive procedure
- Stuck on tracing iterative factorial—resolved by drawing the state variables at each step

## Exercises
- Exercise 1.9: completed (both versions)
- Exercise 1.10: in-progress, understands the recurrence but struggling with the tree

## Observations
- Responds well to "what would happen if..." questions
- Drawing helps more than verbal tracing; prefers visual over abstract
- Energy dipped around 45 minutes—consider shorter sessions
- Self-deprecating when stuck—needs normalization that this is hard for everyone

## For Next Time
- Return to 1.10 with tree diagrams
- Might be ready for 1.1.7 (Newton's method)
```

**Keep it brief:** 2-3 sentences per section is enough. Focus on what you'd need to remember tomorrow.

## Tracking Recurring Struggles

When patterns recur across sessions, add to `.tutor/knowledge/struggles.md`:

```markdown
## [Pattern Name]
- **First noticed**: [Date]
- **Contexts**: [Where it appeared]
- **Nature**: [What's actually being misunderstood]
- **What helped**: [Approaches that worked]
- **Status**: [Active/Improving/Resolved]
```

**Example:**

```markdown
## Recursion vs. Iteration Confusion

- **First noticed**: 2025-01-10
- **Contexts**: Exercise 1.9, factorial, Fibonacci
- **Nature**: Conflates "recursive procedure" with "recursive process." Thinks iteration requires loops.
- **What helped**: Drawing the substitution model for both; emphasizing that the *shape of the process* matters, not the syntax.
- **Status**: Improving—correctly identified iterative process in 1.16
```

## Git Discipline

**Commit every change** to the .tutor repo:

```bash
git -C .tutor add -A
git -C .tutor commit -m "Description"
```

Sessions may end without warning. Write notes as you go, commit frequently.
