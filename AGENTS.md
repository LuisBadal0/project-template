# Agent instructions

## Workflow

- Never commit to `main`. Branch from `main` as `feature/`, `fix/`, `chore/` or
  `docs/` plus a lowercase, hyphenated name. Keep one focused change per branch.
- Open a pull request using the template (Changes, Checks, Version). Merge only
  when the owner asks; merges are squash merges.
- Releases are batched. A PR that changes what users get adds a bullet under
  **Unreleased** in `CHANGELOG.md` and keeps the version.
- Release only when the owner asks: a release PR on `chore/release-x.y.z`,
  titled `Release x.y.z (vx.y.z)`, bumps every file in `.github/version-files`
  and renames **Unreleased** to `[x.y.z] - YYYY-MM-DD`, with a new, empty
  **Unreleased** above it. Merging it publishes the release, with that section
  as its notes.
- Never commit secrets, account data or build output.

## Verification

- Before saying a change is done, use the `verify` skill
  (`.claude/skills/verify/SKILL.md`): run the fast checks, then run the project
  and use the change as a user would. Report what you ran and what it showed in
  the PR's **Checks** section, including what was not verified.
- Prefer tests that use the feature end to end. For code with clear rules
  (parsing, encoding, money, migrations), add property tests.
- Never skip a failing or flaky test, add sleeps, or retry until it passes. If
  you cannot find the cause, say so.
- A change never edits its own checks: do not change tests, CI, hooks or
  `REVIEW.md` to make it pass. Changes to them get their own PR.
- After three failed rounds of fixing the same problem, stop and ask the owner.
- Reviews follow `REVIEW.md`.

## Project

TODO: One paragraph on what this project is and how it is structured.

## Commands

| Task  | Command |
|-------|---------|
| Setup | TODO    |
| Run   | TODO    |
| Test  | TODO    |
| Build | TODO    |

## Version files

TODO: The files that hold the version (the same list as `.github/version-files`).

## Project rules

TODO: Things an agent must know here, such as "tests never contact the real
service" or "UI changes stay on the main thread". Delete this section if there
are none.
