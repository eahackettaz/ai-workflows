---
name: init-skills
description: Build the workspace-local skill manifest by scanning global and project skills once, so /skill-check can run without out-of-workspace approval prompts. Run manually via /init-skills.
argument-hint: ""
disable-model-invocation: true
---

# Init Skills (Global)

Builds `.copilot/skills-manifest.json` in the current workspace root by scanning:
- `~/.copilot/skills/` — global skills (tagged `global`)
- `.github/skills/` — project skills (tagged `project`)

After running this once per workspace, `/skill-check` reads the manifest without any
out-of-workspace terminal scan or approval prompts.

## Behavior

1. Run the init script from the workspace root:
   ```powershell
   & "$HOME\.copilot\scripts\init-skills.ps1"
   ```
2. Report:
   - Number of global and project skills indexed
   - Full path of the written manifest
3. Remind the user to re-run after installing or removing global skills.

## Notes

- `.copilot/skills-manifest.json` is gitignored and user-local — not shared via git.
- Run once per workspace. Re-run only when your global skill set changes.
- The companion CLI command `init-skills` (PS profile function) does the same thing
  outside of chat.
- The script itself lives in `scripts/init-skills.ps1` in this repo; install it to
  `~/.copilot/scripts/init-skills.ps1` alongside your global skills.
