param(
  [string]$SkillDir = (Join-Path $PSScriptRoot '..\skills\chion'),
  [string]$QuickValidate = 'C:\Users\Administrator\.codex\skills\.system\skill-creator\scripts\quick_validate.py',
  [string]$Readme = (Join-Path $PSScriptRoot '..\README.md')
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

foreach ($path in @($skill, $thin, $templates, $openai, $Readme)) {
  if (!(Test-Path -LiteralPath $path)) {
    Fail "Missing required file: $path"
  }
}

$checks = @(
  @{ Path = $skill; Pattern = '用户负责决定产品要什么，CHION 负责想办法把它做出来' },
  @{ Path = $skill; Pattern = 'PM、Worker、Reviewer 必须分别位于三条相互独立的线程' },
  @{ Path = $skill; Pattern = '提出问题不算完成' },
  @{ Path = $skill; Pattern = '## 先复用，后创造' },
  @{ Path = $skill; Pattern = 'Worker 必须回传查过什么、复用了什么' },
  @{ Path = $skill; Pattern = 'PM 调整调查范围、Worker 写入范围、技术路线或验收方法' },
  @{ Path = $skill; Pattern = '扩大用户已确认的产品目标、项目边界或授权边界' },
  @{ Path = $skill; Pattern = '【你无需操作】' },
  @{ Path = $skill; Pattern = '【需要你拍板】' },
  @{ Path = $thin; Pattern = '## 3. 发现问题后继续解决' },
  @{ Path = $thin; Pattern = '项目内部可以通过只读调查查清的事实，由 PM 自动安排查找' },
  @{ Path = $thin; Pattern = '同一项目其他模块的成熟实现' },
  @{ Path = $thin; Pattern = '一次只问一个真正阻塞的业务或授权问题' },
  @{ Path = $thin; Pattern = '只暂停会越界或必须靠猜的动作' },
  @{ Path = $thin; Pattern = '不做定时 heartbeat' },
  @{ Path = $templates; Pattern = '查过什么：' },
  @{ Path = $templates; Pattern = '成熟方案复用结论：' },
  @{ Path = $templates; Pattern = '真正需要用户拍板：无 / 一个业务或授权问题' },
  @{ Path = $templates; Pattern = '【你无需操作】' },
  @{ Path = $templates; Pattern = '【需要你拍板】' },
  @{ Path = $templates; Pattern = '推荐：' },
  @{ Path = $templates; Pattern = '理由：' },
  @{ Path = $templates; Pattern = '选择影响：' },
  @{ Path = $templates; Pattern = '正在推进 / 已完成 / 等待外部条件' },
  @{ Path = $templates; Pattern = '继续所有安全内部工作' },
  @{ Path = $templates; Pattern = '明确等待内容和恢复条件' },
  @{ Path = $Readme; Pattern = 'separate PM / Worker / read-only Reviewer threads' },
  @{ Path = $Readme; Pattern = 'asks the user only for real product, business, or authorization decisions' },
  @{ Path = $Readme; Pattern = 'PM 内部判断：无；需要用户拍板：无。' },
  @{ Path = $openai; Pattern = '自动解决问题' },
  @{ Path = $openai; Pattern = '$chion' }
)

foreach ($check in $checks) {
  $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $check.Path
  if ($text -notlike "*$($check.Pattern)*") {
    Fail "Missing pattern '$($check.Pattern)' in $($check.Path)"
  }
}

$skillText = Get-Content -Raw -Encoding UTF8 -LiteralPath $skill
$thinText = Get-Content -Raw -Encoding UTF8 -LiteralPath $thin
$templatesText = Get-Content -Raw -Encoding UTF8 -LiteralPath $templates
$readmeText = Get-Content -Raw -Encoding UTF8 -LiteralPath $Readme
$skillLines = @(Get-Content -Encoding UTF8 -LiteralPath $skill).Count
if ($skillLines -gt 80) {
  Fail "SKILL.md is too long: $skillLines lines (maximum 80)"
}

foreach ($oldRule in @('PM-self-exception', 'explorer', 'patrol')) {
  if ($skillText -match [regex]::Escape($oldRule)) {
    Fail "Obsolete role or bypass remains in SKILL.md: $oldRule"
  }
}

if ($readmeText -match '(?i)routing[- ]gate|PM-self-exception|explorer|patrol') {
  Fail 'README.md still describes an obsolete routing role or gate'
}

$statusText = $skillText + "`n" + $thinText + "`n" + $templatesText
if ($statusText.Contains('【你无需操作】项目继续自动推进。')) {
  Fail 'User status must keep only the action tag fixed; the following state must be truthful'
}

if ($templatesText.Contains('PM 必须继续安排内部下一步')) {
  Fail 'Template must allow truthful external waiting after safe internal work is exhausted'
}

foreach ($reference in @('references\thin-pm.md', 'references\templates.md')) {
  if (!(Test-Path -LiteralPath (Join-Path $SkillDir $reference))) {
    Fail "Broken SKILL.md reference: $reference"
  }
}

$openaiLines = @(Get-Content -Encoding UTF8 -LiteralPath $openai | Where-Object { $_.Trim() })
if ($openaiLines.Count -ne 4 -or $openaiLines[0] -ne 'interface:') {
  Fail 'agents/openai.yaml must contain only the interface and three required fields'
}

$openaiText = Get-Content -Raw -Encoding UTF8 -LiteralPath $openai
foreach ($field in @('display_name', 'short_description', 'default_prompt')) {
  if ($openaiText -notmatch "(?m)^  $field`: `"[^`"]+`"\s*$") {
    Fail "agents/openai.yaml field must be present and quoted: $field"
  }
}

$shortMatch = [regex]::Match($openaiText, '(?m)^  short_description: "(?<value>[^"]+)"\s*$')
$shortLength = $shortMatch.Groups['value'].Value.Length
if ($shortLength -lt 25 -or $shortLength -gt 64) {
  Fail "short_description length must be 25-64 characters; got $shortLength"
}

if ($openaiText -notmatch '(?m)^  default_prompt: ".*\$chion.*"\s*$') {
  Fail 'default_prompt must explicitly mention $chion'
}

function Test-EquivalentQuickValidate {
  $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $skill
  $normalized = $content -replace "`r`n", "`n"
  $match = [regex]::Match($normalized, '\A---\n(?<frontmatter>.*?)\n---', [System.Text.RegularExpressions.RegexOptions]::Singleline)
  if (!$match.Success) {
    Fail 'Invalid SKILL.md frontmatter format'
  }

  $lines = @($match.Groups['frontmatter'].Value -split "`n" | Where-Object { $_.Trim() })
  if ($lines.Count -ne 2 -or $lines[0] -ne 'name: chion' -or $lines[1] -notmatch '^description: (?<value>.+)$') {
    Fail 'SKILL.md frontmatter must contain only name and description'
  }

  $description = $Matches['value']
  if ($description.Length -gt 1024 -or $description.Contains('<') -or $description.Contains('>')) {
    Fail "Invalid SKILL.md description; length=$($description.Length)"
  }

  Write-Output 'Equivalent quick validation passed (official validator dependency unavailable)'
}

if (Test-Path -LiteralPath $QuickValidate) {
  $py = Join-Path $env:TEMP 'codex-skillcreator-venv\Scripts\python.exe'
  if (!(Test-Path -LiteralPath $py)) {
    $py = 'python'
  }
  $env:PYTHONUTF8 = '1'
  $savedErrorActionPreference = $ErrorActionPreference
  $ErrorActionPreference = 'SilentlyContinue'
  & $py -c 'import yaml' 2>$null
  $yamlAvailable = $LASTEXITCODE -eq 0
  $ErrorActionPreference = $savedErrorActionPreference
  if ($yamlAvailable) {
    & $py $QuickValidate $SkillDir
    if ($LASTEXITCODE -ne 0) {
      exit $LASTEXITCODE
    }
  } else {
    Test-EquivalentQuickValidate
  }
} else {
  Test-EquivalentQuickValidate
}

Write-Output "Chion verification passed: $SkillDir"
