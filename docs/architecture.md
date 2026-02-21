# Arquitetura

## Objetivo

Automatizar o setup inicial de ambiente de desenvolvimento no Windows com execução previsível e baixo risco operacional para o usuário.

## Decisões principais

1. **Script principal em Batch**
   - Racional: compatibilidade nativa com Windows sem dependências adicionais.
2. **Execução de instalações em janelas separadas**
   - Racional: a janela principal permanece disponível e evita encerramento acidental do fluxo.
3. **Sincronização por arquivos de status em `%TEMP%`**
   - Racional: mecanismo simples e estável para comunicação entre processos sem infraestrutura extra.
4. **Timeout global de tarefa**
   - Racional: previne espera infinita quando uma instalação é interrompida externamente.

## Fluxo

1. Validar privilégios administrativos.
2. Exibir menu interativo.
3. Gerar script temporário para tarefa selecionada.
4. Executar em janela separada.
5. Aguardar arquivo de status (`OK`/`ERRO`) com timeout.
6. Exibir resultado e retornar ao menu.
