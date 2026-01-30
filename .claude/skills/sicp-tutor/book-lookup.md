# Book Lookup Guide

How to consult SICP text effectively. The full book is ~400K tokens—choose the right method for your need.

## Quick Lookups (Direct)

For fast, targeted searches, use grep and direct reads:

```bash
# Search for specific terms
grep -ri "substitution model" book/text/
grep -ri "closure" book/text/

# Read specific sections (markdown, token-efficient)
cat book/text/Chapter-1.md
cat book/text/1_002e1.md      # Section 1.1
cat book/text/1_002e2.md      # Section 1.2

# Find book code
cat book/code/extracted/ch1.scm
```

**Use quick lookups when:**
- Finding where a term is mentioned
- Reading a section you know by number
- Checking a specific exercise or code file

## Indices

Tab-separated reference files (item → location):

- `book/text/term-index.tsv` — term → section (e.g., `accumulator	2.2.3`)
- `book/text/exercises.tsv` — exercise → file (e.g., `1.11	1_002e2`)
- `book/text/figures.tsv` — figure → file (e.g., `2.5	2_002e2`)

```bash
# Find which section covers a term
grep "substitution" book/text/term-index.tsv
# → substitution model	1.1.5

# Find which file contains an exercise
grep "1.11" book/text/exercises.tsv
# → 1.11	1_002e2
```

## Deep Research (Subagent)

For understanding *how* the book explains something, spawn a research agent:

```
Spawn Task with subagent_type="Explore":

"Search book/text/ for how SICP explains [concept].
Read the most relevant section and return:
1. The key explanation (quote important wording, summarize otherwise)
2. The section number (e.g., 2.2.3)
3. Relevant code examples
4. Related exercises if mentioned"
```

**Use a subagent when:**
- Understanding how the book introduces a concept (not just *where*)
- Finding relevant examples across multiple sections
- Reading material you haven't cached in your chapter notes
- The student asks "what does the book say about X?"

**Don't use a subagent when:**
- You already have the info in your chapter notes
- You just need a specific file or section number
- The query is about student's code (in `work/`)

## Worked Example

**Student asks:** "I don't get why we need `cons`, `car`, and `cdr`. Why not just use arrays?"

**Your approach:**
1. This is conceptual—they need the book's explanation, not just a location
2. Spawn subagent: *"Search book/text/ for the introduction of cons, car, and cdr. Read where pairs are first introduced. Return: the key explanation of why Lisp uses pairs, the section number, and any important quotes about data abstraction."*
3. Subagent returns Section 2.1.1 content with the "building blocks" explanation
4. You use this to guide discussion: "The book introduces this in Section 2.1.1—have you read that? It makes an interesting point about..."

**Contrast with quick lookup:** If the student just asked "which section covers cons?", use `grep -ri "cons" book/text/` directly.

## Parallel Research

For complex questions, spawn multiple agents at once:

```
Agent 1: "Find where SICP introduces streams in book/text/"
Agent 2: "Find exercises about infinite sequences in book/text/"
Agent 3: "Search book/code/extracted/ for stream examples"
```

## Key Principles

1. **Quote when wording matters** — The book's explanations are carefully crafted; preserve them when relevant
2. **Specific queries** — "Find X" not "Read everything about Y"
3. **Always get section numbers** — So you can cite them for the student
4. **Reference for the student** — Point them to sections (e.g., "Section 1.1.5") so they can read alongside
