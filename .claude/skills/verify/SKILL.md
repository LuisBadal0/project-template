---
name: verify
description: Run this project and check a change the way a user would, then report the evidence. Use before saying a change is done, before committing, and when asked to verify, test or try a change.
---

# Verify a change

Passing unit tests is not enough. Run the real thing, use the changed feature
as a user would, and report what you saw.

## 1. Fast checks

TODO: The command for tests, lint and type checks (the same as `Test` in
`AGENTS.md`). Run it first; fix failures before going further.

## 2. Start the project

TODO: How to start it locally without real accounts or devices: the command,
the port or window it opens, fake data or fixtures to use, and how to tell it
is ready.

## 3. Use the change

TODO: How to drive it: browser (Chrome extension or preview), CLI commands,
API calls with curl, a simulator. List the main user flows as
"do this → expect that", so they double as the grading rubric:

- TODO: flow → expected result

Exercise the flows the change touches, plus one neighbouring flow it could
break.

## 4. Report

- What you ran and what each step showed (output, screenshots, logs with
  personal data removed).
- What you could not verify, and why.
- Put the same summary in the PR's **Checks** section.

## Rules

- Never skip a failing or flaky test, add sleeps, or retry until it passes.
  Find the cause; if you cannot, say so and leave the test failing.
- Do not change tests, CI or `REVIEW.md` to make a change pass.
- After three failed rounds of fixing, stop and ask the owner.
