#!/usr/bin/env bash
# Regenerates README.md with a list of all posts sorted newest-first.
set -euo pipefail
cd "$(dirname "$0")/.."

entries=()
for file in content/posts/*/index.md; do
  title=$(sed -n 's/^title: *"\(.*\)"/\1/p' "$file")
  date=$(sed -n 's/^date: *//p' "$file")
  entries+=("${date}|${title}|${file}")
done

IFS=$'\n' sorted=($(printf '%s\n' "${entries[@]}" | sort -t'|' -k1 -r))
unset IFS

{
  echo "# Posts"
  echo ""
  for entry in "${sorted[@]}"; do
    IFS='|' read -r date title file <<< "$entry"
    echo "- [${title}](${file})"
  done
} > README.md

echo "README.md updated with ${#sorted[@]} posts."
