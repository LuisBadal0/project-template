# Contributing

## Set up

TODO: Required tools and versions, then the commands to install dependencies
from the lockfile.

## Run

TODO: How to start the project locally, and how to preview it without real
accounts or devices if that applies.

## Test

TODO: The command that runs all checks. Run it before opening a pull request.

## Branches and pull requests

- Branch from `main`: `feature/<name>`, `fix/<name>`, `chore/<name>` or
  `docs/<name>`, lowercase and hyphenated. One focused change per branch.
- Open a pull request and fill in the template: **Changes**, **Checks** and
  **Version**. CI must pass. Pull requests are squash-merged and the branch is
  deleted.
- If users will notice the change, add a bullet under **Unreleased** in
  `CHANGELOG.md`, written for them, under **Added**, **Changed**, **Fixed** or
  **Removed**. Leave the version alone.

## Versions and releases

The version follows [semantic versioning](https://semver.org) and lives in the
files listed in `.github/version-files`. CI fails if they disagree.

Releases are batched. When the maintainer decides to release, a separate pull
request on `chore/release-x.y.z`, titled `Release x.y.z (vx.y.z)`:

- picks MAJOR, MINOR or PATCH from everything under **Unreleased**;
- bumps the version in all of those files;
- renames **Unreleased** to `[x.y.z] - YYYY-MM-DD` and adds a new, empty
  **Unreleased** above it.

When it merges, CI builds the project and publishes GitHub release `vX.Y.Z` with
the files from `dist/`. Its notes are the version's `CHANGELOG.md` section,
followed by GitHub's list of merged pull requests. CI fails when the current
version has no dated section with at least one bullet
(`.github/scripts/release-notes.sh`). A version that is already released is not
published again, and `0.0.0` is never released. For an urgent fix, open the
release pull request right after the fix merges.

## What not to commit

Credentials, tokens, keys, `.env` files, account or device data, personal
screenshots, logs with personal data, and build output. Release files belong on
GitHub Releases.
