# Aula 5: Coleções Dinâmicas — Cadastros e Consolidação de Dados

Última aula do módulo! Na Aula 1 você conheceu arrays e `List<T>`; na Aula 4, os percorreu para gerar estatísticas. Agora vamos usar as listas como um **cadastro vivo**: incluir, atualizar, consultar e remover itens mantendo duas listas sincronizadas — e, na sequência, **consolidar dados de fontes diferentes**: unificar coleções, eliminar duplicados, ordenar e tratar casos especiais. São os dois formatos de questão que fecham as provas.

---

## 1. Conceitos Teóricos

### 1.1. Listas Paralelas: um Cadastro sem Banco de Dados

Como representar "produto e quantidade" só com o que o módulo ensina? Com **duas listas na mesma ordem**: a posição `i` de uma corresponde à posição `i` da outra.

```csharp
List<string> pecas = new List<string> { "Pneu aro 26", "Corrente", "Freio", "Selim" };
List<int> quantidades = new List<int> { 15, 8, 5, 20 };
// pecas[1] = "Corrente" tem quantidades[1] = 8 unidades
```

Para **exibir** o cadastro, percorra pelos índices — o mesmo `i` lê as duas listas:

```csharp
for (int i = 0; i < pecas.Count; i++)
    Console.WriteLine($"{pecas[i]}: {quantidades[i]} unidades");
```

> **A regra de ouro:** toda operação que mexe em uma lista precisa mexer na outra, na **mesma posição**. Se as listas dessincronizarem, o cadastro inteiro fica corrompido.

### 1.2. As Operações do Cadastro

```csharp
// INCLUIR: Add nas DUAS listas
pecas.Add("Cambio");
quantidades.Add(12);

// ATUALIZAR: IndexOf localiza a posicao; o indice atualiza a outra lista
int posicao = pecas.IndexOf("Freio");
if (posicao >= 0)
    quantidades[posicao] = 3;   // IndexOf devolve -1 se nao achar: sempre verifique!

// CONSULTAR: Contains diz se o item existe
bool temCampainha = pecas.Contains("Campainha");    // false

// CONTAR POR CONDICAO: percorra a lista de quantidades (Aula 4)
int estoqueBaixo = 0;
foreach (int quantidade in quantidades)
    if (quantidade < 10)
        estoqueBaixo++;

// REMOVER: ache o indice UMA vez e use RemoveAt nas DUAS listas
int indiceRemover = pecas.IndexOf("Selim");
if (indiceRemover >= 0)
{
    pecas.RemoveAt(indiceRemover);
    quantidades.RemoveAt(indiceRemover);    // remocao SINCRONIZADA
}
```

Por que `RemoveAt` (por índice) e não `Remove` (por valor)? Porque na lista de quantidades pode haver valores repetidos — `quantidades.Remove(5)` apagaria o **primeiro** 5 que encontrasse, que pode ser de outra peça. O índice não tem essa ambiguidade.

### 1.3. Unificando Coleções de Fontes Diferentes

Dados reais chegam de origens variadas — um grupo de sensores grava em **array**, outro em **lista**. O `AddRange` junta tudo em uma única `List` (ele aceita arrays e listas):

```csharp
double[] grupoA = { 26.5, 31.2, 24.0, 26.5 };
List<double> grupoB = new List<double> { 24.0, 28.9, 22.3 };

List<double> todas = new List<double>();
todas.AddRange(grupoA);
todas.AddRange(grupoB);
Console.WriteLine(todas.Count);     // 7 (ainda com duplicados)
```

### 1.4. Removendo Duplicados (na Mão)

Sem LINQ — que fica para os próximos módulos — o dedup é um `foreach` com `Contains`: só entra na lista final quem ainda não está nela:

```csharp
List<double> unicas = new List<double>();
foreach (double temperatura in todas)
    if (!unicas.Contains(temperatura))
        unicas.Add(temperatura);
// 26.5 e 24.0 apareciam duas vezes; agora ha uma ocorrencia de cada
```

### 1.5. Ordenar, Verificar o Vazio e Analisar Faixas

```csharp
// ORDENAR em ordem crescente: Sort() na lista (para arrays: Array.Sort(arr))
unicas.Sort();

// CASO ESPECIAL: lista vazia — verifique ANTES de acessar [0] ou calcular extremos
if (unicas.Count == 0)
    Console.WriteLine("Nenhuma temperatura valida para processar");
else
{
    // Depois do Sort, menor e maior sao as pontas da lista
    double menor = unicas[0];
    double maior = unicas[unicas.Count - 1];
    Console.WriteLine($"Menor: {menor} | Maior: {maior}");
}

// FAIXA INCLUSIVA: entre 24 e 28, incluindo as pontas -> >= e <=
int naFaixaIdeal = 0;
foreach (double temperatura in unicas)
    if (temperatura >= 24.0 && temperatura <= 28.0)
        naFaixaIdeal++;

// ALERTA: existe algum valor critico? Uma flag bool resolve
bool temCritica = false;
foreach (double temperatura in unicas)
    if (temperatura > 30.0)
        temCritica = true;
Console.WriteLine($"Temperatura critica detectada: {(temCritica ? "Sim" : "Nao")}");
```

Repare no acesso `unicas[unicas.Count - 1]`: o último índice é sempre `Count - 1` — errar isso gera o famoso erro de índice fora do intervalo.

---

## 2. Estudo de Caso Prático: PedalUrbano

### Caso A: Inventário da Oficina

A oficina controla as peças de reposição com listas paralelas. Um dia típico tem inclusão, atualização, consulta, contagem de estoque baixo e remoção — sempre sincronizadas:

```csharp
List<string> pecas = new List<string> { "Pneu aro 26", "Corrente", "Freio", "Cesto" };
List<int> quantidades = new List<int> { 15, 8, 5, 20 };

Console.WriteLine("=== INVENTARIO INICIAL ===");
for (int i = 0; i < pecas.Count; i++)
    Console.WriteLine($"{pecas[i]}: {quantidades[i]} unidades");

Console.WriteLine();
Console.WriteLine("=== OPERACOES ===");

// 1) Chegou peca nova: Add nas duas listas
pecas.Add("Cambio");
quantidades.Add(12);
Console.WriteLine("Peca adicionada: Cambio (12 unidades)");

// 2) Recontagem do Freio: IndexOf + atualizacao pela posicao
int posicaoFreio = pecas.IndexOf("Freio");
if (posicaoFreio >= 0)
    quantidades[posicaoFreio] = 3;
Console.WriteLine("Quantidade atualizada: Freio (3 unidades)");

// 3) Consulta de existencia
bool temCampainha = pecas.Contains("Campainha");
Console.WriteLine($"Peca \"Campainha\" existe? {(temCampainha ? "Sim" : "Nao")}");

// 4) Contagem de estoque baixo (Aula 4: contador condicional)
int estoqueBaixo = 0;
foreach (int quantidade in quantidades)
    if (quantidade < 10)
        estoqueBaixo++;
Console.WriteLine($"Pecas com estoque baixo (< 10): {estoqueBaixo}");

// 5) Cesto saiu de linha: remocao SINCRONIZADA pelas duas listas
int posicaoCesto = pecas.IndexOf("Cesto");
if (posicaoCesto >= 0)
{
    pecas.RemoveAt(posicaoCesto);
    quantidades.RemoveAt(posicaoCesto);
}
Console.WriteLine("Peca removida: Cesto");

// 6) Inventario final + total geral (Aula 4: acumulador)
Console.WriteLine();
Console.WriteLine("=== INVENTARIO FINAL ===");
int totalUnidades = 0;
for (int i = 0; i < pecas.Count; i++)
{
    Console.WriteLine($"{pecas[i]}: {quantidades[i]} unidades");
    totalUnidades += quantidades[i];
}
Console.WriteLine($"Total de unidades: {totalUnidades}");
```

**Vantagem desse padrão:** cada operação do enunciado (adicionar, atualizar, verificar, contar, remover) vira um bloco numerado no código — e o `IndexOf` verificado com `>= 0` protege o programa quando o item não existe.

---

### Caso B: Consolidação da Telemetria das Docas

As docas das estações medem a temperatura dos motores em dois grupos independentes — um antigo (array) e um novo (lista). A central consolida tudo: unifica, tira duplicados, ordena e analisa:

```csharp
// Fontes independentes: array (sistema antigo) e lista (sistema novo)
double[] grupoA = { 26.5, 31.2, 24.0, 26.5, 29.8 };
List<double> grupoB = new List<double> { 24.0, 28.9, 22.3, 31.2 };

// 1) Unificar
List<double> todas = new List<double>();
todas.AddRange(grupoA);
todas.AddRange(grupoB);

// 2) Remover duplicados na mao
List<double> unicas = new List<double>();
foreach (double temperatura in todas)
    if (!unicas.Contains(temperatura))
        unicas.Add(temperatura);

// 3) Ordenar em ordem crescente
unicas.Sort();

Console.WriteLine("=== TELEMETRIA CONSOLIDADA ===");

// 4) Caso especial: nada valido para processar
if (unicas.Count == 0)
    Console.WriteLine("Nenhuma temperatura valida para processar");
else
{
    foreach (double temperatura in unicas)
        Console.WriteLine($"{temperatura.ToString("N1")} C");

    Console.WriteLine();
    Console.WriteLine($"Temperaturas distintas: {unicas.Count}");
    Console.WriteLine($"Menor: {unicas[0].ToString("N1")} C");
    Console.WriteLine($"Maior: {unicas[unicas.Count - 1].ToString("N1")} C");

    // 5) Faixa ideal (inclusiva) e alerta critico
    int naFaixaIdeal = 0;
    bool temCritica = false;
    foreach (double temperatura in unicas)
    {
        if (temperatura >= 24.0 && temperatura <= 28.0)
            naFaixaIdeal++;
        if (temperatura > 30.0)
            temCritica = true;
    }

    Console.WriteLine($"Na faixa ideal (24 a 28 C): {naFaixaIdeal}");
    Console.WriteLine($"Alerta critico (> 30 C): {(temCritica ? "Sim" : "Nao")}");
}
```

**Vantagem desse padrão:** o pipeline unificar → dedup → ordenar → analisar é sempre o mesmo, independente do que os dados representam — e verificar `Count == 0` antes de acessar `unicas[0]` evita o crash no caso extremo.

---

## 3. Desafio da Semana

Monte a **auditoria da frota** da PedalUrbano: as bikes estão registradas em dois sistemas que precisam ser consolidados em um cadastro único e conferido.

### Requisitos:
1.  Declare as duas fontes: um array `string[]` com códigos do sistema antigo (ex.: `"PU-0042"`, `"PU-0007"`, `"PU-0013"`, `"PU-0042"`) e uma `List<string>` com códigos do sistema novo (ex.: `"PU-0013"`, `"PU-0101"`, `"PU-0055"`) — inclua duplicados de propósito.
2.  Unifique as duas fontes em uma única `List<string>` com `AddRange`.
3.  Remova os códigos duplicados com o dedup manual (`Contains` + `Add`).
4.  Ordene a lista final com `Sort()` (ordem alfabética).
5.  Valide o formato de cada código como na Aula 1: deve começar com `"PU-"` (`StartsWith`) — conte os válidos e liste os inválidos.
6.  Se a lista final ficar vazia, exiba `"Nenhuma bike para auditar"`. Caso contrário, exiba o relatório: códigos ordenados, total de bikes únicas, quantos códigos duplicados foram descartados (total unificado menos total único) e a contagem de válidos/inválidos.
7.  Extra: monte também o cadastro paralelo de quilometragem — uma `List<int>` com um valor para cada bike única — e mostre a bike com maior quilometragem (valor e código, usando o mesmo índice).

### Estrutura para Desenvolvimento:
```csharp
// Program.cs - Auditoria da frota PedalUrbano
string[] sistemaAntigo = { "PU-0042", "PU-0007", "PU-0013", "PU-0042" };
List<string> sistemaNovo = new List<string> { "PU-0013", "PU-0101", "PU-0055" };

Console.WriteLine("=== AUDITORIA DA FROTA ===");

// TODO: unificar com AddRange
// TODO: dedup manual (Contains + Add)
// TODO: ordenar com Sort
// TODO: validar formato PU- e contar validos/invalidos
// TODO: tratar lista vazia e imprimir o relatorio
// TODO (extra): lista paralela de quilometragem + bike com maior km
```

---
*Dica: depois de cada etapa do pipeline (unificar, dedup, ordenar), imprima `lista.Count` temporariamente. Os números contam a história: 7 unificadas → 5 únicas → 5 ordenadas. Se alguma contagem surpreender, o erro está na etapa anterior.*
