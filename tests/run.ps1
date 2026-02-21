$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

& (Join-Path $PSScriptRoot 'unit/install_python_batch.tests.ps1')
& (Join-Path $PSScriptRoot 'integration/repository_integration.tests.ps1')

Write-Host '[OK] Suíte de testes finalizada.'
