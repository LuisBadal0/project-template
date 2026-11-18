# Review guide

What a reviewer (person or agent) checks in every pull request. Reviews use the
copy of this file on `main`; a pull request that edits it does not change how
that same pull request is reviewed.

## Focus

- Correctness: does the change do what the PR says, including edge cases and
  error paths?
- Evidence: does **Checks** show the change was run, not only that unit tests
  pass? Say so when it was not.
- Tests: are new behaviours covered, preferably by a test that uses the feature
  as a user would? Were any tests weakened, skipped or deleted, and is the
  reason stated?
- Secrets and privacy: no credentials, account data, device identifiers or
  personal data in code, fixtures, logs or screenshots.
- Scope: one focused change; `CHANGELOG.md` updated if users notice it.

TODO: Add project-specific rules here as they come up, each one something a
reviewer can see in a diff, such as "UI code never calls the network directly".

## Findings

Tag each finding:

- **Important**: must be fixed before merging.
- **Nit**: optional improvement.
- **Pre-existing**: a problem the change did not introduce.

## Review rounds

If a pull request reaches a third round of review on the same problems, stop
listing findings and recommend rethinking the approach instead.

## Keep it short

When a review misses a bug that later breaks something, add a rule above. Remove
rules that no longer catch anything.
