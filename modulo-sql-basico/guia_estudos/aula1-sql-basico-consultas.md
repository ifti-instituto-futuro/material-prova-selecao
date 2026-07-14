# Aula 1: SQL Básico no SQL Server — do CREATE ao SELECT

Bem-vindo ao módulo de SQL Básico! Nesta aula, aprenderemos a criar estruturas de banco de dados, manipular registros e, principalmente, consultar dados no **Microsoft SQL Server**. Todo o conteúdo é aplicado ao cenário da **CineVista (Rede de Cinemas)**, cujo banco de dados você mesmo criará ao longo dos estudos.

---

## 1. Conceitos Teóricos

### 1.1. SQL Server e as Categorias de Comandos

O SQL (Structured Query Language) é a linguagem padrão para trabalhar com bancos de dados relacionais. No dia a dia, seus comandos são agrupados em categorias:

| Categoria | Significado | Comandos principais |
| :--- | :--- | :--- |
| **DDL** | Data Definition Language — define estruturas. | `CREATE`, `ALTER`, `DROP` |
| **DML** | Data Manipulation Language — manipula registros. | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** | Data Query Language — consulta registros. | `SELECT` |

Os tipos de dados mais usados no SQL Server:

*   `INT` — números inteiros (Ids, quantidades).
*   `VARCHAR(n)` — textos de tamanho variável (nomes, e-mails).
*   `DATE` / `DATETIME` — datas, com ou sem horário.
*   `DECIMAL(10,2)` — valores monetários com precisão exata (nunca use tipos de ponto flutuante para dinheiro).
*   `BIT` — verdadeiro/falso (1/0).

### 1.2. DDL: Criando Bancos e Tabelas

A criação de estruturas segue o padrão abaixo. Repare nas convenções importantes: o esquema explícito `[dbo].[Tabela]`, a chave primária `Id` com `IDENTITY` (numeração automática) e **toda chave declarada como constraint nomeada** — a chave primária também é uma constraint, nomeada no padrão `PK_Tabela`, e as chaves estrangeiras seguem o padrão `FK_IdColuna_Tabela`. Note ainda que a coluna `Id` **não** leva `NOT NULL`: uma chave primária com `IDENTITY` já é, por definição, obrigatória.

```sql
CREATE DATABASE cinevista;
GO

USE cinevista;
GO

CREATE TABLE [dbo].[Sessao] (
    Id INT IDENTITY,
    IdFilme INT NOT NULL,
    IdSala INT NOT NULL,
    DataHora DATETIME NOT NULL,
    PrecoIngresso DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Sessao PRIMARY KEY (Id),
    CONSTRAINT FK_IdFilme_Sessao FOREIGN KEY (IdFilme) REFERENCES [dbo].[Filme] (Id),
    CONSTRAINT FK_IdSala_Sessao FOREIGN KEY (IdSala) REFERENCES [dbo].[Sala] (Id)
);
GO
```

A chave estrangeira (FK) garante a integridade: o banco recusa uma sessão cujo `IdFilme` não exista na tabela `Filme`.

> **Ordem de criação importa.** Uma tabela com `FOREIGN KEY` depende da tabela referenciada **já existir**. No exemplo acima, `Sessao` aponta para `Filme` e `Sala` — logo, `Filme` e `Sala` precisam ser criadas **antes** de `Sessao`. A regra geral: crie primeiro as tabelas **independentes** e, só depois, as **dependentes**. (Por isso o script `criar_banco.sql` segue exatamente essa ordem.) Tentar criar a tabela dependente primeiro faz o banco recusar a FK, pois a tabela referenciada ainda não existe.

Para evoluir ou remover estruturas existentes:

```sql
-- Adicionar uma coluna a uma tabela ja criada
ALTER TABLE [dbo].[Cliente]
	ADD Telefone VARCHAR(20) NULL;

-- Remover uma tabela (cuidado: apaga estrutura e dados!)
DROP TABLE [dbo].[NomeDaTabela];
```

O script completo de criação do banco está em [database/criar_banco.sql](database/criar_banco.sql) — ele é o exemplo vivo desta seção.

### 1.3. DML: Inserindo e Alterando Dados

```sql
-- INSERT: informe as colunas e os valores na mesma ordem
INSERT INTO [dbo].[Sala] (Nome, Capacidade, Tipo) VALUES
('Sala 1', 120, '2D'),
('Sala IMAX', 60, 'IMAX');

-- UPDATE: altera registros existentes
UPDATE [dbo].[Sala]
	SET Capacidade = 110
	WHERE Nome = 'Sala 1';

-- DELETE: remove registros
DELETE
	FROM [dbo].[Sala]
	WHERE Id = 4;
```

> **Atenção:** `UPDATE` e `DELETE` **sem cláusula `WHERE` afetam a tabela inteira**. Antes de executar qualquer um dos dois, rode um `SELECT` com o mesmo `WHERE` para conferir exatamente quais linhas serão atingidas. Esse hábito evita desastres em produção.

### 1.4. SELECT, WHERE e ORDER BY

O `SELECT` é o comando que você mais usará na carreira. A estrutura básica:

```sql
SELECT	fi.Titulo as Titulo,
		fi.Genero as Genero,
		fi.DuracaoMinutos as DuracaoMinutos
	FROM [dbo].[Filme] AS fi WITH(NOLOCK)
	WHERE fi.Genero = 'Drama'
	ORDER BY fi.Titulo ASC;
```

> **Padrão SMN — `WITH(NOLOCK)`:** nas consultas `SELECT`, usamos sempre a dica `WITH(NOLOCK)` após o nome da tabela. Ela evita que a leitura fique bloqueada por outras operações em andamento no banco. Os detalhes de concorrência e travas serão estudados no módulo de SQL Programação; por enquanto, adote o padrão em todos os seus `SELECT`s.

Recursos que enriquecem a consulta:

```sql
-- DISTINCT: elimina valores repetidos
SELECT	DISTINCT fi.Genero as Genero
	FROM [dbo].[Filme] AS fi WITH(NOLOCK);

-- TOP: limita a quantidade de linhas retornadas
SELECT	TOP 3 fi.Titulo as Titulo,
		      fi.DuracaoMinutos as DuracaoMinutos
	FROM [dbo].[Filme] AS fi WITH(NOLOCK)
	ORDER BY fi.DuracaoMinutos DESC;

-- Operadores de filtro mais comuns
SELECT	cl.Nome as NomeCliente,
		cl.Cidade as CidadeCliente
	FROM [dbo].[Cliente] AS cl WITH(NOLOCK)
	WHERE cl.Nome LIKE 'A%'                              -- comeca com A
		AND cl.Cidade IN ('Natal', 'Parnamirim')         -- lista de valores
		AND cl.DataCadastro BETWEEN '2026-01-01' AND '2026-06-30'; -- intervalo

-- IS NULL / IS NOT NULL: testa ausencia de valor
SELECT	cl.Nome as NomeCliente
	FROM [dbo].[Cliente] AS cl WITH(NOLOCK)
	WHERE cl.Email IS NOT NULL;
```

> **Alinhamento dos campos:** os campos da lista do `SELECT` ficam sempre alinhados entre si, um embaixo do outro. Quando houver `TOP N` ou `DISTINCT`, o campo da linha seguinte alinha com o **campo** da linha de cima — e não com o `TOP N` ou `DISTINCT` (repare no exemplo do `TOP 3` acima: `fi.DuracaoMinutos` está alinhado com `fi.Titulo`).

Os **aliases** seguem um padrão fixo no módulo, por boas práticas:

*   Alias de **tabela**: palavra-chave `AS` em maiúsculas e **exatamente duas letras minúsculas** (`cl` para `Cliente`, `fi` para `Filme`, `sa` para `Sala`, `se` para `Sessao`, `ig` para `Ingresso`).
*   Alias de **coluna**: palavra-chave `as` em minúsculas, e **todos os campos da consulta devem ter alias** — nunca deixe um campo com alias e outro sem no mesmo `SELECT`.
*   Só existem **duas formas aceitas** para o alias de coluna: **PascalCase** (`NomeCliente`) ou **entre apóstrofos simples** (`'Nome do cliente'`) — e não se misturam as duas formas na mesma consulta.

```sql
-- Forma 1: alias em PascalCase
SELECT	cl.Nome as NomeCliente,
		cl.Cidade as CidadeCliente
	FROM [dbo].[Cliente] AS cl WITH(NOLOCK)
	ORDER BY cl.Cidade ASC, cl.Nome ASC;

-- Forma 2: alias entre apostrofos simples (rotulo legivel para relatorios)
SELECT	cl.Nome as 'Nome do cliente',
		cl.Cidade as 'Cidade do cliente'
	FROM [dbo].[Cliente] AS cl WITH(NOLOCK)
	ORDER BY cl.Cidade ASC, cl.Nome ASC;
```

> Observação: `in` seria o alias natural de `Ingresso`, mas `IN` é palavra reservada do SQL — por isso este módulo adota `ig`.

### 1.5. Funções de Agregação, GROUP BY e HAVING

Funções de agregação resumem um conjunto de linhas em um único valor:

| Função | O que faz |
| :--- | :--- |
| `COUNT(*)` | Conta linhas. |
| `SUM(coluna)` | Soma valores. |
| `AVG(coluna)` | Média dos valores. |
| `MIN(coluna)` / `MAX(coluna)` | Menor / maior valor. |

Com `GROUP BY`, o resumo é calculado **por grupo**:

```sql
-- Quantidade de filmes e duracao media por genero
SELECT	fi.Genero as Genero,
		COUNT(*) as QuantidadeFilmes,
		AVG(fi.DuracaoMinutos) as DuracaoMedia
	FROM [dbo].[Filme] AS fi WITH(NOLOCK)
	GROUP BY fi.Genero
	HAVING COUNT(*) >= 2
	ORDER BY QuantidadeFilmes DESC;
```

A diferença essencial entre os dois filtros:

*   `WHERE` filtra **linhas**, antes do agrupamento.
*   `HAVING` filtra **grupos**, depois do agrupamento (por isso pode usar funções de agregação).

### 1.6. JOINs: Cruzando Tabelas

Os dados relacionais vivem espalhados em várias tabelas; o `JOIN` os reúne. Usamos os **aliases de tabela** do padrão do módulo (`AS` + duas letras minúsculas) para encurtar a escrita:

```sql
-- INNER JOIN: somente sessoes que possuem filme e sala correspondentes
SELECT	fi.Titulo as TituloFilme,
		sa.Nome as NomeSala,
		se.DataHora as DataHora,
		se.PrecoIngresso as PrecoIngresso
	FROM [dbo].[Sessao] AS se WITH(NOLOCK)
		INNER JOIN [dbo].[Filme] AS fi WITH(NOLOCK)
			ON se.IdFilme = fi.Id
		INNER JOIN [dbo].[Sala] AS sa WITH(NOLOCK)
			ON se.IdSala = sa.Id
	ORDER BY se.DataHora;
```

*   **INNER JOIN**: retorna apenas as linhas com correspondência nas duas tabelas.
*   **LEFT JOIN**: retorna todas as linhas da tabela da esquerda, preenchendo com `NULL` quando não há correspondência na direita.
*   **RIGHT JOIN**: o inverso do LEFT (na prática, prefira reescrever como LEFT).

O padrão `LEFT JOIN ... WHERE ... IS NULL` responde perguntas do tipo "quem **não** tem":

```sql
-- Filmes que ainda nao possuem nenhuma sessao programada
SELECT	fi.Titulo as TituloFilme
	FROM [dbo].[Filme] AS fi WITH(NOLOCK)
		LEFT JOIN [dbo].[Sessao] AS se WITH(NOLOCK)
			ON se.IdFilme = fi.Id
	WHERE se.Id IS NULL;
```

### 1.7. Subqueries — tema do próximo módulo

Uma **subquery** (subconsulta) é um `SELECT` dentro de outro comando — usada, por exemplo, para filtros de existência ("quem **não** tem") e comparações com valores agregados ("acima da média"). Esse assunto **não faz parte deste módulo básico**: ele será estudado no módulo de **SQL Programação**, depois que os fundamentos de `SELECT`, `WHERE`, `ORDER BY`, `JOIN`, agregações e relacionamentos estiverem bem firmes. Introduzi-lo cedo demais só aumenta a complexidade antes da hora.

Por ora, guarde uma ideia útil: perguntas do tipo "quem **não** tem" já são respondidas com o padrão **`LEFT JOIN ... WHERE ... IS NULL`** da seção 1.6 — sem precisar de subquery.

---

## 2. Estudo de Caso Prático: CineVista

Vamos aplicar os conceitos em duas necessidades reais da rede de cinemas.

### Caso A: Relatório de Bilheteria por Filme

A diretoria quer saber quanto cada filme arrecadou e quantos ingressos vendeu, exibindo apenas os filmes com faturamento relevante:

```sql
SELECT	fi.Titulo as TituloFilme,
		fi.Genero as Genero,
		COUNT(ig.Id) as IngressosVendidos,
		SUM(ig.ValorPago) as Faturamento
	FROM [dbo].[Ingresso] AS ig WITH(NOLOCK)
		INNER JOIN [dbo].[Sessao] AS se WITH(NOLOCK)
			ON ig.IdSessao = se.Id
		INNER JOIN [dbo].[Filme] AS fi WITH(NOLOCK)
			ON se.IdFilme = fi.Id
	GROUP BY fi.Titulo, fi.Genero
	HAVING SUM(ig.ValorPago) >= 100.00
	ORDER BY Faturamento DESC;
```

**Vantagem desse padrão:** uma única consulta cruza três tabelas e entrega a resposta pronta para a área de negócio, sem necessidade de pós-processamento na aplicação.

---

### Caso B: Clientes Inativos e Sessões Premium

O marketing precisa de duas listas: clientes cadastrados que nunca compraram ingresso (para uma campanha de reativação) e as sessões de maior preço da rede (para avaliar a política de preços):

```sql
-- Lista 1: clientes que nunca compraram (LEFT JOIN sem correspondencia)
SELECT	cl.Nome as NomeCliente,
		cl.Email as EmailCliente,
		cl.DataCadastro as DataCadastro
	FROM [dbo].[Cliente] AS cl WITH(NOLOCK)
		LEFT JOIN [dbo].[Ingresso] AS ig WITH(NOLOCK)
			ON ig.IdCliente = cl.Id
	WHERE ig.Id IS NULL;

-- Lista 2: as 5 sessoes mais caras da rede (ranking com TOP + ORDER BY)
SELECT	TOP 5 fi.Titulo as TituloFilme,
			  se.DataHora as DataHora,
			  se.PrecoIngresso as PrecoIngresso
	FROM [dbo].[Sessao] AS se WITH(NOLOCK)
		INNER JOIN [dbo].[Filme] AS fi WITH(NOLOCK)
			ON se.IdFilme = fi.Id
	ORDER BY se.PrecoIngresso DESC;
```

**Vantagem desse padrão:** o `LEFT JOIN ... IS NULL` responde perguntas de "ausência" ("quem nunca comprou"), e o `TOP N` com `ORDER BY` entrega um **ranking** (as N maiores ou menores) — duas análises que aparecem o tempo inteiro em relatórios corporativos, sem exigir subquery.

---

## 3. Desafio da Semana

A gerência da CineVista pediu um painel mensal com indicadores da rede. Monte um único script que responda aos itens abaixo. Cada item indica a categoria de comando — **DDL**, **DML** ou **DQL** — que você deverá empregar; escolha os comandos, cláusulas e funções adequados.

### Requisitos:
1.  **Ocupação por sala:** para cada sala, exiba o nome, a capacidade e o total de ingressos vendidos (todas as sessões somadas), ordenando da sala mais movimentada para a menos movimentada. **(DQL)**
2.  **Gêneros de destaque:** liste os gêneros de filme com mais de 5 ingressos vendidos no total, exibindo o gênero e a quantidade. **(DQL)**
3.  **Novidade em cartaz:** cadastre um novo filme de sua escolha e, em seguida, crie uma sessão para ele na `Sala 3` — lembre-se de que o filme e a sala precisam existir antes da sessão. **(DML)**
4.  **Reajuste premium:** aplique um aumento de 10% no `PrecoIngresso` de todas as sessões realizadas em salas do tipo `IMAX`. **(DML)**

### Estrutura para Desenvolvimento:
```sql
USE cinevista;
GO

-- 1. Ocupacao por sala
-- Insira sua consulta aqui!

-- 2. Generos de destaque
-- Insira sua consulta aqui!

-- 3. Novidade em cartaz
-- Insira seus comandos aqui!

-- 4. Reajuste premium
-- Insira seu comando aqui!
```

---
*Dica: antes de aplicar a alteração do item 4, rode uma consulta com o mesmo filtro para conferir quais sessões serão reajustadas — esse é o hábito que separa um iniciante de um profissional cuidadoso.*
