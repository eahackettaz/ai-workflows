# ai-workflows

A portable set of **agent skills** and workflow conventions. Built in Claude Code,
usable in GitHub Copilot and any other tool that follows the
[Agent Skills](https://agentskills.io) `SKILL.md` open standard (Copilot adopted it
in Dec 2025).

## Quick setup, use, and updates

### 1) Set up once

Clone this repo, then install skills and scripts:

```powershell
# install skills globally for Copilot
copy -Recurse -Force skills\* "$HOME\.copilot\skills\"

# optional: install skills globally for Claude Code too
copy -Recurse -Force skills\* "$HOME\.claude\skills\"

# install scripts globally
copy scripts\init-skills.ps1 "$HOME\.copilot\scripts\init-skills.ps1"
copy scripts\update-skills.ps1 "$HOME\.copilot\scripts\update-skills.ps1"
```

In each workspace where you want `/skill-check` without approval prompts, run:

```powershell
& "$HOME\.copilot\scripts\init-skills.ps1"
```

### 2) Use day to day

- Run skills by name (for manual skills): `/skill-check`, `/init-skills`, `/update-skills`, etc.
- Auto-invoked skills trigger from intent; manual skills require explicit `/name`.

### 3) Get updates from remote

When new skill changes are pushed to the repo, run from your workspace root:

```powershell
& "$HOME\.copilot\scripts\update-skills.ps1" -RepoPath "C:\path\to\ai-workflows"
```

This does three things in one step:
- `git pull` in your skills repo clone
- syncs `skills/*` into `~/.copilot/skills/` (including deletions)
- reruns `init-skills.ps1` to refresh `.copilot/skills-manifest.json`

## What's here

- **`skills/`** — agent skills, each a `SKILL.md` folder. Standard format, so they
  load in Claude Code and GitHub Copilot (VS Code / CLI / cloud agent / code review),
  and other Agent-Skills-compatible tools.
- **`scripts/`** — setup scripts to install alongside skills:
  `scripts/init-skills.ps1` (index manifest) and `scripts/update-skills.ps1`
  (pull + sync + re-index) (see [First-time setup](#first-time-setup) below).
- **`ADOPT.md`** — a copy-paste prompt to hand an agent (e.g. GitHub Copilot). Given
  this repo's URL, it inventories the skills and grills you on which to
  **adopt / change / leave out** for your environment, then installs the ones you approve.

## First-time setup

After copying skills to `~/.copilot/skills/`, install the setup scripts and run
`init-skills` once in each workspace you use these skills in:

```powershell
# 1. Install scripts (one-time, global)
copy scripts\init-skills.ps1 "$HOME\.copilot\scripts\init-skills.ps1"
copy scripts\update-skills.ps1 "$HOME\.copilot\scripts\update-skills.ps1"

# 2. Run from each workspace root (once per workspace)
cd <your-workspace-root>
& "$HOME\.copilot\scripts\init-skills.ps1"
```

This writes `.copilot/skills-manifest.json` into the workspace root (gitignored),
which lets `/skill-check` list all your skills — including manual-only ones hidden
from the `/` menu — without any out-of-workspace approval prompts.

Re-run `init-skills.ps1` after installing or removing global skills.
Use `update-skills.ps1` when upstream repo changes are available and you want
pull + sync + manifest refresh in one step.

## Using it

**Claude Code** — copy or symlink `skills/*` into `~/.claude/skills/` (personal) or a
repo's `.claude/skills/` (project).

**GitHub Copilot** — Copilot reads agent skills from `~/.copilot/skills/`,
`~/.claude/skills/`, or a repo's `.github/skills/` (and `.claude/skills/`). Copy
`skills/*` into one of those for a straight port, **or** run `ADOPT.md` to adopt
selectively and adapt to this environment.

To refresh installed global Copilot skills after remote updates, run
`update-skills.ps1` (see [Quick setup, use, and updates](#quick-setup-use-and-updates)).

**Selective adoption** — open `ADOPT.md`, paste it to your agent with this repo's URL,
and follow the interview.

## Environment adaptation notes

- This repo assumes Claude Code conventions in some skills. In Copilot, the
  always-on instructions file is `.github/copilot-instructions.md` (repo, team-shared)
  or personal custom instructions — **not** `CLAUDE.md`. Skills that read/write
  `CLAUDE.md` (`bootstrap`, `prime`) should target the local equivalent.
- Replace any `${CLAUDE_SKILL_DIR}` reference with a relative path in non-Claude tools.

## Skills

**Auto-invoked:** `caveman`, `diagnose`, `grill-with-docs`,
`improve-codebase-architecture`, `prime`, `skill-scout`, `tdd`, `write-a-skill`, `zoom-out`

**Manual (`/name` only):** `bootstrap`, `grill-me`, `handoff`, `init-skills`, `save`, `skill-check`, `update-skills`
