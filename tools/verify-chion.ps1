param(
  [string]$SkillDir = (Join-Path $PSScriptRoot '..\skills\chion'),
  [string]$QuickValidate = 'C:\Users\Administrator\.codex\skills\.system\skill-creator\scripts\quick_validate.py'
)

$ErrorActionPreference = 'Stop'

function Fail($message) {
  Write-Error $message
  exit 1
}

$skill = Join-Path $SkillDir 'SKILL.md'
$thin = Join-Path $SkillDir 'references\thin-pm.md'
$templates = Join-Path $SkillDir 'references\templates.md'
$openai = Join-Path $SkillDir 'agents\openai.yaml'

foreach ($path in @($skill, $thin, $templates, $openai)) {
  if (!(Test-Path -LiteralPath $path)) {
    Fail "Missing required file: $path"
  }
}

$checks = @(
  @{ Path = $skill; Pattern = '## Routing Gate' },
  @{ Path = $skill; Pattern = 'PM-self-exception' },
  @{ Path = $skill; Pattern = 'Do not say "done", "verified", "accepted", or "ready"' },
  @{ Path = $thin; Pattern = '## No Silent Completion' },
  @{ Path = $thin; Pattern = 'If delegation tools are available' },
  @{ Path = $thin; Pattern = 'self-checked, independent reviewer not run' },
  @{ Path = $templates; Pattern = '## Final Compliance Check' },
  @{ Path = $templates; Pattern = 'UNKNOWN' },
  @{ Path = $openai; Pattern = 'routing gates' }
)

foreach ($check in $checks) {
  $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $check.Path
  if ($text -notlike "*$($check.Pattern)*") {
    Fail "Missing pattern '$($check.Pattern)' in $($check.Path)"
  }
}

if (Test-Path -LiteralPath $QuickValidate) {
  $py = Join-Path $env:TEMP 'codex-skillcreator-venv\Scripts\python.exe'
  if (!(Test-Path -LiteralPath $py)) {
    $py = 'python'
  }
  $env:PYTHONUTF8 = '1'
  & $py $QuickValidate $SkillDir
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
} else {
  Write-Warning "quick_validate.py not found at $QuickValidate; skipped official validation"
}

Write-Output "Chion verification passed: $SkillDir"
