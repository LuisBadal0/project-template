#!/usr/bin/env bash
# Stop hook: when Claude finishes a turn that left changes in the working tree,
# run the project's fast checks. If they fail, Claude is sent back to fix them.
# After MAX_ROUNDS failed rounds in a session it is allowed to stop, and must
# report the failure to the owner instead of trying again.
#
# Set CHECK_COMMAND to the project's fast checks (tests, lint, type check).
# Keep it under a minute; slow end-to-end suites belong in the verify skill.
set -u

CHECK_COMMAND="" # TODO: e.g. "npm test", "python -m pytest -q", "cargo test"
MAX_ROUNDS=3

[ -z "$CHECK_COMMAND" ] && exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

# Nothing changed in this turn: nothing to check.
[ -z "$(git status --porcelain 2>/dev/null)" ] && exit 0

input=$(cat)
session=$(printf '%s' "$input" | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
counter="${TMPDIR:-/tmp}/claude-checks-${session:-unknown}"

if output=$(bash -c "$CHECK_COMMAND" 2>&1); then
  rm -f "$counter"
  exit 0
fi

rounds=$(( $(cat "$counter" 2>/dev/null || echo 0) + 1 ))
echo "$rounds" > "$counter"

if [ "$rounds" -ge "$MAX_ROUNDS" ]; then
  rm -f "$counter"
  echo "Checks still fail after $rounds rounds. Stop and tell the owner what fails and what you tried." >&2
  exit 0
fi

{
  echo "Checks failed ($CHECK_COMMAND), round $rounds of $MAX_ROUNDS. Fix the cause; do not skip, retry or weaken tests."
  printf '%s\n' "$output" | tail -n 60
} >&2
exit 2
