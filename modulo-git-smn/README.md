# Módulo Git e Fluxo Git SMN

Bem-vindo ao repositório do **Módulo de Git e Fluxo Git SMN**.

Este material foi elaborado para capacitar novos desenvolvedores no versionamento de código com Git e no fluxo de trabalho oficial da SMN. Todo o conteúdo prático é baseado no cenário da **Horizonte Sistemas**, uma software house fictícia cujo squad desenvolve o **AgendaFácil** (sistema de agendamento online), aproximando a teoria da rotina real de um time de desenvolvimento.

## Estrutura do Curso

O conteúdo está organizado em uma aula única, com guia teórico, estudo de caso e desafio prático.

1. **Aula 1: Git Essencial e o Fluxo Git SMN**
   - Fundamentos: repositório, working directory, staging area e commits.
   - Ciclo básico: `init`, `status`, `add`, `commit`, `diff` e `log`.
   - Remotos: `origin`, `push`, `pull` e `fetch`.
   - Branches, merge (fast-forward e merge commit) e resolução de conflitos.
   - O fluxo Git SMN: branches `main`, `staging` e `feature/*` e o ciclo Development, Staging e Main.
   - Comparativo: Gitflow tradicional vs. Gitflow SMN.

## Padrões e Convenções (Guidelines)

Este módulo segue as regras do Gitflow SMN:

- Branches de trabalho nomeadas no padrão `feature/nome-da-funcionalidade`.
- Mensagens de commit curtas, no imperativo, descrevendo o que a mudança faz.
- `main` é protegida: alterações somente via Pull Request aprovado.
- É **vedado** o merge de `staging` para `main`.
- `staging` é volátil e pode ser recriada a partir da `main` a qualquer momento.
- Toda feature nasce da `main` atualizada e é excluída após a entrega.

## Organização do Repositório

- [guia_estudos](guia_estudos/README.md): apostila da aula, diagrama do fluxo e regras do Gitflow SMN.
- [exercicios](exercicios/README.md): lista de exercícios práticos da aula.

## Como Começar

1. Instale o Git ([git-scm.com](https://git-scm.com)) e confirme com `git --version`.
2. Configure sua identidade: `git config --global user.name "Seu Nome"` e `git config --global user.email "seu@email.com"`.
3. Siga a trilha de leitura a partir de [guia_estudos/README.md](guia_estudos/README.md).

---
*Desenvolvido para o Instituto Futuro.*
