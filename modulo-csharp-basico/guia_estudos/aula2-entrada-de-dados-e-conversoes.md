# Aula 2: Entrada de Dados, Conversões e Relatórios no Console

Na Aula 1 você aprendeu variáveis, tipos e conversões com valores fixos no código. Nesta aula, o programa passa a **conversar com o usuário**: vamos ler dados digitados com `Console.ReadLine`, converter textos para os tipos corretos com `TryParse` (agora também para `decimal` e `bool`), validar entradas em loop até serem aceitas e montar **relatórios formatados em seções** — o formato de saída que todo sistema da PedalUrbano usa.

---

## 1. Conceitos Teóricos

### 1.1. Lendo Dados do Usuário com Console.ReadLine

Tudo o que o usuário digita chega ao programa como **texto** (`string`), mesmo que ele digite um número. A leitura é feita com `Console.ReadLine()`:

```csharp
Console.Write("Digite o codigo da bike: ");   // Write nao pula linha: o cursor fica ao lado da pergunta
string codigoBike = Console.ReadLine() ?? "";

Console.WriteLine($"Codigo informado: {codigoBike}");
```

Dois detalhes importantes:

*   **`Console.Write` vs. `Console.WriteLine`**: use `Write` para a pergunta, assim o usuário digita na mesma linha.
*   **`?? ""`**: `Console.ReadLine()` pode devolver `null` (por exemplo, no fim da entrada). O `?? ""` troca esse `null` por texto vazio, garantindo um `string` válido para **guardar, comparar ou normalizar** com `Trim`/`ToUpper`. **Use o `?? ""` apenas quando for realmente manipular o texto.** Quando o objetivo é só **converter** o valor, passe `Console.ReadLine()` direto para o `TryParse` (próxima seção): o próprio `TryParse` trata o `null` como conversão inválida, então o `?? ""` ali seria desnecessário.

### 1.2. Convertendo Entradas: TryParse para int, decimal e bool

Como `ReadLine` sempre devolve texto, todo número ou booleano precisa ser **convertido**. Na Aula 1 usamos `int.TryParse`; a mesma família de métodos existe para os outros tipos:

```csharp
// int: quantidades, idades, contagens (leia direto no TryParse: nada de ?? "")
Console.Write("Minutos de corrida: ");
if (int.TryParse(Console.ReadLine(), out int minutos))
    Console.WriteLine($"Corrida de {minutos} minutos.");
else
    Console.WriteLine("Valor invalido: digite apenas numeros inteiros.");

// decimal: dinheiro (o usuario digita com VIRGULA, ex.: 12,50)
Console.Write("Valor da recarga: ");
if (decimal.TryParse(Console.ReadLine(), out decimal valorRecarga))
    Console.WriteLine($"Recarga de {valorRecarga.ToString("C")}.");
else
    Console.WriteLine("Valor invalido: use numeros e virgula, ex.: 12,50.");

// bool: aceita "true" ou "false" (maiusculas ou minusculas)
string cupomTexto = "true";
if (bool.TryParse(cupomTexto, out bool possuiCupom))
    Console.WriteLine($"Cupom convertido: {possuiCupom}");
```

> **Atenção com o `bool.TryParse`:** ele só reconhece os textos `"true"` e `"false"` (em qualquer combinação de maiúsculas/minúsculas). Textos como `"1"`, `"sim"` ou `"verdadeiro"` **falham** na conversão.

O padrão profissional é sempre o mesmo: **tentou converter, verificou o resultado, tratou o erro com mensagem amigável** — o programa nunca deve quebrar por causa de uma entrada errada.

> **Estes exemplos com `if` são o primeiro passo.** Aqui a conversão é testada **uma vez** e, se falhar, apenas avisamos o erro. Na prática — e nas provas — quase sempre queremos **repetir a pergunta até o usuário digitar um valor válido**: isso troca o `if` por um `while`, mostrado na seção **1.4** logo abaixo. Guarde o padrão `while` + `TryParse`: é ele que aparece nos Casos A/B desta aula e nas questões interativas.

### 1.3. Ponto ou Vírgula? Convertendo Textos com Ponto Decimal

Nem todo dado chega digitado pelo usuário. Quando um valor vem de **outro sistema** (aplicativo, formulário web, arquivo), ele costuma usar **ponto** como separador decimal: `"450.00"`. E aqui mora uma armadilha grave: no formato brasileiro, o ponto é separador de **milhar** — então a conversão comum não falha, ela devolve o **valor errado**:

```csharp
// PERIGO: em um computador configurado em portugues (pt-BR)...
decimal errado = decimal.Parse("450.00");   // resultado: 45000 (quarenta e cinco MIL!)
```

Para converter textos que usam ponto decimal, informe a **cultura invariante** (formato neutro, com ponto):

```csharp
using System.Globalization;   // no topo do arquivo

string valorDoApp = "450.00";
if (decimal.TryParse(valorDoApp, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal valorPedido))
    Console.WriteLine($"Valor do pedido: {valorPedido.ToString("C")}");   // R$ 450,00
else
    Console.WriteLine("Valor do pedido em formato invalido.");
```

Regra prática do módulo:

| Origem do texto | Separador | Conversão |
| :--- | :--- | :--- |
| Usuário digitando no console (Brasil) | vírgula (`12,50`) | `decimal.TryParse(texto, out valor)` |
| Dado vindo do sistema/app (`"450.00"`) | ponto (`450.00`) | `decimal.TryParse(texto, NumberStyles.Number, CultureInfo.InvariantCulture, out valor)` |

### 1.4. Repetindo Até a Entrada Ser Válida

Se a entrada for inválida, muitas vezes não basta mostrar o erro: é preciso **perguntar de novo**. O laço `while` da Aula 1 resolve isso — repetimos a leitura *enquanto* a entrada não for aceita:

```csharp
decimal valorRecarga = 0m;
bool valorValido = false;

while (!valorValido)
{
    Console.Write("Valor da recarga (minimo R$ 5,00): ");
    if (decimal.TryParse(Console.ReadLine(), out valorRecarga) && valorRecarga >= 5m)
        valorValido = true;
    else
        Console.WriteLine("Entrada invalida: digite um numero maior ou igual a 5,00.");
}

Console.WriteLine($"Recarga aceita: {valorRecarga.ToString("C")}");
```

Repare que a validação testa **duas coisas de uma vez** com `&&`: a conversão funcionou **e** a regra de negócio (valor mínimo) foi atendida.

### 1.5. Relatórios Formatados em Seções

Os sistemas da PedalUrbano (e as provas deste módulo!) exibem resultados em **seções com título**, valores monetários formatados e respostas Sim/Não. Os ingredientes:

```csharp
decimal tarifa = 8.5m;
double distanciaKm = 3.756;
bool planoAtivo = true;

Console.WriteLine("=== FICHA DA CORRIDA ===");                    // titulo da secao
Console.WriteLine($"Tarifa: {tarifa.ToString("C")}");             // R$ 8,50 (moeda)
Console.WriteLine($"Distancia: {distanciaKm.ToString("N2")} km"); // 3,76 (2 casas)
Console.WriteLine($"Plano Ativo: {(planoAtivo ? "Sim" : "Nao")}");// bool vira Sim/Nao com ternario
Console.WriteLine();                                              // linha em branco separa secoes
Console.WriteLine("=== RESUMO ===");
```

> **Nota:** o formato `"C"` usa a configuração de moeda do computador — em máquinas em português do Brasil, sai `R$`. É o formato esperado para todo valor monetário do módulo.

O **operador ternário dentro da interpolação** — `{(condicao ? "Sim" : "Nao")}` — é o jeito mais curto de traduzir um `bool` para texto de relatório. Os parênteses em volta são obrigatórios.

---

## 2. Estudo de Caso Prático: PedalUrbano

### Caso A: Totem de Desbloqueio

Os totens das estações têm um teclado onde o cliente digita os dados do aluguel. Toda entrada precisa ser validada — um totem não pode travar porque alguém digitou `"abc"` no lugar do saldo:

```csharp
Console.WriteLine("=== TOTEM PEDALURBANO ===");

// 1) Codigo da bike: texto simples, apenas normalizado
Console.Write("Codigo da bike (ex.: PU-0042): ");
string codigoBike = (Console.ReadLine() ?? "").Trim().ToUpper();

// 2) Minutos previstos: repete ate ser um inteiro positivo
int minutosPrevistos = 0;
bool minutosValidos = false;
while (!minutosValidos)
{
    Console.Write("Minutos previstos de uso: ");
    if (int.TryParse(Console.ReadLine(), out minutosPrevistos) && minutosPrevistos > 0)
        minutosValidos = true;
    else
        Console.WriteLine("Digite um numero inteiro maior que zero.");
}

// 3) Saldo do cliente: repete ate ser um decimal nao negativo
decimal saldo = 0m;
bool saldoValido = false;
while (!saldoValido)
{
    Console.Write("Saldo atual (ex.: 25,90): ");
    if (decimal.TryParse(Console.ReadLine(), out saldo) && saldo >= 0m)
        saldoValido = true;
    else
        Console.WriteLine("Digite um valor valido, com virgula para os centavos.");
}

// 4) Ficha final em secoes
const decimal taxaDesbloqueio = 3.00m;
bool saldoSuficiente = saldo >= taxaDesbloqueio;

Console.WriteLine();
Console.WriteLine("=== FICHA DO DESBLOQUEIO ===");
Console.WriteLine($"Bike: {codigoBike}");
Console.WriteLine($"Minutos previstos: {minutosPrevistos}");
Console.WriteLine($"Saldo: {saldo.ToString("C")}");
Console.WriteLine($"Taxa de desbloqueio: {taxaDesbloqueio.ToString("C")}");
Console.WriteLine($"Desbloqueio autorizado: {(saldoSuficiente ? "Sim" : "Nao")}");
```

**Vantagem desse padrão:** cada dado tem seu próprio bloco de validação em loop — o programa só avança com dados corretos, e o relatório final pode confiar que as variáveis têm valores válidos.

---

### Caso B: Validação de Recarga Vinda do Aplicativo

O aplicativo da PedalUrbano envia recargas para a central como **strings** — e com ponto decimal, no formato internacional. A central precisa validar cada campo e reportar o resultado, exatamente como um módulo de processamento de pedidos:

```csharp
using System.Globalization;

// Dados chegam do app como texto (formato internacional, ponto decimal)
string valorTexto = "35.90";
string bonusTexto = "2";
string cupomTexto = "true";

Console.WriteLine("=== PROCESSAMENTO DE RECARGA ===");
Console.WriteLine();
Console.WriteLine("VALIDACAO");

// Valor da recarga: ponto decimal exige InvariantCulture
bool valorOk = decimal.TryParse(valorTexto, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal valorRecarga);
Console.WriteLine($"Valor da recarga convertido: {(valorOk ? "OK" : "ERRO")}");

// Meses de bonus: inteiro simples
bool bonusOk = int.TryParse(bonusTexto, out int mesesBonus);
Console.WriteLine($"Meses de bonus convertidos: {(bonusOk ? "OK" : "ERRO")}");

// Cupom: booleano
bool cupomOk = bool.TryParse(cupomTexto, out bool possuiCupom);
Console.WriteLine($"Cupom convertido: {(cupomOk ? "OK" : "ERRO")}");

// Se qualquer conversao falhou, interrompe com mensagem de erro
if (!valorOk || !bonusOk || !cupomOk)
    Console.WriteLine("Recarga rejeitada: dados em formato invalido.");
else
{
    Console.WriteLine();
    Console.WriteLine("DADOS DA RECARGA");
    Console.WriteLine($"Valor: {valorRecarga.ToString("C")}");
    Console.WriteLine($"Bonus: {mesesBonus} meses");
    Console.WriteLine($"Cupom aplicado: {(possuiCupom ? "Sim" : "Nao")}");
}
```

**Vantagem desse padrão:** o relatório de validação (`OK`/`ERRO` campo a campo) mostra exatamente **qual** dado veio errado — muito mais útil do que uma falha genérica. E o `CultureInfo.InvariantCulture` garante que `"35.90"` vire R$ 35,90, e não R$ 3.590,00.

---

## 3. Desafio da Semana

Monte o **check-in de novo cliente** da PedalUrbano: um programa console que coleta os dados do cadastro, valida tudo e imprime a ficha final formatada.

### Requisitos:
1.  Leia o **nome** do cliente com `Console.ReadLine` (apenas normalize com `Trim`).
2.  Leia a **idade** com validação em loop: repita até ser um inteiro entre 16 e 120. Menores de 16 não podem se cadastrar — nesse caso, encerre com uma mensagem educada.
3.  Leia o **valor da primeira recarga** com validação em loop: `decimal` (vírgula) maior ou igual a R$ 10,00.
4.  O aplicativo enviou dois dados extras como texto: `string indicacaoTexto = "true";` (se o cliente veio por indicação) e `string creditoPromocionalTexto = "15.50";` (crédito em formato internacional). Converta os dois com os métodos corretos e exiba `OK`/`ERRO` para cada conversão.
5.  Calcule o **saldo inicial**: recarga + crédito promocional (somente se as conversões deram certo).
6.  Imprima a ficha final em seções (`=== CADASTRO ===` e `=== SALDO ===`), com valores em `ToString("C")` e os booleanos como Sim/Não usando ternário.

### Estrutura para Desenvolvimento:
```csharp
// Program.cs - Check-in de novo cliente PedalUrbano
using System.Globalization;

Console.WriteLine("=== CHECK-IN PEDALURBANO ===");

// Dados enviados pelo aplicativo (nao alterar)
string indicacaoTexto = "true";
string creditoPromocionalTexto = "15.50";

// TODO: ler o nome com ReadLine + Trim
// TODO: ler a idade com TryParse em loop (16 a 120)
// TODO: ler o valor da recarga com TryParse em loop (>= 10,00)
// TODO: converter indicacaoTexto (bool) e creditoPromocionalTexto (decimal + InvariantCulture)
// TODO: exibir a secao VALIDACAO com OK/ERRO por campo
// TODO: calcular o saldo inicial e imprimir a ficha em secoes
```

---
*Dica: teste seu programa como um usuário desastrado — digite letras onde vai número, valores negativos e texto vazio. Se ele sobreviver a você, sobrevive ao cliente.*
