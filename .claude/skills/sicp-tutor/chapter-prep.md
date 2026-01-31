# Chapter Preparation Guide

How to prepare for tutoring a new chapter before the first session on that material.

## When to Prepare

When the student begins a new chapter, **before the first session on that chapter**, create teaching notes if they don't already exist.

## Using a Subagent

**Always use the `chapter-prep` subagent** to read and process chapter content—this keeps your main context clean for tutoring. The agent will read the book, write notes, and commit them automatically.

```
Task tool with run_in_background: true
subagent_type: chapter-prep
description: "Preparing chapter N notes..."
prompt: |
  Read book/text/Chapter-N.md and all section files for chapter N.
  Also read book/psets/psN*/ and book/code/extracted/chN.scm if they exist.

  The student is: [brief description of student background and where they are]

  Prepare comprehensive teaching notes using this template:

  # Chapter N: [Title]

  ## Key Ideas
  - The central concepts and why they matter
  - Connections to earlier/later material

  ## Potential Stumbling Blocks
  - Where students typically get confused
  - Subtle distinctions to watch for
  - Prerequisites to verify

  ## Exercises Worth Emphasizing
  - Which exercises are most illuminating
  - Which build crucial skills
  - Which can be skipped if time is short

  ## Demonstrations I Can Prepare
  - Small examples that illuminate key points
  - "What if we tried..." experiments

  ## My Understanding
  - Notes to myself about the material
  - Anything I want to remember when helping

  ## Connections
  - How this chapter connects to future material
  - How this chapter connects to previous material

  Write the notes to .tutor/notes/chN/notes.md and commit.
```

The agent will read the chapter materials, write notes to `.tutor/notes/chN/notes.md`, and commit them.

## During Tutoring

**Read your chapter notes fully** into context when tutoring that chapter—don't summarize them, read the whole file. These are your prepared materials; you should have them at hand.

If the notes already exist, no need to create them again.
