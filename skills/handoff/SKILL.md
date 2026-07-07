---
name: handoff
description: Compact the current conversation into a handoff document for a fresh agent to pick up. Run manually via /handoff when the context window gets large or before switching sessions.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work.

**There is only ever one handoff document** — overwrite a fixed path so old handoffs never accumulate. Save it to the system temp directory as `claude-handoff.md`, picking the syntax for the current shell:

- **PowerShell / Windows**: `"$env:TEMP\claude-handoff.md"`
- **Bash / POSIX**: `"${TMPDIR:-/tmp}/claude-handoff.md"`

Overwriting replaces the previous handoff. If any older timestamped `handoff-*.md` files linger from a prior scheme, delete them so only `claude-handoff.md` remains. The `/prime` skill reads this file when a fresh session starts.

Suggest the skills to be used, if any, by the next session.

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.