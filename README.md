# ai-workflows

A portable set of **agent skills** and workflow conventions. Built in Claude Code,
usable in GitHub Copilot and any other tool that follows the
[Agent Skills](https://agentskills.io) `SKILL.md` open standard (Copilot adopted it
in Dec 2025).

## What's here

- **`skills/`** — agent skills, each a `SKILL.md` folder. Standard format, so they
  load in Claude Code and GitHub Copilot (VS Code / CLI / cloud agent / code review),
  and other Agent-Skills-compatible tools.
- **`ADOPT.md`** — a copy-paste prompt to hand an agent (e.g. GitHub Copilot). Given
  this repo's URL, it inventories the skills and grills you on which to
  **adopt / change / leave out** for your environment, then installs the ones you approve.

## Using it

**Claude Code** — copy or symlink `skills/*` into `~/.claude/skills/` (personal) or a
repo's `.claude/skills/` (project).

**GitHub Copilot** — Copilot reads agent skills from `~/.copilot/skills/`,
`~/.claude/skills/`, or a repo's `.github/skills/` (and `.claude/skills/`). Copy
`skills/*` into one of those for a straight port, **or** run `ADOPT.md` to adopt
selectively and adapt to this environment.

**Selective adoption** — open `ADOPT.md`, paste it to your agent with this repo's URL,
and follow the interview.

## Environment adaptation notes

- This repo assumes Claude Code conventions in some skills. In Copilot, the
  always-on instructions file is `.github/copilot-instructions.md` (repo, team-shared)
  or personal custom instructions — **not** `CLAUDE.md`. Skills that read/write
  `CLAUDE.md` (`bootstrap`, `prime`) should target the local equivalent.
- Replace any `${CLAUDE_SKILL_DIR}` reference with a relative path in non-Claude tools.

## Skills

**Auto-invoked:** `bootstrap`, `caveman`, `diagnose`, `grill-with-docs`,
`improve-codebase-architecture`, `prime`, `skill-scout`, `tdd`, `write-a-skill`

**Manual (`/name` only):** `grill-me`, `handoff`, `save`, `skill-check`, `zoom-out`
