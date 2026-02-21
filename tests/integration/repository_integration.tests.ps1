$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $repoRoot

$requiredPaths = @(
  '.github/workflows/ci.yml',
  '.github/ISSUE_TEMPLATE/bug_report.yml',
  '.github/ISSUE_TEMPLATE/feature_request.yml',
  '.github/PULL_REQUEST_TEMPLATE.md',
  '.github/CODEOWNERS',
  'docs/architecture.md',
  'docs/setup.md'
)

foreach ($path in $requiredPaths) {
  if (-not (Test-Path $path)) {
    throw "Arquivo obrigatório ausente: $path"
  }
}

$ci = Get-Content -Raw '.github/workflows/ci.yml'
if ($ci -notmatch 'scripts/lint.ps1') {
  throw 'Workflow CI não executa lint.'
}
if ($ci -notmatch 'tests/run.ps1') {
  throw 'Workflow CI não executa testes.'
}

Write-Host '[OK] Testes de integração do repositório passaram.'
