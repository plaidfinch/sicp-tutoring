#!/bin/bash
# Archive session transcript to .tutor/transcripts/
# Called by Stop (copy only) and PreCompact/SessionEnd (copy + commit)

INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name')

ARCHIVE_DIR=".tutor/transcripts"
mkdir -p "$ARCHIVE_DIR"

DATE=$(date +%Y-%m-%d)
DEST="$ARCHIVE_DIR/${DATE}-${SESSION_ID}.jsonl"

# Always copy (keeps file current)
if [[ -f "$TRANSCRIPT_PATH" ]]; then
    cp "$TRANSCRIPT_PATH" "$DEST"
fi

# Only commit on PreCompact or SessionEnd (reduces git noise)
if [[ "$HOOK_EVENT" == "PreCompact" || "$HOOK_EVENT" == "SessionEnd" ]]; then
    cd .tutor
    git add transcripts/
    git commit -m "Archive transcript: $SESSION_ID" --allow-empty 2>/dev/null || true
fi

exit 0
