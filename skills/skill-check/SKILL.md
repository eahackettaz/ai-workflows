---
name: skill-check
description: Lists the user's installed skills and how each is invoked (auto-triggered vs manual /name only). Run manually via /skill-check.
disable-model-invocation: true
---

# Skill Check

List the user's installed skills and how each one is invoked. Runs on demand via
`/skill-check`.

Why a filesystem scan: the skill listing already in context only contains
*auto-invocable* skills — anything with `disable-model-invocation: true` is hidden
from the model. Reading the `SKILL.md` files is the only way to see them all.

## Steps

1. **Find skills.** Glob for `SKILL.md` under:
   - Personal: `~/.claude/skills/`
   - Project: `.claude/skills/` (only if the current repo has one)
2. **Read only the frontmatter** of each: `name` (fall back to the folder name),
   `description`, and the invocation flags `disable-model-invocation` and
   `user-invocable`.
3. **Classify each:**
   - **Auto-invoked** — Claude can trigger it from its description (no
     `disable-model-invocation: true`).
   - **Manual only** — runs only via `/name` (`disable-model-invocation: true`).
   - **Hidden from the / menu** — `user-invocable: false` (note it alongside).
4. Track the source (personal vs project) for each.

## Output

Two tables — **Auto-invoked** and **Manual only** — each row: `name` · source
(personal/project) · **a short one-line description of what the skill does**
(summarized from its `description` field — always include it). Sort
alphabetically; put a count at the top of each table.

If the user also wants bundled/plugin skills, surface the ones visible in this
session's skill listing — but note that manual bundled skills won't appear there,
so the filesystem scan above is authoritative only for the user's own
personal/project skills.

Keep it scannable.
