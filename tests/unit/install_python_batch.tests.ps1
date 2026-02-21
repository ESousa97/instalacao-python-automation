$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$batchFile = Join-Path $repoRoot 'install_python.bat'

if (-not (Test-Path $batchFile)) {
  throw 'Arquivo install_python.bat não encontrado.'
}

$content = Get-Content -Raw -Path $batchFile

$menuEntries = @(
  '1. Instalar App Installer (winget)',
  '2. Instalar PowerShell 7',
  '3. Instalar Python',
  '4. Instalar TUDO (sequencial)',
  '5. Verificar status das instalacoes',
  '6. Sair'
)

foreach ($entry in $menuEntries) {
  if ($content -notmatch [regex]::Escape($entry)) {
    throw "Entrada de menu ausente: $entry"
  }
}

foreach ($required in @('choice /c 123456', 'STATUS_TIMEOUT_SECONDS', 'setlocal EnableExtensions EnableDelayedExpansion')) {
  if ($content -notmatch [regex]::Escape($required)) {
    throw "Componente obrigatório ausente no script: $required"
  }
}

Write-Host '[OK] Testes unitários de estrutura do Batch passaram.'
