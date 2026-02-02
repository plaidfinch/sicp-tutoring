#!/bin/bash
# Commit any uncommitted transcripts from unclean exits

cd .tutor 2>/dev/null || exit 0

# Check if there are uncommitted transcript files
if git status --porcelain transcripts/ 2>/dev/null | grep -q .; then
    git add transcripts/
    git commit -m "Archive transcripts from previous session (unclean exit)" 2>/dev/null || true
fi

exit 0
