#!/bin/bash
# UserPromptSubmit hook: Remind tutor to consider updating session notes
# Checks marker file age - marker is touched by scripts/commit-tutor-notes.sh

STALE_THRESHOLD=300  # 5 minutes
MARKER_FILE=".last-notes-reminder"

current_time=$(date +%s)

# Check marker file age (or if it doesn't exist)
if [[ -f "$MARKER_FILE" ]]; then
    marker_mtime=$(stat -f %m "$MARKER_FILE" 2>/dev/null || stat -c %Y "$MARKER_FILE" 2>/dev/null)
    age=$((current_time - marker_mtime))
    if [[ "$age" -lt "$STALE_THRESHOLD" ]]; then
        echo '{}'
        exit 0
    fi
fi

# Marker is stale or missing - inject reminder
cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"[session notes reminder]"}}
EOF

exit 0
