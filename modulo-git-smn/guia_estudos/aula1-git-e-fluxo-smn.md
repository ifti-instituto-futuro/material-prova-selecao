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

Antes do **primeiro commit**, configure sua identidade — o nome e o e-mail que assinarão todos os seus commits. É uma configuração feita **uma única vez** por máquina (a flag `--global` vale para todos os seus repositórios):

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@empresa.com"
```

Com a identidade configurada, o ciclo do dia a dia é preparar (`add`) e registrar (`commit`):

```bash
git add Agenda.cs           # prepara um arquivo especifico
git add .                   # prepara todas as alteracoes da pasta

git commit -m "feat/nome-da-funcionalidade: Adiciona validacao de horario na agenda"

git log                     # historico completo
git log --oneline           # historico resumido (1 linha por commit)
git diff                    # o que mudou e ainda nao foi preparado
```

Boas mensagens de commit são curtas, no imperativo e descrevem **o que** a mudança faz: "Adiciona filtro por profissional", "Corrige cálculo de duração da consulta".

### 1.3. Revertendo um commit com segurança

Quando uma alteração inadequada já foi registrada em um commit — especialmente se ela já foi compartilhada com o time — use `git revert`. Em vez de apagar ou reescrever a história, ele cria **um novo commit** que desfaz as alterações introduzidas pelo commit escolhido.

```bash
git log --oneline              # localiza o identificador do commit a reverter
git revert <hash-do-commit>    # cria o commit que desfaz aquela alteração
git status                     # confere o estado atual do repositorio
git log --oneline              # confirma o commit original e o commit de reversao
```

Se a reversão encontrar um conflito, resolva o arquivo seguindo o mesmo processo de uma integração: escolha o conteúdo final, remova os marcadores e conclua o commit de reversão.

> **`revert` não é `reset`.** `git revert` preserva o commit original no histórico e adiciona outro commit que o compensa; por isso é a escolha segura para alterações que já foram compartilhadas. `git reset` move o ponteiro da branch e pode descartar commits locais. No fluxo SMN, a recriação da `staging` a partir da `main` é uma decisão de ambiente e não substitui a reversão de um commit compartilhado.

### 1.4. Repositórios Remotos

O repositório remoto (em geral no GitHub/GitLab/Azure DevOps) é o ponto de encontro do time. Por convenção, ele recebe o apelido `origin`.

```bash
git push origin nome-da-branch    # envia seus commits para o remoto
git pull                          # baixa e ja integra as novidades do remoto
git fetch                         # apenas baixa as novidades, sem integrar
```

Diferença importante: `git pull` = `git fetch` + merge automático. O `fetch` é útil quando você quer inspecionar o que chegou antes de integrar.

#### Publicação forçada: `--force` exige cuidado

`git push --force` faz o remoto apontar para a história local da sua branch, mesmo quando os históricos divergem. Isso pode ser necessário depois de reescrever **uma branch exclusivamente sua** com `rebase`, `commit --amend` ou `reset`, mas também pode fazer commits de colegas deixarem de aparecer na referência remota da branch.

```bash
git fetch origin
git log --oneline origin/feat/minha-tarefa  # confere o estado remoto conhecido
git push --force-with-lease origin feat/minha-tarefa
```

Prefira `git push --force-with-lease` em vez de `git push --force`. A opção `--force-with-lease` recusa a publicação se a referência remota mudou desde a última informação local conhecida; assim, evita sobrescrever por engano o trabalho que chegou de outra pessoa.

**Regras de segurança:**

1. Nunca use publicação forçada em `main`, `staging` ou em uma branch compartilhada pelo time.
2. Use-a somente em uma `feat/*` que seja sua e depois de confirmar que a reescrita do histórico é realmente necessária.
3. Antes de publicar, execute `git fetch origin` e compare a branch remota com `git log`.
4. Avise as pessoas que trabalham na mesma branch. Se alguém já publicou nela, pare e alinhe o procedimento antes de forçar.
5. Para desfazer um commit que já foi compartilhado, prefira `git revert`: publicação forçada não é uma forma segura de correção coletiva.

### 1.5. Branches e Merge

Uma **branch** é uma linha de desenvolvimento independente. Ela permite trabalhar em uma funcionalidade sem afetar o código principal.

```bash
git branch                           # lista as branches locais
git checkout -b feat/nova-tela       # cria uma branch e ja muda para ela
git switch main ou git checkout main # alterna para outra branch existente
git merge feat/nova-tela             # integra a branch indicada na branch atual
```

> **Convenção de nomes de branch.** Use sempre **letras minúsculas** e **kebab-case** (palavras separadas por hífen), sem espaços nem acentos: `feat/cadastro-de-clientes`, e nunca `Feat/Cadastro Clientes` ou `nova branch`. No fluxo SMN, o prefixo obrigatório é `feat/`. O essencial é o time inteiro seguir **um** padrão de forma consistente.

Sobre o `merge`:

*   **Fast-forward:** quando a branch de destino não avançou, o Git apenas "move o ponteiro" — sem commit extra.
*   **Merge commit:** quando as duas branches avançaram, o Git cria um commit de integração unindo as histórias.
*   **Conflito:** quando a mesma linha foi alterada nas duas branches, o Git pausa e marca o arquivo:

```text
<<<<<<< HEAD
duracaoConsulta = 30;
=======
duracaoConsulta = 45;
>>>>>>> feat/ajuste-duracao
```

Para resolver: edite o arquivo escolhendo (ou combinando) o conteúdo correto, remova os marcadores, depois `git add` no arquivo e `git commit` para concluir o merge.

#### Ramificação auxiliar em atividades de aprendizagem

Uma atividade pode pedir uma ramificação temporária para praticar integração sem alterar a `main`. Nesse caso, trate-a como uma ramificação **auxiliar de avaliação**, identificada por `atividade/`, e não como uma `feat/*` do fluxo SMN. Ela pode nascer da branch de entrega, receber uma alteração própria, ser integrada de volta nessa mesma branch e ser excluída em seguida. Ela não segue para `staging` nem para `main`.

Para que o histórico evidencie uma integração real, a branch de entrega e a ramificação auxiliar devem receber um commit cada depois da bifurcação. Assim, o merge une duas linhas de desenvolvimento em vez de apenas avançar o ponteiro da branch.

### 1.6. O Fluxo Git SMN

O Gitflow da SMN prioriza a simplicidade e o conceito de **promoção de funcionalidades**: a feature nasce da `main`, é validada em `staging` e, aprovada, é promovida à `main`.

| Branch | Função | Características |
| :--- | :--- | :--- |
| `main` | Produção. Contém exclusivamente código estável, testado e aprovado. | Protegida — alterações somente via Pull Request. |
| `staging` | Homologação. Integra funcionalidades para validação antes da produção. | Volátil — sujeita a instabilidades e resets periódicos. |
| `feat/*` | Desenvolvimento de tarefas específicas. | Temporária — excluída após a conclusão da tarefa. |

O ciclo de vida em 3 fases:

**Fase 1 — Development:** todo desenvolvimento nasce da `main` atualizada.

```bash
git checkout main
git pull
git checkout -b feat/nome-da-funcionalidade
# ... codifica e commita ...
git push origin feat/nome-da-funcionalidade
```

**Fase 2 — Staging (homologação):** merge da `feat` na `staging` (dispara o deploy no ambiente de testes). QA e Produto validam. Se houver falhas, as correções são feitas **na feat** e integradas novamente em `staging`.

**Fase 3 — Main (produção):** aberto um Pull Request da `feat` para a `main`; após o code review e a aprovação, o merge dispara a implantação em produção e a branch `feat` é excluída.

> **Diretriz Crítica:** é estritamente **vedado** realizar merge da branch `staging` para a `main`. O ambiente de staging é experimental e pode conter código instável ou reprovado. A promoção para produção acontece sempre da `feat/*` para a `main`.

Papel estratégico da `staging`: ela é a barreira de segurança do processo. Aceita múltiplos merges para testes rápidos e, se acumular divergências ou instabilidade, é **recriada a partir da `main`** (reset), restaurando a integridade do ambiente de testes.

### 1.7. Gitflow Tradicional vs. Gitflow SMN

**Gitflow Tradicional:** Feature → Develop → Release → Main (+ Hotfix).
**Gitflow SMN:** Feature → Staging (validação) → Main.

| Característica | Gitflow Tradicional | Gitflow SMN |
| :--- | :--- | :--- |
| **Integração** | Usa `develop` como branch perene. | Inexistente — a base é sempre a `main`. |
| **Implantação** | Processo complexo com branches de release e tags. | Simplificado — merge na `main` resulta em deploy. |
| **Staging** | Não é mandatório na definição padrão. | Fundamental — atua como garantia de qualidade. |
| **Correção de bugs** | Hotfixes complexos direto na produção. | Correções feitas na `feat/*`, com agilidade. |
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
git checkout -b feat/lembrete-email

# 3. Desenvolve em pequenos commits
git add ServicoEmail.cs
git commit -m "feat/lembrete-email: Adiciona servico de envio de e-mail."

git add AgendadorLembretes.cs
git commit -m "feat/lembrete-email: Agenda lembrete 24h antes da consulta."

# 4. Publica a branch no repositorio remoto
git push origin feat/lembrete-email
```

**Vantagem desse padrão:** partir sempre da `main` atualizada minimiza conflitos futuros e garante que a feature nasce de uma base íntegra e estável.

---

### Caso B: Homologação, reprovação de QA e promoção a produção

A feature `feat/lembrete-email` foi para homologação e o QA encontrou um problema: o lembrete era enviado duas vezes.

```bash
# 1. Integra a feature na staging (dispara deploy de homologacao)
git checkout staging
git merge feat/lembrete-email

# 2. QA reprova. A correcao e feita NA FEATURE, nunca na staging
git checkout feat/lembrete-email
git add AgendadorLembretes.cs
git commit -m "feat/lembrete-email: Corrige envio duplicado do lembrete."

# 3. Reintegra a correcao na staging para novo teste
git checkout staging
git merge feat/lembrete-email

# 4. QA aprova. Abre-se o Pull Request feature -> main.
#    Apos o code review e o merge do PR, a producao e atualizada
#    e a branch da feature e excluida:
git branch -d feat/lembrete-email
git push origin --delete feat/lembrete-email
```

**Vantagem desse padrão:** a `staging` funciona como barreira de segurança — a produção só recebe código que passou pela homologação e pelo code review, e a correção na própria feature mantém a história limpa e rastreável.

---

## 3. Desafio da Semana

Simule localmente uma sprint completa do AgendaFácil, exercitando o ciclo Development → Staging → Main de ponta a ponta.

### Requisitos:
1.  Crie uma pasta `agendafacil`, inicialize um repositório Git nela e faça o commit inicial na `main` com um arquivo `README.md` do projeto.
2.  Crie a branch `staging` a partir da `main`.
3.  Volte à `main` e crie a branch `feat/tela-login`. Faça **2 commits** nela (por exemplo, criando os arquivos `login.html` e `validacao.js`).
4.  Integre a `feat/tela-login` na `staging` (simulando o deploy de homologação).
5.  Simule uma reprovação de QA: faça um **3º commit de correção na feat** e integre novamente na `staging`.
6.  Simule a aprovação do PR: integre a `feat/tela-login` na `main` (em um repositório real, este passo seria o merge do Pull Request).
7.  Exclua a branch `feat/tela-login` e confira a árvore de commits com `git log --oneline --graph --all`.

### Estrutura para Desenvolvimento:
```bash
mkdir agendafacil
cd agendafacil
git init

echo "# AgendaFacil" > README.md
git add .
git commit -m "docs: Commit inicial do projeto"

# Continue a partir daqui!
```

---
*Dica: rode `git log --oneline --graph --all` após cada fase para visualizar a árvore de branches se formando — é a melhor forma de "enxergar" o fluxo.*
