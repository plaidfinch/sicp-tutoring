#!/bin/bash
# Clear a setup marker by name
# Usage: ./scripts/clear-marker.sh <marker-name>

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <marker-name>" >&2
    exit 1
fi

marker="$1"
marker_path=".setup-markers/$marker"

if [[ ! -f "$marker_path" ]]; then
    echo "Marker does not exist: $marker" >&2
    exit 1
fi

rm "$marker_path"
echo "Cleared marker: $marker"
