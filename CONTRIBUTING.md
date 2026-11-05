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

## Versions and releases

The version follows [semantic versioning](https://semver.org) and lives in the
files listed in `.github/version-files`. CI fails if they disagree.

To release, bump the version in all of those files in your pull request and end
its title with `(vX.Y.Z)`. When it merges, CI builds the project and publishes
GitHub release `vX.Y.Z` with the files from `dist/`. A version that is already
released is not published again, and `0.0.0` is never released.

## What not to commit

Credentials, tokens, keys, `.env` files, account or device data, personal
screenshots, logs with personal data, and build output. Release files belong on
GitHub Releases.
