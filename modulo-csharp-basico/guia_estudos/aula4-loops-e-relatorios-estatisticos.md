# Aula 4: Loops na Prática — Relatórios e Estatísticas

Na Aula 1 você conheceu `for`, `while` e `foreach`; nas Aulas 2 e 3, a validação de entradas e as regras de decisão. Nesta aula, os laços viram ferramenta de **análise de dados**: preencher coleções com valores digitados pelo usuário, calcular total, média, maior e menor, contar ocorrências por condição e fechar tudo em um **relatório estatístico** — o formato clássico das questões de maior peso das provas.

---

## 1. Conceitos Teóricos

### 1.1. Preenchendo Coleções com Dados do Usuário

Para ler vários valores, combine o `for` (Aula 1) com o `TryParse` em loop de validação (Aula 2). Cada posição do array só é preenchida com um valor válido:

```csharp
double[] temperaturas = new double[7];

for (int i = 0; i < temperaturas.Length; i++)
{
    bool valida = false;
    while (!valida)
    {
        Console.Write($"Temperatura do dia {i + 1}: ");
        string entrada = Console.ReadLine() ?? "";

        if (double.TryParse(entrada, out temperaturas[i]))
            valida = true;
        else
            Console.WriteLine("Digite um numero valido.");
    }
}
```

Quando a **quantidade** de valores também vem do usuário, leia-a primeiro e use-a para criar a coleção:

```csharp
Console.Write("Quantas vendas deseja registrar? ");
int quantidade = int.Parse(Console.ReadLine() ?? "0");   // em programa real, valide com TryParse

decimal[] vendas = new decimal[quantidade];   // o tamanho vem da resposta do usuario
```

> Se os dados continuarem crescendo depois (ex.: "registre uma nova venda"), prefira `List<decimal>` com `Add` — o array tem tamanho fixo (Aula 1).

### 1.2. Acumuladores e Contadores

Os dois padrões mais cobrados em prova. O **acumulador** soma valores; o **contador** conta quantos itens atendem a uma condição. Ambos começam zerados **antes** do laço:

```csharp
decimal[] vendas = { 120.50m, 45.00m, 230.00m, 89.90m, 15.00m };

decimal total = 0m;         // acumulador
int acimaDe100 = 0;         // contador condicional

foreach (decimal venda in vendas)
{
    total += venda;         // acumula sempre
    if (venda > 100m)
        acimaDe100++;       // conta so quando a condicao vale
}
```

### 1.3. Maior e Menor: a Inicialização Correta

Para achar o maior e o menor valor, compare cada item com o "campeão atual". A armadilha está na largada: **inicialize com o primeiro elemento da coleção, nunca com zero** — se todos os valores forem negativos (temperaturas de inverno!), um `menor = 0` daria resultado errado:

```csharp
double[] temperaturas = { -2.5, 3.0, -7.1, 1.4 };

double maior = temperaturas[0];   // comeca do primeiro elemento...
double menor = temperaturas[0];   // ...nos dois casos

for (int i = 1; i < temperaturas.Length; i++)   // ...e compara do segundo em diante
{
    if (temperaturas[i] > maior)
        maior = temperaturas[i];
    if (temperaturas[i] < menor)
        menor = temperaturas[i];
}
// maior = 3.0 | menor = -7.1 (com menor = 0, o resultado seria 0: ERRADO)
```

Se precisar também da **posição** do maior/menor, guarde o índice em uma segunda variável ao mesmo tempo.

### 1.4. Média — e o Perigo da Divisão Inteira

A média é o acumulador dividido pela quantidade. Com `decimal[]` ou `double[]`, a divisão sai naturalmente com casas decimais:

```csharp
decimal media = total / vendas.Length;
```

Mas se os valores forem `int` (minutos, contagens), lembre da Aula 1: **`int / int` corta as casas decimais**. Converta antes de dividir:

```csharp
int[] minutos = { 12, 25, 70 };
int somaMinutos = 12 + 25 + 70;                          // 107
decimal mediaErrada = somaMinutos / minutos.Length;      // 35 (divisao inteira!)
decimal mediaCerta = (decimal)somaMinutos / minutos.Length;  // 35,666...
```

### 1.5. A Segunda Passada: Comparando com a Média

"Quantos dias ficaram **acima da média**?" — essa pergunta só pode ser respondida **depois** que a média existe. O padrão é percorrer a coleção **duas vezes**: a primeira passada calcula a média; a segunda compara cada item com ela:

```csharp
// 1a passada: total e media (secoes 1.2 e 1.4)
double soma = 0;
foreach (double t in temperaturas)
    soma += t;
double media = soma / temperaturas.Length;

// 2a passada: agora da para comparar com a media
int diasAcimaDaMedia = 0;
foreach (double t in temperaturas)
    if (t > media)
        diasAcimaDaMedia++;
```

É por isso que os valores precisam estar **guardados em uma coleção**: se você só acumulasse a soma enquanto lê, não teria como revisitá-los na segunda passada.

### 1.6. Novos Dados: Recalcular com List

Quando o enunciado pede para **registrar um valor extra e recalcular tudo**, a `List<T>` (Aula 1) brilha: adicione com `Add` e rode as mesmas passadas de novo — as estatísticas passam a considerar o novo item:

```csharp
List<decimal> vendas = new List<decimal> { 320.00m, 150.00m, 890.50m };

// nova venda validada (Aula 2: TryParse em loop, valor positivo)
decimal novaVenda = 75.90m;
vendas.Add(novaVenda);

// recalcular = repetir os MESMOS lacos sobre a lista atualizada (agora com .Count itens)
```

---

## 2. Estudo de Caso Prático: PedalUrbano

### Caso A: Relatório Diário de Corridas

Ao fim do dia, a central processa as tarifas das corridas e monta o relatório de desempenho — total, contagens, extremos, média e a classificação do dia:

```csharp
decimal[] tarifas = { 12.50m, 4.00m, 23.00m, 8.90m, 1.50m, 34.00m, 6.70m, 19.90m };

Console.WriteLine("=== RELATORIO DIARIO PEDALURBANO ===");
Console.WriteLine();

// Impressao numerada (indice i comeca em 0; corrida comeca em 1)
for (int i = 0; i < tarifas.Length; i++)
    Console.WriteLine($"Corrida {i + 1}: {tarifas[i].ToString("C")}");

// Uma unica passada: acumulador, contador e extremos juntos
decimal total = 0m;
int acimaDe10 = 0;
decimal maior = tarifas[0];
decimal menor = tarifas[0];

foreach (decimal tarifa in tarifas)
{
    total += tarifa;
    if (tarifa > 10m)
        acimaDe10++;
    if (tarifa > maior)
        maior = tarifa;
    if (tarifa < menor)
        menor = tarifa;
}

decimal media = total / tarifas.Length;

// Classificacao do dia (Aula 3: cadeia da faixa mais alta para a mais baixa)
string desempenho;
if (total > 100m)
    desempenho = "Excelente";
else if (total >= 70m)
    desempenho = "Bom";
else if (total >= 40m)
    desempenho = "Regular";
else
    desempenho = "Fraco";

Console.WriteLine();
Console.WriteLine($"Total do Dia: {total.ToString("C")}");
Console.WriteLine($"Corridas acima de R$ 10: {acimaDe10}");
Console.WriteLine($"Maior Tarifa: {maior.ToString("C")}");
Console.WriteLine($"Menor Tarifa: {menor.ToString("C")}");
Console.WriteLine($"Media: {media.ToString("C")}");
Console.WriteLine();
Console.WriteLine($"Desempenho do Dia: {desempenho}");
```

**Vantagem desse padrão:** total, contador e extremos cabem em **uma** passada; só a comparação com a média exige a segunda. Saber separar o que precisa de uma ou duas passadas é o que destrava as questões estatísticas.

---

### Caso B: Semana de Quilometragem

O aplicativo pergunta ao ciclista quantos quilômetros pedalou em cada um dos 7 dias e devolve a análise da semana — agora com os dados vindos do usuário:

```csharp
double[] kmPorDia = new double[7];

// Leitura validada dia a dia (Aula 2)
for (int i = 0; i < kmPorDia.Length; i++)
{
    bool valida = false;
    while (!valida)
    {
        Console.Write($"Km do dia {i + 1}: ");
        string entrada = Console.ReadLine() ?? "";

        if (double.TryParse(entrada, out kmPorDia[i]) && kmPorDia[i] >= 0)
            valida = true;
        else
            Console.WriteLine("Digite um numero maior ou igual a zero.");
    }
}

// 1a passada: soma e extremos
double somaKm = 0;
double maiorKm = kmPorDia[0];
double menorKm = kmPorDia[0];

foreach (double km in kmPorDia)
{
    somaKm += km;
    if (km > maiorKm)
        maiorKm = km;
    if (km < menorKm)
        menorKm = km;
}

double mediaKm = somaKm / kmPorDia.Length;

// 2a passada: dias acima da media
int diasAcimaDaMedia = 0;
foreach (double km in kmPorDia)
    if (km > mediaKm)
        diasAcimaDaMedia++;

// Classificacao da semana
string ritmo = mediaKm > 15 ? "Semana intensa" : mediaKm >= 5 ? "Semana regular" : "Semana leve";

Console.WriteLine();
Console.WriteLine("=== ANALISE DA SEMANA ===");
Console.WriteLine($"Total: {somaKm.ToString("N1")} km");
Console.WriteLine($"Media diaria: {mediaKm.ToString("N1")} km");
Console.WriteLine($"Melhor dia: {maiorKm.ToString("N1")} km");
Console.WriteLine($"Pior dia: {menorKm.ToString("N1")} km");
Console.WriteLine($"Dias acima da media: {diasAcimaDaMedia}");
Console.WriteLine($"Ritmo: {ritmo}");
```

**Vantagem desse padrão:** o mesmo esqueleto (leitura validada → 1ª passada → média → 2ª passada → classificação) resolve qualquer variação do enunciado — temperaturas, vendas, notas ou quilômetros.

---

## 3. Desafio da Semana

Monte o **fechamento do mês** da PedalUrbano: um programa console que lê as tarifas do mês, calcula as estatísticas, registra uma corrida extra e recalcula tudo.

### Requisitos:
1.  Pergunte **quantas corridas** o mês teve (inteiro entre 1 e 31, validado em loop).
2.  Leia as tarifas uma a uma para dentro de uma `List<decimal>`, validando cada valor como positivo (Aula 2).
3.  Calcule e exiba: quantidade de corridas, total, maior, menor (inicializados com o primeiro elemento!) e média.
4.  Peça **uma corrida extra** que ficou fora do fechamento, validando que o valor seja positivo, e adicione à lista com `Add`.
5.  **Recalcule e exiba** todas as estatísticas com a corrida extra incluída.
6.  Conte e exiba quantas corridas ficaram **acima de R$ 20,00** e quantas ficaram **abaixo de R$ 5,00**.
7.  Feche com o relatório completo em seções, valores com `ToString("C")`.

### Estrutura para Desenvolvimento:
```csharp
// Program.cs - Fechamento do mes PedalUrbano
List<decimal> tarifas = new List<decimal>();

Console.WriteLine("=== FECHAMENTO DO MES ===");

// TODO: perguntar a quantidade de corridas (1 a 31, validado em loop)
// TODO: ler cada tarifa validada como positiva e adicionar a lista
// TODO: calcular quantidade, total, maior, menor e media
// TODO: ler a corrida extra validada e Add na lista
// TODO: recalcular as estatisticas com a lista atualizada
// TODO: contar corridas acima de R$ 20 e abaixo de R$ 5
// TODO: imprimir o relatorio final em secoes
```

---
*Dica: escreva o recálculo como os MESMOS laços rodando de novo sobre a lista atualizada. Se você se pegar copiando e colando as contas com pequenas diferenças, pare e confira — estatística recalculada com fórmula diferente é a fonte nº 1 de erro nessa questão.*
