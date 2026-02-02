#!/usr/bin/env python3
"""Commit any uncommitted transcripts from unclean exits."""

import subprocess
from pathlib import Path

def main():
    tutor_dir = Path('.tutor')
    transcripts_dir = tutor_dir / 'transcripts'

    if not (tutor_dir / '.git').exists():
        return

    if not transcripts_dir.exists():
        return

    # Check if there are uncommitted transcript files
    result = subprocess.run(
        ['git', 'status', '--porcelain', 'transcripts/'],
        cwd=tutor_dir,
        capture_output=True,
        text=True
    )

    if result.stdout.strip():
        # There are uncommitted files
        subprocess.run(
            ['git', 'add', 'transcripts/'],
            cwd=tutor_dir,
            capture_output=True
        )
        subprocess.run(
            ['git', 'commit', '-m', 'Archive transcripts from previous session (unclean exit)'],
            cwd=tutor_dir,
            capture_output=True
        )

if __name__ == '__main__':
    main()
