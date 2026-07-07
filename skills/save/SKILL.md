---
name: save
description: Commits and pushes the current work with an approved, past-tense conventional-commit message (no Claude attribution), then writes a handoff if the session has unfinished work. Run manually via /save.
disable-model-invocation: true
---

# Save

Checkpoint the current work: verify, commit with an approved message, push safely,
and hand off if needed. Run on demand via `/save`. Deliberate and manual — it writes
to the remote.

## 1. Preflight

- **No git repo** → stop; offer to `git init` (don't auto-init).
- **Detached HEAD** → warn and stop (nowhere sensible to push).

## 2. Staging

- If the user has **already staged** a subset, respect it — commit only what's staged.
- If **nothing is staged**, stage everything: `git add -A` (tracked edits + untracked).
- Remember the prior staging state so a cancel can restore it exactly.
- If the tree is **clean** (nothing to commit), report "nothing to save" — no empty
  commit — then skip to the Handoff step in case work is still pending.

## 3. Verify (report, never block)

Run the project's checks if it defines them (test / typecheck / lint — discover from
its `CLAUDE.md` or scripts). Capture pass/fail. **Never block on failure** — surface
the result in the approval step so the user commits knowingly. If checks are slow,
note it and let the user skip them for this run.

## 4. Compose the message

Generate it **from the staged diff**, not from memory:

- Format: conventional prefix + **past-tense** summary — e.g. `feat: added
  swipe-to-delete on saved cards`. Include a scope when obvious (`feat(saved): …`).
- Subject line ≤ ~72 chars. Add a short **why**-focused body only when the change
  isn't self-explanatory.
- Pick the type from the change: `feat` / `fix` / `chore` / `refactor` / `docs` /
  `test`, etc.
- **No attribution** — no "authored by Claude," no generated-with footer.

## 5. Approve (explicit)

Show: the message, the file list being committed, and the Verify status. The user may:

- **approve** — a clear yes; anything ambiguous is not approval.
- **request changes** — revise and re-present.
- **supply their own wording** — use it verbatim.
- **cancel** — restore the prior staging state, make no commit. No side effects.

One approval authorizes **both commit and push** (except the default-branch confirm below).

## 6. Commit + push

- Commit with the approved message.
- Push the current branch to its upstream. If no upstream: `git push -u origin <branch>`.
- **Default-branch guard**: if on `main`/`master`, ask one extra confirm ("push
  directly to `master`?") before pushing. Feature branches push with no extra prompt.
- **Never force-push.** If the push is rejected because the branch is behind the remote
  (non-fast-forward), **stop and report** — let the user pull/rebase; never auto-rebase
  or `--force`.
- **No remote configured** → keep the local commit; skip push with a warning.

## 7. Handoff (if necessary)

After a successful push, judge whether the session has **unfinished work or known next
steps**. If so, write a handoff and notify the user (`wrote handoff for next session:
<focus>`); if the work is a complete unit with nothing pending, skip.

Inline the single-doc convention directly (the `handoff` skill can't be invoked
programmatically): overwrite `$env:TEMP\claude-handoff.md` (PowerShell) or
`${TMPDIR:-/tmp}/claude-handoff.md` (bash), replacing any previous handoff. Reference
the commit just pushed, describe what's left, and suggest skills for the next session.
