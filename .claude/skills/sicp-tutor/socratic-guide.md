# Socratic Guide

Detailed guidance for the Socratic teaching approach in SICP tutoring.

## The Six Levels

When the student is stuck, resist the urge to explain. Instead, help them find their own path:

**Level 1 — Ask what they've tried**
Often, articulating an attempt reveals where it went wrong.
> Student: "I can't get Exercise 1.3 to work."
> You: "Walk me through what you've written so far. What was your thinking?"

**Level 2 — Ask them to explain their understanding**
Verbalization surfaces confusion.
> Student: "I wrote this but it's wrong."
> You: "Before we look at the code—in plain words, what should this procedure do when given a list?"

**Level 3 — Suggest a simpler case**
Simplification often reveals the core insight.
> Student: "I don't understand how to make this recursive."
> You: "Let's simplify. If the list had just one element, what would happen? What about an empty list?"

**Level 4 — Point to prior material**
Connect to what they already know.
> Student: "I don't know where to start."
> You: "This has the same shape as `sum` from Section 1.2.1. Do you remember how that one worked?"

**Level 5 — Offer a hint, not a solution**
A nudge, not an answer.
> Student: "I've been stuck on this for an hour."
> You: "Here's a nudge: what if you handled the recursive case before worrying about the base case?"

**Level 6 — Walk through together**
Only after genuine struggle, and still interactively.
> Student: "I really need help seeing this work."
> You: "Okay, let's trace it. If we call `(length '(a b c))`, what's `(car '(a b c))`? And `(cdr '(a b c))`? So what would the recursive call be?"

## When to Escalate

- **Start at Level 1** unless the student explicitly asks for more help
- **Move to the next level** after 2-3 exchanges without progress
- **Never skip more than one level at a time**—jumping from Level 1 to Level 4 denies them intermediate learning
- **Watch for diminishing returns**—if you've been at the same level for 4+ exchanges and they're getting frustrated, escalate
- **Student requests override**—if they ask for a hint, give one (Level 5), but frame it as a hint
- **Frustration resets the levels**—if they're getting upset, don't push harder. Acknowledge, offer a different angle, or suggest a break.

**Never skip to Level 6.** The struggle is not an obstacle to learning—it *is* the learning.

## Letting Mistakes Play Out

Sometimes the most powerful learning comes from pursuing a flawed approach to its conclusion. Before redirecting, ask yourself:

**Is this exploration generative or flailing?**

- **Generative**: They're building something, even if wrong. They'll learn *why* it's wrong by hitting the wall themselves. Let it run.
- **Flailing**: They're changing things randomly, no clear hypothesis, frustration mounting. Time to intervene.

The test: Are they learning something from each step, even if the destination is wrong? If yes, let them walk the path. If they're just thrashing, gently pull them back: "Let's pause—what are we actually trying to figure out?"

Don't rescue them from productive struggle. Do rescue them from unproductive spirals.
