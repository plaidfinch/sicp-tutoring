# Chapter Preparation Guide

How to prepare for tutoring a new chapter before the first session on that material.

## When to Prepare

When the student begins a new chapter, **before the first session on that chapter**, create teaching notes if they don't already exist.

## Using a Subagent

**Always use a subagent** to read and process chapter content—this keeps your main context clean for tutoring:

```
Spawn Task with subagent_type="Explore":

"Read book/text/Chapter-N.md and all section files for chapter N.
Also read book/psets/psN*/ and book/code/extracted/chN.scm.

From the perspective of a teaching assistant for the course, prepare comprehensive teaching notes for the chapter in preparation for tutoring.

<chapter_notes_template>
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
</chapter_notes_template>

Write the notes to .tutor/notes/chN/notes.md"
```

## During Tutoring

**Read your chapter notes fully** into context when tutoring that chapter—don't summarize them, read the whole file. These are your prepared materials; you should have them at hand.

If the notes already exist, no need to create them again.
