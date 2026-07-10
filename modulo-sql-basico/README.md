# Módulo SQL Básico

Bem-vindo ao repositório do **Módulo de SQL Básico**.

Este material foi elaborado para introduzir a criação, manipulação e consulta de dados no **Microsoft SQL Server**. Todo o conteúdo prático é baseado no cenário da **CineVista**, uma rede de cinemas fictícia, aproximando a teoria dos desafios reais de quem trabalha com dados no dia a dia.

**Escopo do módulo:** DDL, DML, consultas (`SELECT`), funções de agregação, JOINs e subqueries. Modelagem de dados (ER/normalização) e índices **não** fazem parte deste módulo — o diagrama do guia de estudos serve apenas como mapa de leitura do banco pronto.

## Estrutura do Curso

O conteúdo está organizado em uma aula única, com guia teórico, estudo de caso e desafio prático.

1. **Aula 1: SQL Básico no SQL Server — do CREATE ao SELECT**
   - Categorias de comandos (DDL, DML, DQL) e tipos de dados.
   - DDL: `CREATE DATABASE`, `CREATE TABLE`, chaves primárias/estrangeiras, `ALTER` e `DROP`.
   - DML: `INSERT`, `UPDATE` e `DELETE`.
   - `SELECT` com `WHERE`, `ORDER BY`, `DISTINCT`, `TOP`, `LIKE`, `BETWEEN` e `IN`.
   - Funções de agregação (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`), `GROUP BY` e `HAVING`.
   - JOINs (`INNER`, `LEFT`, `RIGHT`) e subqueries.

## Padrões de Código (Guidelines)

Este repositório segue os padrões corporativos da SMN, adaptados ao nível básico:

- Uso obrigatório de `WITH(NOLOCK)` em consultas `SELECT`.
- Tabelas sempre qualificadas com o esquema: `[dbo].[Tabela]`.
- **Toda chave é uma constraint nomeada**: chave primária no padrão `PK_Tabela` e chave estrangeira no padrão `FK_IdColuna_Tabela` (ex.: `PK_Sessao`, `FK_IdFilme_Sessao`). A chave primária com `IDENTITY` dispensa `NOT NULL` — já é obrigatória por definição.
- Alias de tabela com `AS` maiúsculo e **exatamente duas letras minúsculas**; alias de coluna com `as` minúsculo em **todos** os campos da consulta (nunca um campo com alias e outro sem), aceito apenas em PascalCase ou entre apóstrofos simples (ex.: `SELECT cl.Nome as NomeCliente FROM [dbo].[Cliente] AS cl WITH(NOLOCK)` ou `cl.Nome as 'Nome do cliente'`).
- **Nunca** execute `UPDATE` ou `DELETE` sem cláusula `WHERE`.
- Palavras-chave SQL em MAIÚSCULAS (`SELECT`, `FROM`, `WHERE`...).

## Organização do Repositório

- [guia_estudos](guia_estudos/README.md): apostila da aula, diagrama do banco e scripts de setup (pasta `database`).
- [exercicios](exercicios/README.md): lista de exercícios práticos da aula.

## Como Começar

1. Instale o SQL Server (edição Developer ou Express) e o SQL Server Management Studio (SSMS). Link para baixar: [SSMS](https://aka.ms/ssms/22/release/vs_SSMS.exe)
2. Execute os scripts [guia_estudos/database/criar_banco.sql](guia_estudos/database/criar_banco.sql) e [guia_estudos/database/popular_banco.sql](guia_estudos/database/popular_banco.sql), nesta ordem.
3. Siga a trilha de leitura a partir de [guia_estudos/README.md](guia_estudos/README.md).

---
*Desenvolvido para o Instituto Futuro.*
