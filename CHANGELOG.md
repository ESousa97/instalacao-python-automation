# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [2.0.1] - 2026-02-21

### Changed

- Repositório marcado como arquivado para estudo, sem manutenção ativa.
- Dependabot configurado para não abrir novos PRs.
- Templates de issue/PR e documentos de governança atualizados com aviso explícito de arquivamento e ausência de SLA.

## [2.0.0] - 2026-02-21

### Added

- Governança de repositório com templates de issue, PR template, CODEOWNERS e FUNDING.
- Arquivos de higiene e padronização: `.editorconfig`, `.gitattributes`, `.gitignore`, `.env.example`.
- Workflow de CI para validação contínua.
- Dependabot para manutenção automática de GitHub Actions.
- Suite local de validações e testes em PowerShell.
- Documentação complementar: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `docs/`.

### Changed

- Refatoração do `install_python.bat` com modularização, timeout de espera e mensagens padronizadas.
- Reescrita do `README.md` para padrão técnico profissional e execução copy-paste.

### Fixed

- Inconsistência de opção de status no menu e melhoria de robustez no fluxo de monitoramento de tarefas.

### Security

- Fortalecimento de práticas de contribuição e reporte de vulnerabilidades.
- Exclusão explícita de arquivos sensíveis e relatórios internos no `.gitignore`.
