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
