$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $PSScriptRoot 'validate-repo.ps1'
& $scriptPath -Strict
Write-Host '[OK] Lint estrutural concluído.'
