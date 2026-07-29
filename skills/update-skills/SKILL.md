---
name: update-skills
description: Pulls the latest ai-workflows repo, syncs skills/* into ~/.copilot/skills/ (mirroring deletions), and refreshes the workspace skill manifest via init-skills. Run manually via /update-skills.
argument-hint: "<repo-path>"
disable-model-invocation: true
---

# Update Skills

Pulls the latest changes from your `ai-workflows` clone and re-syncs them into
`~/.copilot/skills/`, then refreshes this workspace's skill manifest. Run this
whenever the upstream repo has new or changed skills you want reflected locally.

## Behavior

1. Run the update script, passing the path to your `ai-workflows` clone:
   ```powershell
   & "$HOME\.copilot\scripts\update-skills.ps1" -RepoPath "C:\path\to\ai-workflows"
   ```
2. The script:
   - Runs `git pull` in that repo.
   - Mirrors `skills/*` into `~/.copilot/skills/` via `robocopy /MIR` - new and
     changed skills are copied, skills removed upstream are deleted locally too.
   - Re-runs `init-skills.ps1` against the **current workspace root** to refresh
     `.copilot/skills-manifest.json`.
3. Report: what changed (pulled commits, if visible), and confirm the manifest
   refresh.

## Notes

- Run this from the workspace root you want the manifest refreshed for - not
  necessarily the `ai-workflows` repo itself.
- Only updates **global personal skills** (`~/.copilot/skills/`). Project-committed
  skills (`.github/skills/`) update via normal `git pull` or PR merge in that repo,
  not this script.
- If you symlinked `skills/*` into `~/.copilot/skills/` instead of copying, the
  robocopy step is unnecessary (the symlink already reflects the pulled changes) -
  you can skip straight to re-running `init-skills`.
