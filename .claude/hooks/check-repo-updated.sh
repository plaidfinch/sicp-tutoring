#!/bin/bash
# SessionStart hook: Re-run setup if repo has been updated
# Compares current commit hash against stored marker

MARKER_FILE=".setup-markers/last-setup-commit"
CURRENT_COMMIT=$(git rev-parse HEAD 2>/dev/null)

if [[ -z "$CURRENT_COMMIT" ]]; then
    # Not a git repo or git not available
    echo '{}'
    exit 0
fi

if [[ -f "$MARKER_FILE" ]]; then
    LAST_COMMIT=$(cat "$MARKER_FILE")
    if [[ "$CURRENT_COMMIT" == "$LAST_COMMIT" ]]; then
        # No change
        echo '{}'
        exit 0
    fi
fi

# Repo has been updated - run setup
echo "Repo updated, re-running setup..." >&2
./scripts/setup.sh >&2

# Update marker
mkdir -p "$(dirname "$MARKER_FILE")"
echo "$CURRENT_COMMIT" > "$MARKER_FILE"

echo '{}'
exit 0
