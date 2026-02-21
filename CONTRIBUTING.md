# Contributing

## Status do repositório

Este repositório está **arquivado** e não está mais em desenvolvimento ativo.
Ele permanece público somente para fins de estudo e referência.
Não há garantia de resposta, revisão de PR ou correção de issues.

Obrigado por contribuir com este projeto.

## Setup de desenvolvimento

1. Clone o repositório:
   ```powershell
   git clone https://github.com/enoquesousa/instalacao-python-automation.git
   cd instalacao-python-automation
   ```
2. Rode a validação local:
   ```powershell
   pwsh -File scripts/lint.ps1
   pwsh -File tests/run.ps1
   ```

## Convenções de código

- Edição e finais de linha seguem `.editorconfig` e `.gitattributes`.
- Scripts Batch devem manter comportamento backward compatible.
- Evite duplicação de fluxo; prefira funções com responsabilidade única.

## Processo de Pull Request

- Crie branch com prefixo semântico:
  - `feat/<descricao-curta>`
  - `fix/<descricao-curta>`
  - `docs/<descricao-curta>`
  - `chore/<descricao-curta>`
- Faça commits no padrão Conventional Commits.
- Abra PR com checklist preenchido (`.github/PULL_REQUEST_TEMPLATE.md`), ciente de que não há garantia de revisão.

## Conventional Commits

Formato:

```text
<type>(<scope>): <description>
```

Tipos permitidos:

- `feat` — nova funcionalidade
- `fix` — correção de bug
- `refactor` — refatoração sem mudança de comportamento
- `docs` — documentação
- `style` — formatação (sem mudança de lógica)
- `test` — adição ou correção de testes
- `chore` — manutenção, dependências, configs
- `ci` — mudanças em CI/CD
- `perf` — melhorias de performance
- `security` — correções de segurança

## Testes

Execute localmente antes de abrir PR:

```powershell
pwsh -File scripts/lint.ps1
pwsh -File tests/run.ps1
pwsh -File scripts/build.ps1
```

## Áreas prioritárias para contribuição

- Melhorias de robustez no fluxo de instalação em Batch
- Expansão de cobertura de testes de integração
- Evolução da documentação operacional

## Autor

Portfólio: https://enoquesousa.vercel.app  
GitHub: https://github.com/enoquesousa
