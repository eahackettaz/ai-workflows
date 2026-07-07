---
name: prime
description: Primes a fresh session with a project's current state — reads the project docs, inspects git, and picks up any pending handoff — then briefs the user on where things stand and what to do next. Use at the start of a new chat, or when the user says "prime", "catch me up", "where were we", "orient me", or "resume".
---

# Prime

Get oriented in a project at the start of a fresh session. Produce a short
briefing, not a data dump — the goal is a working mental model and a clear next
step.

## Steps

Run these, skipping any that don't apply, then synthesize (don't narrate each one):

1. **Static project facts.** CLAUDE.md is already auto-loaded — lean on it. Also
   skim `README.md` and, if present, `CONTEXT.md` / `CONTEXT-MAP.md` and
   `docs/adr/` for domain language and locked decisions.
2. **Live git state.** Current branch, `git status` (uncommitted/staged work), and
   the last few commits (`git log --oneline -5`). This is what CLAUDE.md can't
   tell you: what's actually in flight right now.
3. **Pending handoff.** Read the single handoff doc if it exists —
   `$env:TEMP\claude-handoff.md` (PowerShell) or `${TMPDIR:-/tmp}/claude-handoff.md`
   (bash). It records what the previous session was doing and intended to do next.
   If none exists, say so and move on.
4. **Reconcile.** Cross-check the handoff against live git state — a handoff can be
   stale (work already landed, branch moved on). Flag any mismatch rather than
   trusting the doc blindly.

## Output

A tight, scannable briefing:

- **What this project is** — one or two lines.
- **Where it stands** — current branch, uncommitted work, what the last commits did.
- **In flight** — what the handoff says was underway and what's next (or "no
  pending handoff").
- **Suggested next step** — and any skill that fits it (e.g. `/tdd`, `/diagnose`,
  `/grill-with-docs`).

End by asking the user what they want to tackle.
