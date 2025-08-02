#!/bin/bash
# Compact script to add git submodules from YAML repositories file
# Usage: ./add_submodules.sh [repositories_file] [target_directory]

set -e
file="${1:-repositories.yaml}"
dir="$2"
[[ ! -f "$file" ]] && { echo "Error: File '$file' not found!"; exit 1; }
[[ -n "$dir" ]] && mkdir -p "$dir" && echo "Target: $dir"

awk '
/^  [^[:space:]]+:$/ { 
    if (repo && url && ver) print repo, url, ver
    repo = $1; gsub(/:$/, "", repo); url = ver = ""
}
/^    url:/ { url = $2 }
/^    version:/ { ver = $2 }
END { if (repo && url && ver) print repo, url, ver }
' "$file" | while read -r name url version; do
    path="$name"; [[ -n "$dir" ]] && path="$dir/$name"
    echo "Adding: $name -> $path ($version)"
    git submodule add -b "$version" "$url" "$path" || exit 1
done

echo "Added submodules"