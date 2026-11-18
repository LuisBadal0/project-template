#!/usr/bin/env bash
# PostToolUse hook: format each file right after Claude edits it, so formatting
# never reaches review. The edited file's path is passed as the last argument.
set -u

FORMAT_COMMAND="" # TODO: e.g. "npx prettier --write", "ruff format", "rustfmt"

[ -z "$FORMAT_COMMAND" ] && exit 0

input=$(cat)
file=$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | sed 's/\\\\/\\/g')
[ -n "$file" ] && [ -f "$file" ] || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

if ! output=$(bash -c "$FORMAT_COMMAND \"\$1\"" _ "$file" 2>&1); then
  {
    echo "Formatting failed for $file ($FORMAT_COMMAND):"
    printf '%s\n' "$output" | tail -n 30
  } >&2
  exit 2
fi
exit 0
