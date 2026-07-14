# Aula 1: Lógica de Programação e C# Básico

Bem-vindo ao módulo de C# Básico! Nesta aula, aprenderemos os fundamentos da lógica de programação aplicados à linguagem **C#** com o **.NET**: variáveis, tipos, operadores, condicionais, laços de repetição, coleções e strings. Todo o conteúdo é aplicado ao cenário da **PedalUrbano**, um sistema fictício de aluguel de bicicletas compartilhadas.

---

## 1. Conceitos Teóricos

### 1.1. Lógica de Programação e o Primeiro Programa

Um programa é uma sequência de passos (algoritmo) que o computador executa na ordem. Em C#, o ponto de partida é o método `Main` de um projeto console:

```csharp
// Program.cs
Console.WriteLine("PedalUrbano - Sistema de Bicicletas Compartilhadas");
// Comentarios de linha comecam com duas barras
/* Comentarios de bloco ficam entre barra-asterisco */
```

Para criar e executar um projeto console:

```bash
dotnet new console -n PedalUrbano
cd PedalUrbano
dotnet run
```

### 1.2. Variáveis e Tipos: Valor vs. Referência

Uma variável é um espaço nomeado na memória com um **tipo** que define o que ela guarda:

```csharp
int minutosCorrida = 42;            // numeros inteiros
decimal tarifaTotal = 12.50m;       // dinheiro: SEMPRE decimal (sufixo m)
double distanciaKm = 3.75;          // numeros com casas decimais (nao monetarios)
bool estacaoOperacional = true;     // verdadeiro/falso
char categoriaBike = 'E';           // um unico caractere
string codigoBike = "PU-0042";      // texto
var nomeCliente = "Marina";         // o compilador infere o tipo (string)
```

A diferença fundamental entre categorias de tipos:

*   **Tipos de valor** (`int`, `decimal`, `bool`, `char`...): a variável guarda o próprio dado. Ao copiar, cria-se uma cópia independente.
*   **Tipos de referência** (`string`, arrays, `List<T>`, objetos): a variável guarda um "endereço" para o dado. Ao copiar, as duas variáveis passam a apontar para o **mesmo** dado.

```csharp
int original = 10;
int copia = original;   // copia o VALOR
copia = 20;             // original continua 10

int[] fila1 = { 1, 2, 3 };
int[] fila2 = fila1;    // copia a REFERENCIA (mesmo array!)
fila2[0] = 99;          // fila1[0] tambem passa a ser 99
```

### 1.3. Operadores

```csharp
// Aritmeticos: +  -  *  /  %
int totalMinutos = 130;
int horas = totalMinutos / 60;      // 2  (divisao inteira)
int minutos = totalMinutos % 60;    // 10 (resto da divisao)

// Relacionais: ==  !=  >  <  >=  <=
bool corridaLonga = totalMinutos > 60;      // true

// Logicos: && (E)  || (OU)  ! (NAO)
bool podeAlugar = estacaoOperacional && saldo > 0;
```

Para montar textos, prefira a **interpolação** com `$"..."` em vez de concatenar com `+`:

```csharp
Console.WriteLine($"Bike {codigoBike} alugada por {minutosCorrida} minutos.");
```

### 1.4. Conversão de Tipos

```csharp
// Cast implicito (sem perda): int cabe em double
int capacidade = 20;
double media = capacidade;

// Cast explicito (pode perder dados): double para int corta as casas
double avaliacao = 4.8;
int nota = (int)avaliacao;      // 4

// Texto para numero: Parse lanca erro se o texto for invalido
int minutos1 = int.Parse("35");

// TryParse: tenta converter e devolve false se falhar (entrada de usuario!)
string entrada = "3x";
if (int.TryParse(entrada, out int minutos2))
    Console.WriteLine($"Minutos informados: {minutos2}");
else
    Console.WriteLine("Valor invalido, digite apenas numeros.");

// Numero para texto formatado
decimal tarifa = 8.5m;
Console.WriteLine(tarifa.ToString("C"));    // R$ 8,50 (moeda)
Console.WriteLine(distanciaKm.ToString("N2")); // 3,75 (2 casas)

// Mesma formatacao direto na interpolacao (o specifier vai depois dos dois-pontos)
Console.WriteLine($"{tarifa:C}");           // R$ 8,50  -> igual ao ToString("C")
Console.WriteLine($"{distanciaKm:N2}");     // 3,75     -> igual ao ToString("N2")
```

> **As duas formas são equivalentes.** `valor.ToString("C")` e `$"{valor:C}"` produzem o mesmo texto — use `ToString(...)` quando precisar guardar o texto em uma variável e a interpolação `{valor:C}` quando o valor já faz parte de uma mensagem. As duas aparecem ao longo do material. Atenção: `C` e `N2` seguem a **cultura da máquina** — a saída `R$` só é garantida em um computador configurado em português do Brasil (ou informando a cultura explicitamente).

### 1.5. Estruturas Condicionais

```csharp
// if / else if / else: faixas de tarifa por tempo de corrida
if (minutosCorrida <= 15)
    Console.WriteLine("Faixa basica");
else if (minutosCorrida <= 60)
    Console.WriteLine("Faixa intermediaria");
else
    Console.WriteLine("Faixa estendida");

// Operador ternario: escolha curta entre dois valores
string situacao = estacaoOperacional ? "Aberta" : "Fechada";
```

> **Convenção de chaves:** as chaves `{}` só são utilizadas quando o bloco tem **mais de uma instrução**. Bloco de uma única instrução fica sem chaves, apenas indentado — como nos exemplos acima. A mesma regra vale para os laços (`for`, `while`, `foreach`).

O `enum` cria um conjunto fechado de valores nomeados — parceiro natural do `switch`:

```csharp
enum TipoPlano
{
    Avulso,
    Mensalista,
    Turista
}

TipoPlano plano = TipoPlano.Mensalista;

// switch classico
switch (plano)
{
    case TipoPlano.Avulso:
        Console.WriteLine("Paga tarifa cheia por corrida.");
        break;
    case TipoPlano.Mensalista:
        Console.WriteLine("Tem 30 minutos gratis por corrida.");
        break;
    default:
        Console.WriteLine("Plano com regras promocionais.");
        break;
}

// switch expression (forma moderna e compacta)
decimal percentualDesconto = plano switch
{
    TipoPlano.Mensalista => 0.20m,
    TipoPlano.Turista => 0.10m,
    _ => 0m
};
```

> **Onde declarar o `enum` em um arquivo monolítico.** Quando o programa usa *top-level statements* (um `Program.cs` sem `class`/`Main` explícitos, como neste módulo), o `enum` — por ser uma **declaração de tipo** — deve ficar **ao final do arquivo**, depois de todas as instruções. Se ele for colocado antes das instruções, o programa completo **não compila** (erro `CS8803`: *top-level statements must precede namespace and type declarations*). O trecho isolado acima mostra o `enum` no início apenas para apresentar sua sintaxe — não é um programa completo. Nos exemplos que **são** programas inteiros — o **Caso A** e a "Estrutura para Desenvolvimento" do **Desafio** desta aula — o `enum TipoPlano` aparece corretamente no fim do arquivo.

### 1.6. Estruturas de Repetição

```csharp
// for: quando se conhece a quantidade de repeticoes
for (int i = 1; i <= 5; i++)
    Console.WriteLine($"Vistoria da bike {i}");

// while: repete ENQUANTO a condicao for verdadeira (testa antes)
int bateria = 100;
while (bateria > 20)
    bateria -= 15;

// foreach: percorre cada item de uma colecao
string[] estacoes = { "Centro", "Parque", "Rodoviaria" };
foreach (string estacao in estacoes)
    Console.WriteLine(estacao);
```

Controle fino dentro dos laços:

*   `break` — interrompe o laço imediatamente.
*   `continue` — pula para a próxima iteração.

### 1.7. Coleções: Arrays, Matrizes e List

```csharp
// Array: tamanho FIXO, acesso por indice (comeca em 0)
int[] corridasPorDia = new int[7];
corridasPorDia[0] = 12;
Console.WriteLine(corridasPorDia.Length);   // 7

// Matriz (array bidimensional): ex. vagas por estacao x periodo
int[,] vagas = new int[3, 2];
vagas[0, 0] = 10;   // estacao 0, periodo manha

// List<T>: tamanho DINAMICO, a colecao mais usada no dia a dia
List<string> bikesDisponiveis = new List<string>();
bikesDisponiveis.Add("PU-0001");
bikesDisponiveis.Add("PU-0002");
bikesDisponiveis.Remove("PU-0001");
bool tem = bikesDisponiveis.Contains("PU-0002");    // true
int posicao = bikesDisponiveis.IndexOf("PU-0002");  // 0
Console.WriteLine(bikesDisponiveis.Count);          // 1
```

| Característica | Array | List&lt;T&gt; |
| :--- | :--- | :--- |
| **Tamanho** | Fixo, definido na criação. | Dinâmico, cresce conforme `Add`. |
| **Quantidade** | `.Length` | `.Count` |
| **Inserir/remover** | Não suporta diretamente. | `Add`, `Remove`, `Insert`, `Clear`. |
| **Uso típico** | Dados de tamanho conhecido e estável. | Coleções que mudam durante a execução. |

### 1.8. Manipulação de Strings

```csharp
string codigo = "pu-0042";

codigo.ToUpper();               // "PU-0042"
codigo.ToLower();               // "pu-0042"
codigo.Contains("0042");        // true
codigo.StartsWith("pu-");       // true
codigo.Substring(3);            // "0042"
codigo.Replace("-", "");        // "pu0042"
codigo.Split('-');              // ["pu", "0042"]
codigo.Trim();                  // remove espacos das pontas
"7".PadLeft(4, '0');            // "0007"
```

---

## 2. Estudo de Caso Prático: PedalUrbano

### Caso A: Calculadora de Tarifa de Corrida

A PedalUrbano cobra R$ 3,00 de desbloqueio mais um valor por faixa de tempo, com desconto conforme o plano do cliente. Veja o cálculo completo:

```csharp
decimal CalcularTarifa(int minutos, TipoPlano plano)
{
    const decimal taxaDesbloqueio = 3.00m;
    decimal valorTempo;

    // Faixas de tempo (regra de negocio da PedalUrbano)
    if (minutos <= 15)
        valorTempo = 4.00m;
    else if (minutos <= 30)
        valorTempo = 7.00m;
    else if (minutos <= 60)
        valorTempo = 12.00m;
    else
        valorTempo = 12.00m + (minutos - 60) * 0.30m;   // faixa cheia + 0,30 por minuto excedente

    // Desconto por plano com switch expression
    decimal desconto = plano switch
    {
        TipoPlano.Mensalista => 0.20m,
        TipoPlano.Turista => 0.10m,
        _ => 0m
    };

    decimal total = (taxaDesbloqueio + valorTempo) * (1 - desconto);
    return total;
}

decimal tarifa = CalcularTarifa(75, TipoPlano.Mensalista);
Console.WriteLine($"Tarifa da corrida: {tarifa.ToString("C")}");

// O enum fica ao FINAL do arquivo: as instrucoes top-level vem antes das declaracoes de tipo (secao 1.5)
enum TipoPlano
{
    Avulso,
    Mensalista,
    Turista
}
```

**Vantagem desse padrão:** as regras de negócio ficam legíveis como uma tabela de faixas, e o uso de `decimal` garante que valores monetários não sofram erros de arredondamento.

---

### Caso B: Painel de Ocupação das Estações

Ao fim do dia, a central consolida a ocupação das estações. Estações em manutenção são puladas, e a busca por vagas críticas para no primeiro alerta:

```csharp
string[] nomesEstacoes = { "Centro", "Parque", "Rodoviaria", "Orla", "Campus" };
List<int> bikesPorEstacao = new List<int> { 14, 3, 0, 18, 7 };
int capacidadePorEstacao = 20;
int emManutencao = 2;   // indice da estacao Rodoviaria

int totalBikes = 0;
for (int i = 0; i < nomesEstacoes.Length; i++)
{
    if (i == emManutencao)
    {
        Console.WriteLine($"{nomesEstacoes[i]}: EM MANUTENCAO (ignorada)");
        continue;   // pula para a proxima estacao
    }

    totalBikes += bikesPorEstacao[i];
    int vagasLivres = capacidadePorEstacao - bikesPorEstacao[i];
    Console.WriteLine($"{nomesEstacoes[i]}: {bikesPorEstacao[i]} bikes | {vagasLivres} vagas");
}

Console.WriteLine($"Total de bikes em operacao: {totalBikes}");

// Procura a primeira estacao lotada e para a busca
foreach (int quantidade in bikesPorEstacao)
    if (quantidade >= capacidadePorEstacao - 2)
    {
        Console.WriteLine("Alerta: existe estacao proxima da lotacao!");
        break;  // achou, nao precisa continuar
    }
```

**Vantagem desse padrão:** loops com coleções eliminam código repetido — o mesmo bloco atende 5 ou 500 estações — e `continue`/`break` expressam as exceções da regra sem aninhar condicionais.

---

## 3. Desafio da Semana

Monte o **fechamento do dia** da PedalUrbano: um programa console que processa as corridas registradas e imprime o relatório da operação.

### Requisitos:
1.  Declare os dados do dia em coleções fixas (sem entrada de usuário): um array `int[]` com os minutos de cada corrida e um array (ou `List`) com o plano de cada corrida, na mesma ordem. Use ao menos 8 corridas variadas.
2.  Calcule a tarifa de cada corrida com as regras do Caso A (desbloqueio de R$ 3,00 + faixas de tempo + desconto por plano).
3.  Acumule o **faturamento total** do dia.
4.  Classifique cada corrida com um `switch` (ou switch expression) em: `Curta` (até 15 min), `Media` (16 a 60 min) ou `Longa` (acima de 60 min), e conte quantas corridas caíram em cada categoria.
5.  Identifique a corrida mais cara do dia (posição e valor).
6.  Imprima o relatório final formatado com interpolação e `ToString("C")`: total de corridas, contagem por categoria, faturamento total e corrida mais cara.

### Estrutura para Desenvolvimento:
```csharp
// Program.cs - Fechamento do dia PedalUrbano
int[] minutosCorridas = { 12, 25, 70, 8, 45, 90, 30, 55 };
TipoPlano[] planosCorridas =
{
    TipoPlano.Avulso, TipoPlano.Mensalista, TipoPlano.Turista, TipoPlano.Avulso,
    TipoPlano.Mensalista, TipoPlano.Avulso, TipoPlano.Turista, TipoPlano.Mensalista
};

// TODO: calcular a tarifa de cada corrida (regras do Caso A)
// TODO: acumular o faturamento total
// TODO: classificar cada corrida (Curta / Media / Longa) e contar por categoria
// TODO: identificar a corrida mais cara
// TODO: imprimir o relatorio final formatado

enum TipoPlano
{
    Avulso,
    Mensalista,
    Turista
}
```

---
*Dica: valide o cálculo de UMA corrida isolada (ex.: 75 minutos, Mensalista) antes de montar o loop completo — depurar uma conta é mais fácil do que depurar oito.*
