#!/usr/bin/env bash
# SessionStart hook: install the project's dependencies when a session starts,
# so local and cloud sessions (where ~/.claude is not available) begin ready.
# Install from the lockfile. Start services here too if the project needs them;
# cloud environments cache files, not running processes.
set -u

SETUP_COMMAND="" # TODO: e.g. "npm ci", "pip install -r requirements.txt --require-hashes"

[ -z "$SETUP_COMMAND" ] && exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

if ! output=$(bash -c "$SETUP_COMMAND" 2>&1); then
  # Printed to stdout so Claude sees it as session context.
  echo "Project setup failed ($SETUP_COMMAND). Fix it before other work:"
  printf '%s\n' "$output" | tail -n 30
fi
exit 0
