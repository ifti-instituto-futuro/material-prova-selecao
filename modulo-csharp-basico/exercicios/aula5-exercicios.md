# Aula 5: Coleções Dinâmicas — Cadastros e Consolidação de Dados

Nesta lista de exercícios, você colocará em prática as listas paralelas (Add, `IndexOf` + atualização, `Contains`, remoção sincronizada com `RemoveAt`), a consolidação de coleções (`AddRange`, dedup manual, `Sort()`), o tratamento de lista vazia e as análises por faixa. Os três primeiros exercícios acontecem na PedalUrbano; o último simula uma questão de prova em outro cenário.

Lembre-se do padrão do módulo: chaves `{}` apenas em blocos com **mais de uma instrução** — bloco de uma única instrução fica sem chaves, apenas indentado.

---

## Exercício 1 (guiado): Lojinha de Acessórios

### Cenário:
A lojinha da PedalUrbano vende acessórios e controla o estoque com listas paralelas. Você vai implementar as operações do dia seguindo os TODOs.

### Requisitos:
1. Copie o esqueleto e resolva um TODO por vez, rodando `dotnet run` a cada passo.
2. No TODO 1, exiba o estoque inicial percorrendo as duas listas com um único `for` (formato `Capacete: 10 unidades`).
3. No TODO 2, adicione o produto `"Luva"` com 25 unidades — `Add` **nas duas listas**.
4. No TODO 3, atualize a quantidade de `"Garrafa"` para 5: localize com `IndexOf`, confira `>= 0` e atualize a lista de quantidades pelo índice.
5. No TODO 4, verifique com `Contains` se `"Capa de chuva"` existe e exiba a resposta como Sim/Não.
6. No TODO 5, remova `"Cadeado"` de forma **sincronizada**: `IndexOf` uma vez, `RemoveAt` nas duas listas.
7. No TODO 6, exiba o estoque final e o total de unidades (acumulador da Aula 4).

```csharp
// Program.cs - Lojinha de acessorios
List<string> produtos = new List<string> { "Capacete", "Garrafa", "Cadeado", "Farol" };
List<int> quantidades = new List<int> { 10, 18, 7, 12 };

Console.WriteLine("=== LOJINHA PEDALURBANO ===");

// TODO 1: exibir o estoque inicial (um unico for para as duas listas)
// TODO 2: adicionar "Luva" (25) nas DUAS listas
// TODO 3: atualizar "Garrafa" para 5 (IndexOf + indice)
// TODO 4: verificar se "Capa de chuva" existe (Contains)
// TODO 5: remover "Cadeado" de forma sincronizada (IndexOf + RemoveAt nas duas)
// TODO 6: estoque final + total de unidades
```

---

## Exercício 2: Consolidação de Check-ins

### Cenário:
Duas estações registraram os códigos das bikes que passaram pelo check-in hoje — a estação Centro em um array (sistema antigo) e a estação Parque em uma lista (sistema novo). Bikes que passaram pelas duas aparecem repetidas.

### Requisitos:
1. Declare `string[] centro = { "PU-0042", "PU-0013", "PU-0007", "PU-0042" };` e `List<string> parque = new List<string> { "PU-0007", "PU-0101", "PU-0013" };`.
2. Unifique tudo em uma única `List<string>` com `AddRange` e exiba a contagem unificada.
3. Remova os duplicados com o dedup manual (`foreach` + `Contains` + `Add`) e exiba a contagem de bikes únicas.
4. Ordene com `Sort()` e exiba a lista final numerada.
5. Exiba quantos registros duplicados foram descartados (contagem unificada menos contagem única).
6. Teste o caso especial: comente as linhas que preenchem as fontes, deixe as coleções vazias e confira que o programa exibe `"Nenhum check-in registrado"` em vez de quebrar.

---

## Exercício 3: Painel de Baterias

### Cenário:
As bikes elétricas reportam o nível de bateria (em %) por dois canais independentes. A central consolida as leituras e analisa a saúde da frota por faixas.

### Requisitos:
1. Declare `int[] canalA = { 85, 42, 15, 85, 60 };` e `List<int> canalB = new List<int> { 42, 98, 15, 73 };`.
2. Consolide: unifique com `AddRange`, remova duplicados na mão e ordene em ordem crescente.
3. Se a lista final ficar vazia, exiba `"Nenhuma leitura valida"` e encerre; senão, exiba as leituras ordenadas.
4. Como a lista está ordenada, pegue o menor nível em `[0]` e o maior em `[Count - 1]`.
5. Conte quantas leituras estão na faixa saudável (entre 40% e 80%, **inclusive**) usando `>=` e `<=`.
6. Verifique com uma flag `bool` se alguma bike está em nível crítico (abaixo de 20%) e exiba `Alerta de bateria critica: Sim/Nao`.
7. Feche com o resumo: total de leituras distintas, menor, maior, contagem na faixa saudável e o alerta.

---

## Exercício 4 (livre): Estoque da Farmácia

### Cenário:
Uma farmácia gerencia seu estoque de forma dinâmica, com consultas, atualizações e remoções ao longo do dia. Resolva como uma questão de prova: sem passos guiados, apenas com as operações e a saída esperada.

O estoque atual tem: 25 unidades de Dipirona, 8 de Vitamina C, 4 de Protetor Solar e 12 de Termômetro. O sistema deve: exibir o estoque inicial; adicionar o produto "Mascara" com 30 unidades; atualizar a quantidade de "Protetor Solar" para 15; verificar se existe "Soro" no estoque; contar quantos produtos têm estoque abaixo de 10 unidades; remover o produto "Termometro"; e exibir o estoque final com o total de unidades.

### Saída Esperada:

```
=== ESTOQUE INICIAL ===
Dipirona: 25 unidades
Vitamina C: 8 unidades
Protetor Solar: 4 unidades
Termometro: 12 unidades

=== OPERACOES ===
Produto adicionado: Mascara (30 unidades)
Quantidade atualizada: Protetor Solar (15 unidades)
Produto "Soro" existe? Nao
Produtos com estoque baixo (< 10): 1

=== ESTOQUE FINAL ===
Dipirona: 25 unidades
Vitamina C: 8 unidades
Protetor Solar: 15 unidades
Mascara: 30 unidades

Total de unidades: 78
```

---
*Dica: no exercício 4, repare que a contagem de estoque baixo acontece DEPOIS da atualização do Protetor Solar — por isso o resultado é 1, não 2. Em prova, a ordem das operações no enunciado é parte da resposta.*
