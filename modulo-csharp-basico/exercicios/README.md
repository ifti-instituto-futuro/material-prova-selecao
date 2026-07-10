# Guia de Exercícios: Módulo C# Básico (PedalUrbano)

Bem-vindo aos exercícios práticos do módulo de C# Básico.

Este guia consolida o conteúdo estudado nas cinco aulas do módulo, simulando situações reais da PedalUrbano, o sistema de aluguel de bicicletas compartilhadas. O foco é aplicar lógica de programação, tipos, conversões, condicionais, laços, coleções, strings e validações em C#. A partir da Aula 2, o último exercício de cada lista acontece em um cenário diferente, no formato das questões de prova.

---

## Estrutura dos Exercícios

Cada aula possui uma lista de exercícios organizada de forma incremental — do exercício guiado (com esqueleto e TODOs) ao exercício livre (formato de prova, com saída esperada):

*   **[Aula 1: Lógica de Programação e C# Básico](aula1-exercicios.md)**
    *   Exercício 1: variáveis, tipos, operadores, conversão (`TryParse`) e formatação.
    *   Exercício 2: condicionais (`if/else`), `enum`, `switch` e expressões booleanas compostas.
    *   Exercício 3: laços (`for`, `foreach`, `break`, `continue`), arrays, `List<T>` e strings.

*   **[Aula 2: Entrada de Dados, Conversões e Relatórios no Console](aula2-exercicios.md)**
    *   Exercício 1 (guiado): `ReadLine`, `TryParse` e ficha formatada.
    *   Exercício 2: validação de entradas em loop (`while` + regras de negócio).
    *   Exercício 3: conversão de dados do sistema com `CultureInfo.InvariantCulture` e relatório de validação.
    *   Exercício 4 (livre): matrícula em curso online — conversões, desconto e comprovante.

*   **[Aula 3: Decisões de Negócio — Classificações, Descontos e Menus](aula3-exercicios.md)**
    *   Exercício 1 (guiado): classificação com condições compostas e benefícios.
    *   Exercício 2: descontos e taxas em cascata com parcelamento.
    *   Exercício 3: menu com `enum` (`Enum.GetValues` + `Enum.IsDefined`) e `switch`.
    *   Exercício 4 (livre): plano de academia — classificação, benefícios e pagamento.

*   **[Aula 4: Loops na Prática — Relatórios e Estatísticas](aula4-exercicios.md)**
    *   Exercício 1 (guiado): total, contador, maior/menor, média e classificação.
    *   Exercício 2: média de inteiros (divisão com cast) e posição do maior valor.
    *   Exercício 3: leitura de N valores, novo registro validado e recálculo com `List`.
    *   Exercício 4 (livre): boletim da turma — estatísticas completas com segunda passada.

*   **[Aula 5: Coleções Dinâmicas — Cadastros e Consolidação de Dados](aula5-exercicios.md)**
    *   Exercício 1 (guiado): cadastro com listas paralelas (Add, `IndexOf`, `Contains`, remoção sincronizada).
    *   Exercício 2: unificação de fontes (`AddRange`), dedup manual e `Sort()`.
    *   Exercício 3: análise por faixas, flag de alerta e caso de lista vazia.
    *   Exercício 4 (livre): estoque da farmácia — operações completas de cadastro.

---

## Como Resolver os Exercícios

1.  **Ambiente:** instale o SDK do .NET e confirme com `dotnet --version`. Crie um projeto console por exercício (`dotnet new console -n Exercicio1`) ou um único projeto com as soluções separadas por comentários.
2.  **Execução:** rode com `dotnet run` a cada etapa concluída e confira a saída no console.
3.  **Validação:** compare a saída do programa com o que cada requisito descreve. Se algo não bater, use `Console.WriteLine` em pontos intermediários para inspecionar valores.

Atenção: tente resolver todos os exercícios por conta própria antes de pedir ajuda. Ler mensagens de erro do compilador e corrigi-las é parte essencial do aprendizado de C#.
