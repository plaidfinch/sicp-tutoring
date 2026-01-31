#!/usr/bin/env bash
# Commits scratch files to the .tutor repo
# Usage: ./scripts/commit-scratch.sh "description"

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <description>" >&2
    exit 1
fi

cd "$(dirname "$0")/.."
git -C .tutor add scratch/
git -C .tutor commit -m "Scratch: $1"
