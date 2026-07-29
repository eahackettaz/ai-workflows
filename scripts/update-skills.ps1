# update-skills.ps1
# Pulls the latest ai-workflows repo, syncs skills/* into ~/.copilot/skills/
# (mirroring deletions too), then re-runs init-skills.ps1 against the current
# workspace root to refresh the skill manifest.
#
# Usage: & "$HOME\.copilot\scripts\update-skills.ps1" -RepoPath "C:\path\to\ai-workflows"
# Run from your workspace root so the manifest refresh targets the right project.

param(
    [Parameter(Mandatory = $true)]
    [string]$RepoPath
)
$ErrorActionPreference = 'Stop'

if (-not (Test-Path $RepoPath)) {
    throw "RepoPath not found: $RepoPath"
}

# 1. Pull latest skills
Push-Location $RepoPath
try {
    Write-Host "Pulling latest changes in $RepoPath..."
    git pull
} finally {
    Pop-Location
}

# 2. Mirror skills/* into ~/.copilot/skills/ (adds new, updates changed, removes deleted)
$sourceSkills = Join-Path $RepoPath 'skills'
$destSkills   = Join-Path $HOME '.copilot\skills'

if (-not (Test-Path $sourceSkills)) {
    throw "No skills/ folder found at $sourceSkills"
}
if (-not (Test-Path $destSkills)) {
    New-Item -ItemType Directory -Path $destSkills -Force | Out-Null
}

Write-Host "Syncing skills into $destSkills..."
robocopy $sourceSkills $destSkills /MIR /NFL /NDL /NJH /NJS | Out-Null
if ($LASTEXITCODE -ge 8) {
    throw "robocopy failed with exit code $LASTEXITCODE"
}

# 3. Refresh the workspace-local skill manifest (run from workspace root)
$initScript = Join-Path $HOME '.copilot\scripts\init-skills.ps1'
if (Test-Path $initScript) {
    Write-Host "Refreshing skill manifest for $PWD..."
    & $initScript
} else {
    Write-Host "init-skills.ps1 not found at $initScript - skipping manifest refresh."
}

Write-Host "Skills updated from $RepoPath."
