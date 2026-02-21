# Setup avançado

## Execução local

```powershell
Start-Process -FilePath .\install_python.bat -Verb RunAs
```

## Validação local completa

```powershell
pwsh -File scripts/lint.ps1
pwsh -File tests/run.ps1
pwsh -File scripts/build.ps1
pwsh -File scripts/validate-repo.ps1 -Strict
```

## Observações

- O script exige Windows 10/11 com acesso administrativo.
- A instalação depende de conectividade com repositórios oficiais.
