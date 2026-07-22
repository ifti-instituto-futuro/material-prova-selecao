# Módulo C# Básico e Lógica de Programação

Bem-vindo ao repositório do **Módulo de C# Básico e Lógica de Programação**.

Este material foi elaborado para construir a base de programação exigida de todo desenvolvedor: raciocínio lógico, domínio de tipos e variáveis, estruturas de decisão e repetição, coleções e manipulação de textos em **C# / .NET**. Todo o conteúdo prático é baseado no cenário da **PedalUrbano**, um sistema fictício de aluguel de bicicletas compartilhadas, aproximando a teoria de problemas reais.

## Estrutura do Curso

O conteúdo está organizado em cinco aulas, cada uma com guia teórico, estudo de caso e desafio prático.

1. **Aula 1: Lógica de Programação e C# Básico**
   - Lógica de programação e o primeiro programa console.
   - Tipos de valor e de referência; variáveis e `var`.
   - Operadores aritméticos, relacionais e lógicos; interpolação de strings.
   - Conversões: cast, `Parse`, `TryParse` e formatação (`ToString("C")`).
   - Condicionais: `if/else`, operador ternário, `switch` e `enum`.
   - Laços: `for`, `while`, `foreach`, `break` e `continue`.
   - Coleções: arrays, matrizes e `List<T>`.
   - Manipulação de strings.

2. **Aula 2: Entrada de Dados, Conversões e Relatórios no Console**
   - `Console.ReadLine` e o padrão pergunta/resposta no console.
   - `TryParse` para `int`, `decimal` e `bool`; normalização de `sim/nao` para booleano; conversão de textos com ponto decimal (`CultureInfo.InvariantCulture`).
   - Validação de entradas em loop (`while`).
   - Relatórios em seções, `ToString("C")`/`("N2")` e ternário Sim/Não.

3. **Aula 3: Decisões de Negócio — Classificações, Descontos e Menus**
   - Condições compostas (`&&`, `||`, parênteses) e ordem de avaliação nas cadeias `if/else if`.
   - Descontos e taxas encadeados; parcelamento com `decimal`.
   - Menus com `enum`: `Enum.GetValues`, `Enum.IsDefined` e conversão da escolha do usuário.

4. **Aula 4: Loops na Prática — Relatórios e Estatísticas**
   - Preenchimento de coleções com dados do usuário (inclusive quantidade definida por ele).
   - Acumuladores, contadores, maior/menor, média e a segunda passada.
   - Recálculo de estatísticas com `List` e `Add`.

5. **Aula 5: Coleções Dinâmicas — Cadastros e Consolidação de Dados**
   - Listas paralelas: inclusão, atualização (`IndexOf`), consulta (`Contains`) e remoção sincronizada.
   - Consolidação de fontes: `AddRange`, remoção manual de duplicados, `Sort()` e casos especiais.

**Fora do escopo deste módulo:** classes e orientação a objetos, LINQ e tratamento de exceções — esses temas são estudados nos módulos seguintes da trilha.

## Padrões de Código (Guidelines)

- Nomes de variáveis locais em `camelCase`; métodos, classes e enums em `PascalCase`.
- Chaves `{}` **apenas em blocos com mais de uma instrução**; bloco de uma única instrução fica sem chaves, apenas indentado.
- Valores monetários **sempre** com o tipo `decimal` (sufixo `m`).
- Interpolação de strings (`$"..."`) em vez de concatenação com `+`.
- Nomes descritivos: `minutosCorrida` em vez de `mc` ou `x`.

## Organização do Repositório

- [guia_estudos](guia_estudos/README.md): apostila da aula e regras de negócio do cenário PedalUrbano.
- [exercicios](exercicios/README.md): lista de exercícios práticos da aula.

## Como Começar

1. Instale o SDK do .NET ([dotnet.microsoft.com](https://dotnet.microsoft.com)) e confirme com `dotnet --version`.
2. Instale o Visual Studio Code com a extensão C# Dev Kit.
3. Crie seu primeiro projeto com `dotnet new console` e execute com `dotnet run`.
4. Siga a trilha de leitura a partir de [guia_estudos/README.md](guia_estudos/README.md).

---
*Desenvolvido para o Instituto Futuro.*
