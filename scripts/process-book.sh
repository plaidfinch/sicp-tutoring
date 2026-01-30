#!/bin/bash
# Convert XHTML book chapters to markdown using pandoc

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SRC="$PROJECT_DIR/book/sicp-source/html"
DEST="$PROJECT_DIR/book/text"

mkdir -p "$DEST"

# Files to skip (navigation/index files not useful for tutoring)
SKIP_FILES="Term-Index Figures Exercises index"

# Process each chapter file
for xhtml in "$SRC"/*.xhtml; do
    [ -f "$xhtml" ] || continue
    name=$(basename "$xhtml" .xhtml)

    # Skip navigation/index files
    if echo "$SKIP_FILES" | grep -qw "$name"; then
        echo "  Skipping $name (index/navigation)"
        continue
    fi

    echo "  Converting $name..."
    pandoc "$xhtml" \
        --from=html \
        --to=markdown \
        --wrap=none \
        --strip-comments \
        -o "$DEST/$name.md"
done

echo "Processed $(ls "$DEST"/*.md 2>/dev/null | wc -l | tr -d ' ') markdown files"

# === Extract compact indices ===
echo "  Extracting indices..."

# Term-Index: term<TAB>section
sed -n 's/.*<td[^>]*><a[^>]*>\([^<]*\)<\/a>:<\/td>.*<td[^>]*><a[^>]*>\([^<]*\)<\/a>.*/\1\t\2/p' \
    "$SRC/Term-Index.xhtml" > "$DEST/term-index.tsv"
echo "    term-index.tsv: $(wc -l < "$DEST/term-index.tsv" | tr -d ' ') entries"

# Exercises: exercise<TAB>file (e.g., "1.1<TAB>1_002e1")
grep -oE '<a href="([^"]+)#Exercise[^"]*">([0-9.]+)</a>' "$SRC/Exercises.xhtml" | \
    sed 's/<a href="\([^#]*\)#[^"]*">\([^<]*\)<\/a>/\2\t\1/' | \
    sed 's/\.xhtml$//' > "$DEST/exercises.tsv"
echo "    exercises.tsv: $(wc -l < "$DEST/exercises.tsv" | tr -d ' ') entries"

# Figures: figure<TAB>file
grep -oE '<a href="([^"]+)#Figure[^"]*">([0-9.]+)</a>' "$SRC/Figures.xhtml" | \
    sed 's/<a href="\([^#]*\)#[^"]*">\([^<]*\)<\/a>/\2\t\1/' | \
    sed 's/\.xhtml$//' > "$DEST/figures.tsv"
echo "    figures.tsv: $(wc -l < "$DEST/figures.tsv" | tr -d ' ') entries"

echo "Done"
