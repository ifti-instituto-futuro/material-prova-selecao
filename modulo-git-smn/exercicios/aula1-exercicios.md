# Aula 1: Git Essencial e o Fluxo Git SMN

Nesta lista de exercícios, você praticará o ciclo básico do Git, o trabalho com branches e o fluxo Git SMN, no papel de um novo desenvolvedor do squad AgendaFácil da Horizonte Sistemas. Todos os exercícios podem ser feitos em pastas locais vazias — onde houver `push`, considere o comando ilustrativo (ou configure um remoto de testes, se quiser ir além).

---

## Exercício 1: Primeiro Commit no AgendaFácil

### Cenário:
É o seu primeiro dia no squad. Antes de tocar no código do AgendaFácil, você precisa configurar sua identidade no Git e provar que domina o ciclo básico de versionamento.

### Requisitos:
1. Configure seu nome e e-mail no Git (`git config`), os mesmos que apareceriam nos commits do time.
2. Crie uma pasta `exercicio-git-1`, entre nela e inicialize um repositório com `git init`.
3. Crie um arquivo `anotacoes.md` com qualquer conteúdo e rode `git status`. Registre (em comentário ou anotação) em qual estado o arquivo aparece.
4. Prepare o arquivo com `git add` e rode `git status` novamente, observando a mudança de estado.
5. Faça o commit com uma mensagem curta, no imperativo, seguindo o padrão do time (ex.: "Adiciona anotacoes do onboarding").
6. Altere o conteúdo do arquivo, rode `git diff` para ver a diferença, e faça um segundo commit.
7. Exiba o histórico com `git log --oneline` e confira se os dois commits aparecem.

---

## Exercício 2: Feature Branch na Prática

### Cenário:
Você recebeu sua primeira tarefa da sprint: iniciar o "cadastro de cliente" do AgendaFácil. O trabalho deve ser feito em uma branch de feature, como manda o fluxo do time — e, no meio do caminho, você enfrentará seu primeiro conflito de merge.

### Requisitos:
1. Em um novo repositório (ou no do exercício 1), garanta que está na `main` e crie a branch `feat/cadastro-cliente` com `git checkout -b`.
2. Na feature, crie o arquivo `cadastro.md` com uma linha descrevendo a funcionalidade e faça um commit. Depois, adicione mais uma linha e faça um segundo commit.
3. Alterne entre `main` e a feature com `git switch` (ou `git checkout`) e observe o arquivo `cadastro.md` aparecer e sumir do working directory. Explique por que isso acontece.
4. Provoque um conflito controlado: na `main`, crie um commit alterando a **primeira linha** de um arquivo que também exista na feature (crie o arquivo nas duas branches, com conteúdos diferentes na mesma linha); em seguida, faça o merge da feature na `main`.
5. Resolva o conflito: abra o arquivo, escolha o conteúdo final, remova os marcadores de conflito, finalize com `git add` e `git commit`.
6. Explique com suas palavras o que significam os marcadores `<<<<<<<`, `=======` e `>>>>>>>` que o Git inseriu no arquivo.

---

## Exercício 3: Promovendo Código no Fluxo SMN

### Cenário:
Sua feature foi aprovada pelo time e agora precisa percorrer o caminho oficial até a produção, seguindo o manual do Gitflow SMN. Além de executar os comandos, você deverá demonstrar que entende as regras do fluxo.

### Requisitos:
1. Monte um repositório com as branches `main` (com um commit inicial) e `staging`, e uma branch `feat/relatorio-consultas` criada a partir da `main` com pelo menos 1 commit.
2. Integre a feature na `staging`, simulando o envio para homologação.
3. Responda (em comentário no seu roteiro ou em um arquivo de respostas): por que o fluxo SMN **proíbe** o merge de `staging` para `main`?
4. Simule o reset da `staging`: exclua a branch e recrie-a a partir da `main`, como o time faz quando o ambiente de homologação fica instável.
5. Liste, na ordem correta, **todos** os comandos do ciclo completo Development → Staging → Main para uma nova feature — da atualização da `main` local até a exclusão da branch de feature.
6. Encontre os **2 erros** no roteiro abaixo, explique por que cada um viola o fluxo SMN e escreva a versão corrigida:
   ```bash
   git checkout staging
   git checkout -b feat/notificacao-sms
   git add .
   git commit -m "feat/notificacao-sms: Adiciona notificacao por SMS."
   git checkout staging
   git merge feat/notificacao-sms
   # QA aprovou a funcionalidade
   git checkout main
   git merge staging
   ```

---
*Dica: no exercício 3, lembre-se das duas regras de ouro do fluxo: de onde a feature nasce e de onde a produção recebe código.*
