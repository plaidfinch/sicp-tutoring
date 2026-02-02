#!/usr/bin/env python3
"""Archive session transcript to .tutor/transcripts/

Called by Stop (copy only) and PreCompact/SessionEnd (copy + commit).
"""

import json
import os
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path

def main():
    # Read hook input from stdin
    try:
        hook_input = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)

    transcript_path = hook_input.get('transcript_path')
    session_id = hook_input.get('session_id')
    hook_event = hook_input.get('hook_event_name')

    if not transcript_path or not session_id:
        sys.exit(0)

    # Ensure archive directory exists
    archive_dir = Path('.tutor/transcripts')
    archive_dir.mkdir(parents=True, exist_ok=True)

    # Copy transcript with date prefix
    date_str = datetime.now().strftime('%Y-%m-%d')
    dest = archive_dir / f'{date_str}-{session_id}.jsonl'

    if os.path.isfile(transcript_path):
        shutil.copy2(transcript_path, dest)

    # Only commit on PreCompact or SessionEnd (reduces git noise)
    if hook_event in ('PreCompact', 'SessionEnd'):
        tutor_dir = Path('.tutor')
        if (tutor_dir / '.git').exists():
            subprocess.run(
                ['git', 'add', 'transcripts/'],
                cwd=tutor_dir,
                capture_output=True
            )
            subprocess.run(
                ['git', 'commit', '-m', f'Archive transcript: {session_id}'],
                cwd=tutor_dir,
                capture_output=True
            )

if __name__ == '__main__':
    main()
