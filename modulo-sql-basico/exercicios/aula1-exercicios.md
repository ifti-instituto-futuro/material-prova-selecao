# Aula 1: SQL Básico — CineVista

Nesta lista de exercícios, você colocará em prática DDL, DML, consultas com filtros, funções de agregação, JOINs e subqueries usando o banco de dados `CineVista`. Antes de começar, garanta que o banco foi criado e populado com os scripts da pasta [../guia_estudos/database](../guia_estudos/database).

Lembre-se do padrão do módulo: todo `SELECT` deve usar `WITH(NOLOCK)`; alias de tabela com `AS` maiúsculo e exatamente duas letras minúsculas (ex.: `[dbo].[Cliente] AS cl`); **todos os campos da consulta** devem ter alias de coluna com `as` minúsculo — nunca um campo com alias e outro sem —, aceitos apenas em PascalCase (`cl.Nome as NomeCliente`) ou entre apóstrofos simples (`cl.Nome as 'Nome do cliente'`); e todo `UPDATE`/`DELETE` deve ter cláusula `WHERE`.

---

## Exercício 1: Expandindo o Banco da Nova Unidade

### Cenário:
A CineVista inaugurou uma nova unidade e a área comercial decidiu lançar promoções vinculadas a filmes específicos. O time de banco de dados precisa evoluir o schema para suportar a novidade e ajustar alguns cadastros.

### Requisitos:
1. Crie a tabela `[dbo].[Promocao]` com as colunas: `Id` (chave primária com `IDENTITY`, declarada como constraint nomeada no padrão `PK_Promocao`), `IdFilme` (obrigatória, chave estrangeira para `Filme` com constraint nomeada no padrão `FK_IdFilme_Promocao`), `Descricao` (`VARCHAR(100)`, obrigatória), `PercentualDesconto` (`DECIMAL(5,2)`, obrigatória) e `DataInicio` / `DataFim` (`DATE`, obrigatórias).
2. Use `ALTER TABLE` para adicionar a coluna `Telefone` (`VARCHAR(20)`, opcional) na tabela `Cliente`.
3. Insira 3 promoções para filmes diferentes já cadastrados no banco, com percentuais e vigências variados.
4. Atualize o telefone de um cliente específico (escolha um pelo `Id`), usando `UPDATE` com `WHERE`.
5. Uma das promoções foi cancelada pela diretoria: exclua-a usando `DELETE` com `WHERE` pelo `Id`.
6. Ao final, escreva um `SELECT` que liste as promoções restantes com o título do filme correspondente, para conferir o resultado.

---

## Exercício 2: Relatórios da Bilheteria

### Cenário:
Toda segunda-feira, a gerência da CineVista analisa o desempenho do fim de semana. Você foi encarregado de montar as consultas do relatório.

### Requisitos:
1. Liste o título, o gênero e a duração dos filmes cujo título contém a letra "o" e cuja duração está entre 100 e 130 minutos (use `LIKE` e `BETWEEN`), ordenando pela duração em ordem decrescente.
2. Liste as 3 sessões mais caras da rede, exibindo `Id`, `DataHora` e `PrecoIngresso` (use `TOP` com `ORDER BY`).
3. Para cada filme com ingresso vendido, exiba o título, a quantidade de ingressos e o faturamento total (`SUM(ValorPago)`), mas somente para filmes que faturaram R$ 150,00 ou mais (use `GROUP BY` e `HAVING`).
   - Retorno esperado: cada linha representa um filme, com faturamento maior ou igual a 150.
4. Exiba o público total (quantidade de ingressos) por gênero de filme, do maior para o menor público.
5. Exiba, por sala, o menor e o maior preço de sessão já praticados (use `MIN` e `MAX` agrupando pelo nome da sala).

---

## Exercício 3: Cruzando Dados da Rede

### Cenário:
O time de marketing está preparando uma campanha de reativação de clientes e uma revisão da grade de programação. As perguntas exigem cruzar várias tabelas.

### Requisitos:
1. Monte uma consulta com JOIN de 3 tabelas exibindo: nome do cliente, título do filme e data/hora da sessão de cada ingresso vendido, ordenando pelo nome do cliente.
2. Liste os filmes cadastrados que **não** possuem nenhuma sessão programada (use `LEFT JOIN ... WHERE ... IS NULL`).
   - Retorno esperado: pelo menos um filme deve aparecer.
3. Liste os clientes que **nunca** compraram ingresso, usando `NOT IN` com subquery sobre a tabela `Ingresso`.
   - Retorno esperado: pelo menos um cliente deve aparecer.
4. Liste os ingressos cujo `ValorPago` está acima da média geral de todos os ingressos (subquery escalar com `AVG`), exibindo o nome do cliente, o valor pago e a data da compra.
5. Desafio extra: reescreva a consulta do item 3 usando `LEFT JOIN ... IS NULL` em vez de `NOT IN` e compare os resultados — eles devem ser idênticos.

---
*Dica: valide cada consulta executando-a no SSMS ou no Azure Data Studio e confira se o resultado faz sentido com os dados populados pelo script da pasta database.*
