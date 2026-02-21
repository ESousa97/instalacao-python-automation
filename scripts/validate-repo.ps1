param(
  [switch]$Strict
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$requiredFiles = @(
  '.editorconfig',
  '.gitattributes',
  '.gitignore',
  '.env.example',
  'README.md',
  'CONTRIBUTING.md',
  'CODE_OF_CONDUCT.md',
  'SECURITY.md',
  'CHANGELOG.md',
  'LICENSE',
  'install_python.bat',
  '.github/workflows/ci.yml',
  '.github/dependabot.yml'
)

$missing = @()
foreach ($file in $requiredFiles) {
  if (-not (Test-Path $file)) {
    $missing += $file
  }
}

if ($missing.Count -gt 0) {
  Write-Error ("Arquivos obrigatórios ausentes: {0}" -f ($missing -join ', '))
}

$batchContent = Get-Content -Raw -Path 'install_python.bat'
$requiredLabels = @(
  ':main_loop',
  ':install_app_installer',
  ':install_powershell',
  ':install_python',
  ':install_all',
  ':check_status',
  ':wait_for_status',
  ':exit_script'
)

$missingLabels = @()
foreach ($label in $requiredLabels) {
  if ($batchContent -notmatch [regex]::Escape($label)) {
    $missingLabels += $label
  }
}

if ($missingLabels.Count -gt 0) {
  Write-Error ("Labels ausentes no install_python.bat: {0}" -f ($missingLabels -join ', '))
}

$gitignoreContent = Get-Content -Raw -Path '.gitignore'
foreach ($entry in @('BASELINE.md', 'FINAL.md', '.env')) {
  if ($gitignoreContent -notmatch [regex]::Escape($entry)) {
    Write-Error "Entrada obrigatória ausente no .gitignore: $entry"
  }
}

if ($Strict) {
  if ($batchContent -match 'Nao implementado') {
    Write-Error 'Texto legado detectado: "Nao implementado".'
  }

  if ($batchContent -notmatch 'STATUS_TIMEOUT_SECONDS') {
    Write-Error 'Controle de timeout não encontrado.'
  }
}

Write-Host '[OK] Validação do repositório concluída com sucesso.'
