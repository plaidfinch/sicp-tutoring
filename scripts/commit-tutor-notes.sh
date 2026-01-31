#!/bin/bash
# Commit all tutor knowledge changes and reset the notes reminder timer
# Called by tutor-notes agent after updating knowledge files

set -e

MARKER_FILE=".last-notes-reminder"
COMMIT_MSG="${1:-Session notes update}"

# Commit any changes to the tutor knowledge base
if git -C .tutor status --porcelain | grep -q .; then
    git -C .tutor add -A
    git -C .tutor commit -m "$COMMIT_MSG"
    echo "Committed: $COMMIT_MSG"
else
    echo "No changes to commit"
fi

# Touch marker to reset reminder timer
touch "$MARKER_FILE"
