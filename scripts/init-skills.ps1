# init-skills.ps1
# Scans ~/.copilot/skills/ (global) and .github/skills/ (project) and writes
# .copilot/skills-manifest.json in the current working directory (workspace root).
#
# Install: copy this file to ~/.copilot/scripts/init-skills.ps1
# Run once per workspace: cd <workspace-root> ; init-skills
# Re-run after installing or removing global skills.

param()
$ErrorActionPreference = 'Stop'

function Parse-SkillFrontmatter([string]$text) {
    $result = [ordered]@{}
    if ($text -notmatch '(?s)\A---\s*\r?\n(.*?)\r?\n---') { return $result }
    $fm = $matches[1] -split '\r?\n'
    $i = 0
    while ($i -lt $fm.Count) {
        $line = $fm[$i]
        if ($line -match '^\s*([A-Za-z0-9_-]+)\s*:\s*(.*)\s*$') {
            $k = $matches[1]
            $v = $matches[2]
            if ($v -eq '>' -or $v -eq '|') {
                $parts = @()
                $i++
                while ($i -lt $fm.Count -and $fm[$i] -match '^\s{2,}.+') {
                    $parts += ($fm[$i] -replace '^\s{2,}', '')
                    $i++
                }
                $result[$k] = ($parts -join ' ').Trim()
                continue
            } else {
                $result[$k] = $v.Trim().Trim('"''')
            }
        }
        $i++
    }
    return $result
}

function Get-SkillsFromDir([string]$root, [string]$source) {
    if (-not (Test-Path $root)) { return @() }
    $files = Get-ChildItem -Path $root -Recurse -Filter 'SKILL.md' -File
    $skills = foreach ($f in $files) {
        $raw = Get-Content -LiteralPath $f.FullName -Raw
        $fm = Parse-SkillFrontmatter $raw
        $name = if ($fm.Contains('name') -and $fm['name']) { $fm['name'] } else { $f.Directory.Name }
        [PSCustomObject]@{
            name                     = [string]$name
            description              = [string]$fm['description']
            disable_model_invocation = [string]$fm['disable-model-invocation']
            user_invocable           = [string]$fm['user-invocable']
            source                   = $source
        }
    }
    return @($skills)
}

# Scan global skills (~/.copilot/skills/)
$globalRoot   = Join-Path $HOME '.copilot\skills'
$globalSkills = Get-SkillsFromDir $globalRoot 'global'

# Scan project skills (.github/skills/ relative to CWD)
$projectRoot   = Join-Path $PWD '.github\skills'
$projectSkills = Get-SkillsFromDir $projectRoot 'project'

# Ensure output directory exists
$outDir = Join-Path $PWD '.copilot'
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

# Write manifest
$manifest = [ordered]@{
    generated     = (Get-Date -Format 'yyyy-MM-dd')
    global_count  = $globalSkills.Count
    project_count = $projectSkills.Count
    skills        = @($globalSkills + $projectSkills)
}

$outPath = Join-Path $outDir 'skills-manifest.json'
[IO.File]::WriteAllText($outPath, ($manifest | ConvertTo-Json -Depth 5), [Text.Encoding]::UTF8)

Write-Host "Indexed $($globalSkills.Count) global + $($projectSkills.Count) project skills"
Write-Host "Manifest: $outPath"
Write-Host "Re-run after installing or removing global skills."
