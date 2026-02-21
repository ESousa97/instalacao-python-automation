# instalacao-python-automation

> Automação confiável para instalação de winget, PowerShell 7 e Python em Windows com fluxo interativo e resiliente.

![CI](https://github.com/enoquesousa/instalacao-python-automation/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/github/license/enoquesousa/instalacao-python-automation)
![Windows](https://img.shields.io/badge/platform-windows%2010%2F11-blue)
![Last Commit](https://img.shields.io/github/last-commit/enoquesousa/instalacao-python-automation)
![Issues](https://img.shields.io/github/issues/enoquesousa/instalacao-python-automation)

---

Projeto de automação em Batch para preparar ambiente de desenvolvimento no Windows com instalações em janelas separadas e monitoramento por status file. O fluxo preserva a janela principal para evitar encerramentos acidentais e organiza instalações de App Installer, PowerShell 7 e Python de forma sequencial ou individual. O foco é execução previsível, rastreável e de baixo atrito para setup local.

## Demonstração

```text
========================================
 INSTALADOR AUTOMATICO - JANELA IMORTAL
========================================
 Versao: 2.0.0
 Esta janela nao fecha automaticamente.
========================================

MENU PRINCIPAL:

1. Instalar App Installer (winget)
2. Instalar PowerShell 7
3. Instalar Python
4. Instalar TUDO (sequencial)
5. Verificar status das instalacoes
6. Sair
```

## Stack Tecnológico

| Tecnologia | Papel |
|---|---|
| Windows Batch (`.bat`) | Orquestração principal do fluxo interativo |
| PowerShell | Execução de instalação e automação auxiliar |
| winget | Instalação de pacotes oficiais (PowerShell/Python) |
| GitHub Actions | Validação contínua de qualidade do repositório |

## Pré-requisitos

- Windows 10 ou Windows 11
- Execução como Administrador
- Conexão com internet
- Git (para clonar o repositório)

## Instalação e Uso

```powershell
git clone https://github.com/enoquesousa/instalacao-python-automation.git
cd instalacao-python-automation
```

Execução do instalador:

```powershell
Start-Process -FilePath .\install_python.bat -Verb RunAs
```

Opcionalmente, configure variáveis com base no template:

```powershell
Copy-Item .env.example .env
```

## Scripts Disponíveis

| Comando | Descrição |
|---|---|
| `pwsh -File scripts/lint.ps1` | Executa lint estrutural do repositório e do script principal |
| `pwsh -File tests/run.ps1` | Executa suíte de testes locais (unit + integration) |
| `pwsh -File scripts/build.ps1` | Validação de build para este tipo de projeto (no-op validado) |
| `pwsh -File scripts/validate-repo.ps1 -Strict` | Validação completa com regras estritas |

## Arquitetura

```text
.
├── .github/
│   ├── workflows/
│   └── ISSUE_TEMPLATE/
├── docs/
├── scripts/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── .editorconfig
├── .gitattributes
├── .gitignore
├── .env.example
└── install_python.bat
```

Decisões arquiteturais detalhadas em `docs/architecture.md`.

## API Reference

Não aplicável. Este projeto não expõe API HTTP.

## Roadmap

- [x] Refatorar fluxo principal para robustez e timeout de tarefas
- [x] Adicionar validação local automatizada
- [x] Adicionar governança GitHub (templates, CODEOWNERS, CI)
- [ ] Adicionar modo totalmente não interativo para Python via variável de ambiente
- [ ] Incluir telemetria opcional de execução local (opt-in)

## Contribuindo

Consulte `CONTRIBUTING.md` para padrão de branches, commits e fluxo de PR.

## Licença

Distribuído sob a licença MIT. Consulte `LICENSE`.

## Autor

Enoque Sousa  
Portfólio: https://enoquesousa.vercel.app  
GitHub: https://github.com/enoquesousa
