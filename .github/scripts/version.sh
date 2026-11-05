#!/usr/bin/env bash
# Prints the project version after checking that every file listed in
# .github/version-files holds the same one. Exits non-zero otherwise.
# Run from the repository root: bash .github/scripts/version.sh
set -euo pipefail

list=.github/version-files
[ -f "$list" ] || { echo "::error::$list is missing" >&2; exit 1; }

read_version() {
  local file=$1
  case "$file" in
    *.json)
      if command -v jq >/dev/null; then
        jq -r '.version // empty' "$file"
      else
        sed -n 's/^[[:space:]]*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$file" | head -n 1
      fi ;;
    *.toml)
      sed -n 's/^version[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' "$file" | head -n 1 ;;
    *.py)
      sed -n "s/^__version__[[:space:]]*=[[:space:]]*[\"']\([^\"']*\)[\"'].*/\1/p" "$file" | head -n 1 ;;
    *)
      grep -m 1 -v '^[[:space:]]*$' "$file" | tr -d '[:space:]' ;;
  esac
}

version=""
first=""
status=0
while IFS= read -r line || [ -n "$line" ]; do
  file=$(printf '%s' "$line" | tr -d '\r' | sed 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//')
  [ -n "$file" ] || continue
  if [ ! -f "$file" ]; then
    echo "::error::$file is listed in $list but does not exist" >&2; status=1; continue
  fi
  found=$(read_version "$file" | tr -d '\r')
  if [ -z "$found" ]; then
    echo "::error::No version found in $file" >&2; status=1; continue
  fi
  echo "$file: $found" >&2
  if [ -z "$version" ]; then
    version=$found; first=$file
  elif [ "$found" != "$version" ]; then
    echo "::error::$file has $found but $first has $version" >&2; status=1
  fi
done < "$list"

[ -n "$version" ] || { echo "::error::$list lists no files" >&2; exit 1; }
[ "$status" -eq 0 ] || exit 1
if ! printf '%s' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+([-+][0-9A-Za-z.+-]+)?$'; then
  echo "::error::$version is not a semantic version (X.Y.Z)" >&2; exit 1
fi
echo "$version"
