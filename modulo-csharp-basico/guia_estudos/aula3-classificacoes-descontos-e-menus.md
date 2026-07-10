# Aula 3: Decisões de Negócio — Classificações, Descontos e Menus

Na Aula 1 você aprendeu `if/else`, `switch` e `enum`; na Aula 2, a ler e validar dados do usuário. Nesta aula, vamos usar essas ferramentas para implementar **regras de negócio de verdade**: classificar clientes em categorias combinando várias condições, aplicar descontos e taxas em sequência, calcular parcelas e montar **menus de opções** percorrendo um `enum`. É o coração de quase toda questão de prova.

---

## 1. Conceitos Teóricos

### 1.1. Condições Compostas: &&, || e Parênteses

Regras de negócio raramente dependem de uma única condição. Elas combinam critérios com **E** (`&&`) e **OU** (`||`) — e os **parênteses** definem o que é avaliado junto:

```csharp
decimal gastoMes = 180.00m;
int mesesCliente = 14;
bool possuiCartao = true;

// Categoria Diamante: gasto acima de 300 OU (gasto acima de 150 E cliente ha mais de 12 meses)
bool ehDiamante = gastoMes > 300m || (gastoMes > 150m && mesesCliente > 12);
```

Sem os parênteses, o significado muda: `a || b && c` é avaliado como `a || (b && c)` — o `&&` tem prioridade sobre o `||`. **Nunca confie na memória: use parênteses para deixar a intenção explícita.**

Leia a regra em voz alta antes de codificar: *"é Diamante se gastou mais de 300, **ou** se gastou mais de 150 **e** é cliente há mais de um ano"*. Cada **ou** vira `||`, cada **e** vira `&&`, e cada trecho entre vírgulas costuma pedir um parêntese.

### 1.2. Cadeias de Classificação: a Ordem Importa

Para classificar algo em **faixas** (categorias de cliente, níveis de desempenho), usa-se a cadeia `if / else if / else`. Há duas regras de ouro:

**1ª — Teste a categoria mais alta/específica primeiro.** A cadeia para na primeira condição verdadeira; se a faixa mais baixa vier antes, ela "captura" casos que pertenciam às faixas de cima:

```csharp
string categoria;

// CORRETO: da categoria mais exigente para a menos exigente
if (gastoMes > 300m || (gastoMes > 150m && mesesCliente > 12))
    categoria = "Diamante";
else if (gastoMes >= 80m && possuiCartao)
    categoria = "Ouro";
else if (gastoMes >= 40m)
    categoria = "Prata";
else
    categoria = "Bronze";
```

**2ª — Sempre feche com um `else` final (categoria padrão).** Enunciados de prova às vezes deixam **lacunas** entre as faixas (ex.: um cliente que gastou muito, mas não tem cartão, e não se encaixa literalmente em nenhuma regra). O `else` final garante que todo caso receba uma classificação em vez de deixar a variável sem valor.

### 1.3. Descontos, Taxas e o Encadeamento de Percentuais

Percentuais em C# são multiplicações com `decimal`:

```csharp
decimal valor = 200.00m;

decimal desconto = valor * 0.15m;              // 15% do valor -> R$ 30,00
decimal valorComDesconto = valor - desconto;   // R$ 170,00
// ou, direto:
decimal valorFinal = valor * (1 - 0.15m);      // R$ 170,00
decimal valorComTaxa = valor * (1 + 0.05m);    // taxa de 5% -> R$ 210,00
```

Quando o enunciado diz que um segundo desconto é aplicado **"sobre o valor já processado"**, os percentuais são aplicados **em sequência** — e o resultado é diferente de somar os percentuais:

```csharp
decimal consulta = 150.00m;

// 1) Desconto do convenio: 10%
decimal aposConvenio = consulta * (1 - 0.10m);      // R$ 135,00

// 2) Cartao fidelidade: 5% SOBRE O VALOR JA PROCESSADO
decimal valorFinal2 = aposConvenio * (1 - 0.05m);   // R$ 128,25

// Errado seria somar os percentuais: 15% direto daria R$ 127,50
```

Guarde cada etapa em sua própria variável (`aposConvenio`, `valorFinal`) — o relatório da prova sempre pede os valores intermediários.

### 1.4. Parcelamento

Dividir um valor em parcelas é uma divisão de `decimal` por `int` — o resultado é `decimal`, sem truncamento:

```csharp
decimal valorFinal = 428.45m;
int parcelas = 3;

decimal valorParcela = valorFinal / parcelas;               // 142.81666...
Console.WriteLine($"{parcelas}x de {valorParcela.ToString("C")}");  // 3x de R$ 142,82
```

O `ToString("C")` já arredonda para 2 casas **na exibição**. Se precisar do valor arredondado para usar em outra conta, use `Math.Round(valorParcela, 2)`.

### 1.5. Menus com Enum: Exibir Opções e Ler a Escolha

Na Aula 1, o `enum` apareceu como parceiro do `switch`. Agora vamos usá-lo para montar **menus**: exibir todas as opções percorrendo o enum, ler a escolha do usuário e convertê-la de volta para o enum.

```csharp
enum TipoOcorrencia
{
    BikeDanificada = 1,     // comecando em 1, o menu fica natural para o usuario
    EstacaoCheia = 2,
    CobrancaIndevida = 3,
    Sugestao = 4
}
```

**Exibir as opções** — `Enum.GetValues` devolve todos os valores do enum, e o `foreach` os percorre; o cast `(int)` mostra o número de cada um:

```csharp
Console.WriteLine("=== TIPOS DE OCORRENCIA ===");
foreach (TipoOcorrencia tipo in Enum.GetValues(typeof(TipoOcorrencia)))
    Console.WriteLine($"{(int)tipo} - {tipo}");
```

**Ler e validar a escolha** — converta o texto para `int` com `TryParse` (Aula 2) e confira se o número existe no enum com `Enum.IsDefined`; só então faça o cast para o enum:

```csharp
Console.Write("Escolha uma opcao: ");
string entrada = Console.ReadLine() ?? "";

if (int.TryParse(entrada, out int opcao) && Enum.IsDefined(typeof(TipoOcorrencia), opcao))
{
    TipoOcorrencia escolha = (TipoOcorrencia)opcao;    // int -> enum
    Console.WriteLine($"Voce escolheu: {escolha}");
}
else
    Console.WriteLine("Opcao inexistente.");
```

Com a escolha validada, a decisão final é um `switch` — exatamente como na Aula 1.

---

## 2. Estudo de Caso Prático: PedalUrbano

### Caso A: Categorias do PedalClub

O programa de fidelidade da PedalUrbano — o **PedalClub** — classifica cada cliente pelo gasto do mês, tempo de casa e cartão do clube, e concede benefícios por categoria. Estudantes ganham um benefício extra, **somado** ao da categoria:

```csharp
// Dados do cliente avaliado (poderiam vir de ReadLine, como na Aula 2)
string nomeCliente = "Marina Costa";
decimal gastoMes = 180.00m;
int mesesCliente = 14;
bool possuiCartaoClube = true;
bool ehEstudante = true;

// 1) Classificacao: da categoria mais alta para a mais baixa, com else final
string categoria;
if (gastoMes > 300m || (gastoMes > 150m && mesesCliente > 12))
    categoria = "Diamante";
else if (gastoMes >= 80m && possuiCartaoClube)
    categoria = "Ouro";
else if (gastoMes >= 40m)
    categoria = "Prata";
else
    categoria = "Bronze";   // categoria padrao: nenhum cliente fica sem classificacao

// 2) Beneficios por categoria com switch expression (Aula 1)
string beneficios = categoria switch
{
    "Diamante" => "30 min gratis por corrida + Upgrade para bike eletrica + Suporte prioritario",
    "Ouro" => "15 min gratis por corrida + Upgrade para bike eletrica",
    "Prata" => "10 min gratis por corrida",
    _ => "5 min gratis na primeira corrida do mes"
};

// 3) Beneficio extra e CONCATENADO ao da categoria
if (ehEstudante)
    beneficios += " + Desconto de 20% na mensalidade do PedalClub";

Console.WriteLine("=== PEDALCLUB ===");
Console.WriteLine($"Cliente: {nomeCliente}");
Console.WriteLine($"Gasto no Mes: {gastoMes.ToString("C")}");
Console.WriteLine($"Tempo como Cliente: {mesesCliente} meses");
Console.WriteLine($"Cartao do Clube: {(possuiCartaoClube ? "Sim" : "Nao")}");
Console.WriteLine();
Console.WriteLine($"Categoria: {categoria}");
Console.WriteLine($"Beneficios: {beneficios}");
```

**Vantagem desse padrão:** a classificação (cadeia `if/else if`), a tabela de benefícios (`switch`) e o extra (`+=`) ficam em blocos separados — cada regra do enunciado vira um bloco visível no código, fácil de conferir contra a prova.

---

### Caso B: Caixa de Recarga de Créditos

No caixa das lojas parceiras, a recarga passa por três etapas de cálculo: cupom, forma de pagamento e parcelamento. Repare como cada etapa parte do **valor já processado** pela anterior:

```csharp
enum FormaPagamento
{
    Dinheiro = 1,
    Pix = 2,
    Debito = 3,
    Credito = 4
}

decimal valorRecarga = 200.00m;
bool possuiCupom = true;
FormaPagamento pagamento = FormaPagamento.Credito;
int parcelas = 3;

Console.WriteLine("=== CAIXA PEDALURBANO ===");
Console.WriteLine($"Valor Original: {valorRecarga.ToString("C")}");

// Etapa 1: cupom de 10%
decimal descontoCupom = possuiCupom ? valorRecarga * 0.10m : 0m;
decimal valorAposCupom = valorRecarga - descontoCupom;
Console.WriteLine($"Desconto Cupom (10%): {descontoCupom.ToString("C")}");
Console.WriteLine($"Valor apos cupom: {valorAposCupom.ToString("C")}");

// Etapa 2: forma de pagamento (sobre o valor JA processado)
decimal percentualAjuste = pagamento switch
{
    FormaPagamento.Dinheiro => -0.05m,   // 5% de desconto
    FormaPagamento.Pix => -0.03m,        // 3% de desconto
    FormaPagamento.Credito => 0.05m,     // 5% de taxa
    _ => 0m                              // debito: sem ajuste
};
decimal ajuste = valorAposCupom * percentualAjuste;
decimal valorFinal = valorAposCupom + ajuste;

Console.WriteLine($"Forma de Pagamento: {pagamento}");
Console.WriteLine($"Ajuste {pagamento} ({percentualAjuste * 100:N0}%): {ajuste.ToString("C")}");
Console.WriteLine();
Console.WriteLine($"VALOR FINAL: {valorFinal.ToString("C")}");

// Etapa 3: parcelamento apenas no credito
if (pagamento == FormaPagamento.Credito)
{
    decimal valorParcela = valorFinal / parcelas;
    Console.WriteLine($"Tipo de Pagamento: Parcelado em {parcelas}x de {valorParcela.ToString("C")}");
}
else
    Console.WriteLine("Tipo de Pagamento: A vista");
```

**Vantagem desse padrão:** cada etapa tem sua variável (`valorAposCupom`, `valorFinal`) — os valores intermediários que o relatório exige já existem prontos, e um percentual negativo no `switch` expressa desconto e taxa com a mesma regra.

---

## 3. Desafio da Semana

Monte o **menu da central de atendimento** da PedalUrbano: um programa console que apresenta os tipos de ocorrência, lê a escolha do cliente e informa o encaminhamento.

### Requisitos:
1.  Crie o `enum TipoOcorrencia` com os valores `BikeDanificada = 1`, `EstacaoCheia = 2`, `CobrancaIndevida = 3` e `Cancelamento = 4`.
2.  Exiba todas as opções **percorrendo o enum** com `foreach` + `Enum.GetValues`, no formato `1 - BikeDanificada`.
3.  Leia a escolha do usuário com `int.TryParse` + `Enum.IsDefined` (Aula 2 + seção 1.5). Se a opção não existir, repita a pergunta em loop até receber uma válida.
4.  Use um `switch` sobre o enum para definir o **setor de destino** e o **tempo estimado**: manutenção (30 min), logística (15 min), financeiro (10 min) e retenção (20 min), respectivamente.
5.  Clientes do PedalClub (use um `bool` fixo no código) têm o tempo estimado **reduzido em 50%**.
6.  Exiba o protocolo final em seções: ocorrência escolhida, setor, tempo estimado e se houve prioridade PedalClub (Sim/Não).

### Estrutura para Desenvolvimento:
```csharp
// Program.cs - Central de atendimento PedalUrbano
bool clientePedalClub = true;

Console.WriteLine("=== CENTRAL DE ATENDIMENTO ===");

// TODO: exibir as opcoes percorrendo o enum (foreach + Enum.GetValues)
// TODO: ler e validar a escolha em loop (int.TryParse + Enum.IsDefined)
// TODO: switch para definir setor e tempo estimado
// TODO: aplicar a reducao de 50% para PedalClub
// TODO: imprimir o protocolo em secoes

enum TipoOcorrencia
{
    BikeDanificada = 1,
    EstacaoCheia = 2,
    CobrancaIndevida = 3,
    Cancelamento = 4
}
```

---
*Dica: antes de codificar uma classificação, escreva as faixas no papel em ordem decrescente e teste mentalmente um valor de cada faixa — inclusive um que não caia em nenhuma. Esse valor "órfão" é o que o `else` final captura.*
