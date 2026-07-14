# Aula 1: SQL Básico — CineVista

Nesta lista de exercícios, você colocará em prática as três categorias de comandos do módulo — **DDL** (definição de estruturas), **DML** (manipulação de registros) e **DQL** (consultas) — usando o banco de dados `CineVista`. Cada exercício (e, quando ele mistura categorias, cada item) vem marcado com a categoria que você deverá empregar; cabe a você decidir quais comandos, cláusulas e funções usar. Antes de começar, garanta que o banco foi criado e populado com os scripts da pasta [../guia_estudos/database](../guia_estudos/database).

Lembre-se do padrão do módulo: todo `SELECT` deve usar `WITH(NOLOCK)`; alias de tabela com `AS` maiúsculo e exatamente duas letras minúsculas (ex.: `[dbo].[Cliente] AS cl`); **todos os campos da consulta** devem ter alias de coluna com `as` minúsculo — nunca um campo com alias e outro sem —, aceitos apenas em PascalCase (`cl.Nome as NomeCliente`) ou entre apóstrofos simples (`cl.Nome as 'Nome do cliente'`); e todo `UPDATE`/`DELETE` deve ter cláusula `WHERE`.

---

## Exercício 1: Expandindo o Banco da Nova Unidade — DDL, DML e DQL

### Cenário:
A CineVista inaugurou uma nova unidade e a área comercial decidiu lançar promoções vinculadas a filmes específicos. O time de banco de dados precisa evoluir o schema para suportar a novidade e ajustar alguns cadastros.

### Requisitos:
1. Crie a tabela `[dbo].[Promocao]`, que registrará as promoções vinculadas a filmes. Ela precisa guardar: um identificador próprio (chave primária autoincrementada), o filme a que a promoção se aplica (chave estrangeira para `Filme`), uma descrição, o percentual de desconto e o período de vigência (data de início e data de fim). Escolha os tipos de coluna adequados e nomeie as constraints seguindo os padrões do módulo. **(DDL)**
2. Acrescente à tabela `Cliente` um campo para armazenar o telefone, sem afetar os dados já existentes. **(DDL)**
3. Cadastre três promoções para filmes diferentes já existentes no banco, variando percentuais e vigências. **(DML)**
4. Um cliente informou um novo telefone: atualize apenas o registro dele (escolha um pelo `Id`). **(DML)**
5. Uma das promoções foi cancelada pela diretoria: remova somente esse registro. **(DML)**
6. Para conferir o resultado, exiba as promoções restantes junto ao título do filme correspondente. **(DQL)**

---

## Exercício 2: Relatórios da Bilheteria — DQL

### Cenário:
Toda segunda-feira, a gerência da CineVista analisa o desempenho do fim de semana. Você foi encarregado de montar as consultas do relatório.

### Requisitos:
1. Liste o título, o gênero e a duração dos filmes cujo título contém a letra "o" e cuja duração está entre 100 e 130 minutos, ordenando pela duração em ordem decrescente. **(DQL)**
2. Mostre as 3 sessões mais caras da rede, exibindo `Id`, `DataHora` e `PrecoIngresso`. **(DQL)**
3. Para cada filme que já vendeu ingressos, exiba o título, a quantidade de ingressos e o faturamento total, considerando apenas os filmes que arrecadaram R$ 150,00 ou mais. **(DQL)**
   - Retorno esperado: cada linha representa um filme, com faturamento maior ou igual a 150.
4. Exiba o público total (quantidade de ingressos) por gênero de filme, do maior para o menor público. **(DQL)**
5. Exiba, por sala, o menor e o maior preço de sessão já praticados. **(DQL)**

---

## Exercício 3: Cruzando Dados da Rede — DQL

### Cenário:
O time de marketing está preparando uma campanha de reativação de clientes e uma revisão da grade de programação. As perguntas exigem cruzar várias tabelas.

### Requisitos:
1. Monte uma consulta que, para cada ingresso vendido, exiba o nome do cliente, o título do filme e a data/hora da sessão, ordenando pelo nome do cliente. **(DQL)**
2. Liste os filmes cadastrados que **não** possuem nenhuma sessão programada. **(DQL)**
   - Retorno esperado: pelo menos um filme deve aparecer.
3. Liste os clientes que **nunca** compraram ingresso. **(DQL)**
   - Retorno esperado: pelo menos um cliente deve aparecer.
4. Mostre os 5 ingressos de maior `ValorPago`, exibindo o nome do cliente, o valor pago e a data da compra. **(DQL)**
5. Desafio extra: reaproveite a consulta do item 1 e inclua também o nome da sala em que cada sessão ocorre, mantendo a ordenação pelo nome do cliente. **(DQL)**

---
*Dica: valide cada consulta executando-a no SSMS ou no Azure Data Studio e confira se o resultado faz sentido com os dados populados pelo script da pasta database.*
