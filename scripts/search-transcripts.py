#!/usr/bin/env python3
"""Search and read SICP tutoring session transcripts.

Usage:
  # Search for keyword (returns file:line references)
  ./scripts/search-transcripts.py --grep "recursion"

  # Search with filters
  ./scripts/search-transcripts.py --grep "recursion" --text-only --context 2

  # List sessions
  ./scripts/search-transcripts.py --list

  # Read specific lines from a transcript
  ./scripts/search-transcripts.py --file .tutor/transcripts/2026-01-30-abc.jsonl --lines 40-60 --text-only

  # Read from offset with default limit
  ./scripts/search-transcripts.py --file .tutor/transcripts/2026-01-30-abc.jsonl --offset 100 --text-only
"""

import argparse
import json
import os
import re
import sys
from datetime import datetime, timedelta
from pathlib import Path

TRANSCRIPT_DIR = Path(".tutor/transcripts")
DEFAULT_LIMIT = 50
DEFAULT_SEARCH_LIMIT = 20
DEFAULT_CONTEXT = 1


def parse_duration(duration_str):
    """Parse duration like '7d', '2w', '1m' into timedelta."""
    match = re.match(r'^(\d+)([dwm])$', duration_str)
    if not match:
        raise ValueError(f"Invalid duration: {duration_str}")

    num = int(match.group(1))
    unit = match.group(2)

    if unit == 'd':
        return timedelta(days=num)
    elif unit == 'w':
        return timedelta(weeks=num)
    elif unit == 'm':
        return timedelta(days=num * 30)


def parse_line_range(range_str):
    """Parse line range like '40-60' into (start, end)."""
    match = re.match(r'^(\d+)-(\d+)$', range_str)
    if not match:
        raise ValueError(f"Invalid line range: {range_str}")
    return int(match.group(1)), int(match.group(2))


def extract_text_content(entry):
    """Extract readable text from a transcript entry."""
    entry_type = entry.get('type')
    message = entry.get('message', {})

    if entry_type == 'user':
        content = message.get('content')
        if isinstance(content, str):
            return f"[user] {content}"
        elif isinstance(content, list):
            texts = []
            for item in content:
                if isinstance(item, dict):
                    if item.get('type') == 'text':
                        texts.append(item.get('text', ''))
                    elif item.get('type') == 'tool_result':
                        # Skip tool results in text-only mode
                        pass
            if texts:
                return f"[user] {' '.join(texts)}"
        return None

    elif entry_type == 'assistant':
        content = message.get('content', [])
        if isinstance(content, list):
            texts = []
            for item in content:
                if isinstance(item, dict):
                    if item.get('type') == 'text':
                        texts.append(item.get('text', ''))
                    elif item.get('type') == 'thinking':
                        # Thinking is excluded by default
                        pass
            if texts:
                return f"[assistant] {' '.join(texts)}"
        return None

    return None


def extract_thinking_content(entry):
    """Extract thinking content from assistant entries."""
    if entry.get('type') != 'assistant':
        return None

    content = entry.get('message', {}).get('content', [])
    if isinstance(content, list):
        for item in content:
            if isinstance(item, dict) and item.get('type') == 'thinking':
                return f"[thinking] {item.get('thinking', '')}"
    return None


def is_meta_message(entry):
    """Check if entry is a meta/injected message (skill prompts, system context)."""
    return entry.get('isMeta', False)


def should_include_entry(entry, args):
    """Check if entry should be included based on filters."""
    entry_type = entry.get('type')

    # Filter meta messages (skill prompts) unless explicitly requested
    if not args.include_meta and is_meta_message(entry):
        return False

    if args.user_only and entry_type != 'user':
        return False
    if args.assistant_only and entry_type != 'assistant':
        return False
    if args.text_only and entry_type not in ('user', 'assistant'):
        return False

    return True


def format_entry(entry, line_num, filepath, args):
    """Format a transcript entry for output."""
    if args.text_only:
        text = extract_text_content(entry)
        if args.include_thinking:
            thinking = extract_thinking_content(entry)
            if thinking:
                text = f"{text}\n{thinking}" if text else thinking
        if text:
            return f"{filepath}:{line_num}: {text}"
        return None
    else:
        # Return raw JSON
        return f"{filepath}:{line_num}: {json.dumps(entry)}"


def read_transcript(filepath, args):
    """Read and filter a transcript file."""
    lines = []
    with open(filepath, 'r') as f:
        for line_num, line in enumerate(f, 1):
            line = line.strip()
            if not line:
                continue
            try:
                entry = json.loads(line)
                if should_include_entry(entry, args):
                    formatted = format_entry(entry, line_num, filepath, args)
                    if formatted:
                        lines.append((line_num, formatted))
            except json.JSONDecodeError:
                continue
    return lines


def search_transcripts(pattern, args):
    """Search all transcripts for pattern."""
    if not TRANSCRIPT_DIR.exists():
        print(f"No transcripts directory: {TRANSCRIPT_DIR}", file=sys.stderr)
        return

    results = []
    cutoff = None
    if args.since:
        cutoff = datetime.now() - parse_duration(args.since)

    for filepath in sorted(TRANSCRIPT_DIR.glob("*.jsonl"), reverse=True):
        # Check date filter
        if cutoff:
            # Extract date from filename (YYYY-MM-DD-sessionid.jsonl)
            try:
                date_str = filepath.stem[:10]
                file_date = datetime.strptime(date_str, "%Y-%m-%d")
                if file_date < cutoff:
                    continue
            except ValueError:
                pass

        lines = read_transcript(filepath, args)

        for line_num, formatted in lines:
            if re.search(pattern, formatted, re.IGNORECASE):
                results.append((str(filepath), line_num, formatted))

                if len(results) >= (args.limit or DEFAULT_SEARCH_LIMIT):
                    break

        if len(results) >= (args.limit or DEFAULT_SEARCH_LIMIT):
            break

    # Output results with context
    for filepath, line_num, formatted in results:
        print(formatted)

        if args.context and args.context > 0:
            # Read surrounding context
            all_lines = read_transcript(filepath, args)
            line_nums = [ln for ln, _ in all_lines]

            try:
                idx = line_nums.index(line_num)
                start = max(0, idx - args.context)
                end = min(len(all_lines), idx + args.context + 1)

                for i in range(start, end):
                    if i != idx:
                        print(f"  {all_lines[i][1]}")
            except ValueError:
                pass

        print()


def read_file_section(filepath, args):
    """Read a section of a transcript file."""
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}", file=sys.stderr)
        sys.exit(1)

    lines = read_transcript(filepath, args)

    if args.lines:
        start, end = parse_line_range(args.lines)
        lines = [(ln, fmt) for ln, fmt in lines if start <= ln <= end]
    elif args.offset:
        # Find lines starting at offset
        start_idx = None
        for i, (ln, _) in enumerate(lines):
            if ln >= args.offset:
                start_idx = i
                break

        if start_idx is not None:
            limit = args.limit or DEFAULT_LIMIT
            lines = lines[start_idx:start_idx + limit]
        else:
            lines = []
    else:
        # Default: first N lines
        limit = args.limit or DEFAULT_LIMIT
        lines = lines[:limit]

    for line_num, formatted in lines:
        print(formatted)


def list_sessions(args):
    """List all sessions with summaries."""
    if not TRANSCRIPT_DIR.exists():
        print(f"No transcripts directory: {TRANSCRIPT_DIR}", file=sys.stderr)
        return

    for filepath in sorted(TRANSCRIPT_DIR.glob("*.jsonl"), reverse=True):
        # Get first real user message as summary (skip meta/skill prompts)
        summary = None
        with open(filepath, 'r') as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    entry = json.loads(line)
                    if entry.get('type') == 'user' and not is_meta_message(entry):
                        text = extract_text_content(entry)
                        if text:
                            summary = text[:100] + "..." if len(text) > 100 else text
                            break
                except json.JSONDecodeError:
                    continue

        date_str = filepath.stem[:10]
        session_id = filepath.stem[11:] if len(filepath.stem) > 10 else filepath.stem

        print(f"{filepath}")
        print(f"  Date: {date_str}")
        print(f"  Session: {session_id[:8]}...")
        if summary:
            print(f"  First: {summary}")
        print()


def main():
    parser = argparse.ArgumentParser(
        description="Search and read SICP tutoring session transcripts"
    )

    # Content filtering
    parser.add_argument('--text-only', action='store_true',
                        help="Strip metadata, show only conversation text")
    parser.add_argument('--user-only', action='store_true',
                        help="Show only user messages")
    parser.add_argument('--assistant-only', action='store_true',
                        help="Show only assistant responses")
    parser.add_argument('--include-thinking', action='store_true',
                        help="Include thinking blocks (usually excluded)")
    parser.add_argument('--include-meta', action='store_true',
                        help="Include meta messages (skill prompts, injected context)")

    # Search mode
    parser.add_argument('--grep', metavar='PATTERN',
                        help="Search for pattern in transcripts")
    parser.add_argument('--since', metavar='DURATION',
                        help="Filter to recent sessions (e.g., 7d, 2w)")
    parser.add_argument('--context', '-C', type=int, default=DEFAULT_CONTEXT,
                        help=f"Lines of context around matches (default: {DEFAULT_CONTEXT})")
    parser.add_argument('--limit', '-n', type=int,
                        help=f"Max results (default: {DEFAULT_SEARCH_LIMIT} for search, {DEFAULT_LIMIT} for read)")

    # Read mode
    parser.add_argument('--file', metavar='PATH',
                        help="Read specific transcript file")
    parser.add_argument('--lines', metavar='START-END',
                        help="Read specific line range (e.g., 40-60)")
    parser.add_argument('--offset', type=int,
                        help="Start reading at line N")

    # Browsing
    parser.add_argument('--list', action='store_true',
                        help="List sessions with summaries")

    args = parser.parse_args()

    # Validate mutually exclusive options
    if args.user_only and args.assistant_only:
        parser.error("Cannot use both --user-only and --assistant-only")

    # Execute appropriate mode
    if args.list:
        list_sessions(args)
    elif args.grep:
        search_transcripts(args.grep, args)
    elif args.file:
        read_file_section(args.file, args)
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
