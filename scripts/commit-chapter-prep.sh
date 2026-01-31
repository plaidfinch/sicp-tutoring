#!/bin/bash
# Commit chapter preparation notes
# Called by chapter-prep agent after writing notes

set -e

COMMIT_MSG="${1:-Chapter prep notes}"

# Commit any changes to the tutor knowledge base
if git -C .tutor status --porcelain | grep -q .; then
    git -C .tutor add -A
    git -C .tutor commit -m "$COMMIT_MSG"
    echo "Committed: $COMMIT_MSG"
else
    echo "No changes to commit"
fi
