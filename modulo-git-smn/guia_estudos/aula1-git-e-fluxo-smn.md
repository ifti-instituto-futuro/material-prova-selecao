# Aula 1: Git Essencial e o Fluxo Git SMN

Bem-vindo ao módulo de Git! Nesta aula, aprenderemos os fundamentos de versionamento de código com Git e, em seguida, o fluxo de trabalho oficial da SMN (Gitflow SMN). Todo o conteúdo é aplicado ao cenário da **Horizonte Sistemas**, uma software house fictícia cujo squad desenvolve o **AgendaFácil**, um sistema de agendamento online.

---

## 1. Conceitos Teóricos

### 1.1. O que é Git e por que versionar

Git é um sistema de controle de versão distribuído: ele registra a história do código em "fotografias" chamadas **commits**, permitindo voltar no tempo, trabalhar em paralelo e integrar o trabalho de várias pessoas com segurança.

Três áreas fundamentais:

*   **Working directory** — os arquivos como estão agora na sua pasta.
*   **Staging area** — a "área de preparação" com o que entrará no próximo commit.
*   **Repositório** — a história permanente de commits.

```bash
git init                # transforma a pasta atual em um repositorio Git
git clone <url>         # copia um repositorio remoto para a sua maquina
git status              # mostra o estado atual (arquivos alterados, preparados, etc.)
```

Use `git status` o tempo todo — ele é a bússola de quem está aprendendo.

### 1.2. O Ciclo Básico: add, commit e histórico

```bash
git add Agenda.cs           # prepara um arquivo especifico
git add .                   # prepara todas as alteracoes da pasta

git commit -m "Adiciona validacao de horario na agenda"

git log                     # historico completo
git log --oneline           # historico resumido (1 linha por commit)
git diff                    # o que mudou e ainda nao foi preparado
```

Boas mensagens de commit são curtas, no imperativo e descrevem **o que** a mudança faz: "Adiciona filtro por profissional", "Corrige cálculo de duração da consulta".

### 1.3. Repositórios Remotos

O repositório remoto (em geral no GitHub/GitLab/Azure DevOps) é o ponto de encontro do time. Por convenção, ele recebe o apelido `origin`.

```bash
git push origin nome-da-branch    # envia seus commits para o remoto
git pull                          # baixa e ja integra as novidades do remoto
git fetch                         # apenas baixa as novidades, sem integrar
```

Diferença importante: `git pull` = `git fetch` + merge automático. O `fetch` é útil quando você quer inspecionar o que chegou antes de integrar.

### 1.4. Branches e Merge

Uma **branch** é uma linha de desenvolvimento independente. Ela permite trabalhar em uma funcionalidade sem afetar o código principal.

```bash
git branch                          # lista as branches locais
git checkout -b feature/nova-tela   # cria uma branch e ja muda para ela
git switch main                     # alterna para outra branch existente
git merge feature/nova-tela         # integra a branch indicada na branch atual
```

Sobre o `merge`:

*   **Fast-forward:** quando a branch de destino não avançou, o Git apenas "move o ponteiro" — sem commit extra.
*   **Merge commit:** quando as duas branches avançaram, o Git cria um commit de integração unindo as histórias.
*   **Conflito:** quando a mesma linha foi alterada nas duas branches, o Git pausa e marca o arquivo:

```text
<<<<<<< HEAD
duracaoConsulta = 30;
=======
duracaoConsulta = 45;
>>>>>>> feature/ajuste-duracao
```

Para resolver: edite o arquivo escolhendo (ou combinando) o conteúdo correto, remova os marcadores, depois `git add` no arquivo e `git commit` para concluir o merge.

### 1.5. O Fluxo Git SMN

O Gitflow da SMN prioriza a simplicidade e o conceito de **promoção de funcionalidades**: a feature nasce da `main`, é validada em `staging` e, aprovada, é promovida à `main`.

| Branch | Função | Características |
| :--- | :--- | :--- |
| `main` | Produção. Contém exclusivamente código estável, testado e aprovado. | Protegida — alterações somente via Pull Request. |
| `staging` | Homologação. Integra funcionalidades para validação antes da produção. | Volátil — sujeita a instabilidades e resets periódicos. |
| `feature/*` | Desenvolvimento de tarefas específicas. | Temporária — excluída após a conclusão da tarefa. |

O ciclo de vida em 3 fases:

**Fase 1 — Development:** todo desenvolvimento nasce da `main` atualizada.

```bash
git checkout main
git pull
git checkout -b feature/nome-da-funcionalidade
# ... codifica e commita ...
git push origin feature/nome-da-funcionalidade
```

**Fase 2 — Staging (homologação):** merge da `feature` na `staging` (dispara o deploy no ambiente de testes). QA e Produto validam. Se houver falhas, as correções são feitas **na feature** e integradas novamente em `staging`.

**Fase 3 — Main (produção):** aberto um Pull Request da `feature` para a `main`; após o code review e a aprovação, o merge dispara a implantação em produção e a branch de feature é excluída.

> **Diretriz Crítica:** é estritamente **vedado** realizar merge da branch `staging` para a `main`. O ambiente de staging é experimental e pode conter código instável ou reprovado. A promoção para produção acontece sempre da `feature` para a `main`.

Papel estratégico da `staging`: ela é a barreira de segurança do processo. Aceita múltiplos merges para testes rápidos e, se acumular divergências ou instabilidade, é **recriada a partir da `main`** (reset), restaurando a integridade do ambiente de testes.

### 1.6. Gitflow Tradicional vs. Gitflow SMN

**Gitflow Tradicional:** Feature → Develop → Release → Main (+ Hotfix).
**Gitflow SMN:** Feature → Staging (validação) → Main.

| Característica | Gitflow Tradicional | Gitflow SMN |
| :--- | :--- | :--- |
| **Integração** | Usa `develop` como branch perene. | Inexistente — a base é sempre a `main`. |
| **Implantação** | Processo complexo com branches de release e tags. | Simplificado — merge na `main` resulta em deploy. |
| **Staging** | Não é mandatório na definição padrão. | Fundamental — atua como garantia de qualidade. |
| **Correção de bugs** | Hotfixes complexos direto na produção. | Correções feitas na `feature`, com agilidade. |
| **Curva de aprendizado** | Elevada, mais propensa a conflitos. | Reduzida — fluxo intuitivo e linear. |

---

## 2. Estudo de Caso Prático: Horizonte Sistemas (AgendaFácil)

### Caso A: Da main ao push — a feature "lembrete por e-mail"

O squad recebeu a tarefa de enviar lembretes por e-mail aos pacientes do AgendaFácil. Veja o passo a passo do desenvolvedor, comentado:

```bash
# 1. Parte sempre da main atualizada
git checkout main
git pull

# 2. Cria a branch da tarefa com nome descritivo
git checkout -b feature/lembrete-email

# 3. Desenvolve em pequenos commits
git add ServicoEmail.cs
git commit -m "Adiciona servico de envio de e-mail"

git add AgendadorLembretes.cs
git commit -m "Agenda lembrete 24h antes da consulta"

# 4. Publica a branch no repositorio remoto
git push origin feature/lembrete-email
```

**Vantagem desse padrão:** partir sempre da `main` atualizada minimiza conflitos futuros e garante que a feature nasce de uma base íntegra e estável.

---

### Caso B: Homologação, reprovação de QA e promoção a produção

A feature `feature/lembrete-email` foi para homologação e o QA encontrou um problema: o lembrete era enviado duas vezes.

```bash
# 1. Integra a feature na staging (dispara deploy de homologacao)
git checkout staging
git merge feature/lembrete-email

# 2. QA reprova. A correcao e feita NA FEATURE, nunca na staging
git checkout feature/lembrete-email
git add AgendadorLembretes.cs
git commit -m "Corrige envio duplicado do lembrete"

# 3. Reintegra a correcao na staging para novo teste
git checkout staging
git merge feature/lembrete-email

# 4. QA aprova. Abre-se o Pull Request feature -> main.
#    Apos o code review e o merge do PR, a producao e atualizada
#    e a branch da feature e excluida:
git branch -d feature/lembrete-email
git push origin --delete feature/lembrete-email
```

**Vantagem desse padrão:** a `staging` funciona como barreira de segurança — a produção só recebe código que passou pela homologação e pelo code review, e a correção na própria feature mantém a história limpa e rastreável.

---

## 3. Desafio da Semana

Simule localmente uma sprint completa do AgendaFácil, exercitando o ciclo Development → Staging → Main de ponta a ponta.

### Requisitos:
1.  Crie uma pasta `agendafacil`, inicialize um repositório Git nela e faça o commit inicial na `main` com um arquivo `README.md` do projeto.
2.  Crie a branch `staging` a partir da `main`.
3.  Volte à `main` e crie a branch `feature/tela-login`. Faça **2 commits** nela (por exemplo, criando os arquivos `login.html` e `validacao.js`).
4.  Integre a `feature/tela-login` na `staging` (simulando o deploy de homologação).
5.  Simule uma reprovação de QA: faça um **3º commit de correção na feature** e integre novamente na `staging`.
6.  Simule a aprovação do PR: integre a `feature/tela-login` na `main` (em um repositório real, este passo seria o merge do Pull Request).
7.  Exclua a branch `feature/tela-login` e confira a árvore de commits com `git log --oneline --graph --all`.

### Estrutura para Desenvolvimento:
```bash
mkdir agendafacil
cd agendafacil
git init

echo "# AgendaFacil" > README.md
git add .
git commit -m "Commit inicial do projeto"

# Continue a partir daqui!
```

---
*Dica: rode `git log --oneline --graph --all` após cada fase para visualizar a árvore de branches se formando — é a melhor forma de "enxergar" o fluxo.*
