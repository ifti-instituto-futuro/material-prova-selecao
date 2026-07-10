# Guia de Estudos: Lógica de Programação e C# Básico (PedalUrbano)

Bem-vindo ao guia de estudos do módulo de C# Básico. Todo o material prático utiliza o cenário da **PedalUrbano**, um sistema fictício de aluguel de bicicletas compartilhadas: estações espalhadas pela cidade, bikes identificadas por código e corridas tarifadas por tempo de uso.

### Regras de Negócio da PedalUrbano

Estas são as regras que os exemplos e exercícios do módulo utilizam:

1. A tarifa de uma corrida é composta por uma **taxa de desbloqueio fixa** (R$ 3,00) mais um **valor por faixa de minutos** de uso.
2. O **plano** do cliente altera o valor final: `Avulso` (sem desconto), `Mensalista` (20% de desconto) e `Turista` (10% de desconto).
3. Cada **estação** tem capacidade máxima de vagas e um status operacional (operacional, cheia, vazia ou em manutenção).
4. Toda **bike** é identificada por um código no formato `PU-0000` (prefixo `PU-` seguido de 4 dígitos).
5. Valores monetários são sempre calculados com o tipo `decimal`.
6. O programa de fidelidade **PedalClub** classifica clientes em `Diamante`, `Ouro`, `Prata` e `Bronze` conforme gasto mensal, tempo de casa e cartão do clube; estudantes recebem um benefício extra somado ao da categoria.
7. Recargas de créditos aceitam `Dinheiro` (5% de desconto), `Pix` (3% de desconto), `Débito` (sem ajuste) e `Crédito` (5% de taxa, com parcelamento); cupons válidos dão 10% de desconto, aplicado antes do ajuste da forma de pagamento.
8. A telemetria das docas considera **ideal** a faixa de 24°C a 28°C (inclusive) e **crítica** qualquer leitura acima de 30°C.

## Cronograma

*   **[Aula 1: Lógica de Programação e C# Básico](aula1-logica-e-csharp-basico.md)**
    *   Lógica de programação e o primeiro programa console (`dotnet run`).
    *   Variáveis e tipos: valor vs. referência.
    *   Operadores aritméticos, relacionais e lógicos; interpolação de strings.
    *   Conversão de tipos: cast, `Parse`, `TryParse` e formatação.
    *   Condicionais: `if/else`, ternário, `switch` e `enum`.
    *   Laços: `for`, `while`, `foreach`, `break` e `continue`.
    *   Coleções: arrays, matrizes e `List<T>`.
    *   Manipulação de strings.
    *   _Estudo de Caso: calculadora de tarifa e painel de ocupação da PedalUrbano._

*   **[Aula 2: Entrada de Dados, Conversões e Relatórios no Console](aula2-entrada-de-dados-e-conversoes.md)**
    *   `Console.ReadLine` e o padrão pergunta/resposta no console.
    *   `TryParse` para `int`, `decimal` e `bool`.
    *   Conversão de textos com ponto decimal: `CultureInfo.InvariantCulture`.
    *   Validação de entradas em loop (`while`).
    *   Relatórios em seções, `ToString("C")`/`("N2")` e ternário Sim/Não.
    *   _Estudo de Caso: totem de desbloqueio e validação de recarga vinda do aplicativo._

*   **[Aula 3: Decisões de Negócio — Classificações, Descontos e Menus](aula3-classificacoes-descontos-e-menus.md)**
    *   Condições compostas: `&&`, `||` e parênteses.
    *   Cadeias `if/else if` com faixas: ordem de avaliação e categoria padrão (`else` final).
    *   Descontos e taxas encadeados; parcelamento com `decimal`.
    *   Menus com `enum`: `Enum.GetValues`, `Enum.IsDefined` e cast da escolha do usuário.
    *   _Estudo de Caso: categorias do PedalClub e caixa de recarga de créditos._

*   **[Aula 4: Loops na Prática — Relatórios e Estatísticas](aula4-loops-e-relatorios-estatisticos.md)**
    *   Preenchimento de coleções com dados do usuário (inclusive quantidade definida por ele).
    *   Acumuladores, contadores condicionais e maior/menor com inicialização correta.
    *   Média, divisão inteira e a segunda passada (comparar com a média).
    *   Recálculo de estatísticas com `List` e `Add`.
    *   _Estudo de Caso: relatório diário de corridas e semana de quilometragem._

*   **[Aula 5: Coleções Dinâmicas — Cadastros e Consolidação de Dados](aula5-colecoes-dinamicas-e-consolidacao.md)**
    *   Listas paralelas: exibição, inclusão, atualização (`IndexOf`), consulta (`Contains`) e remoção sincronizada (`RemoveAt`).
    *   Consolidação de fontes: `AddRange`, remoção manual de duplicados e `Sort()`.
    *   Casos especiais: lista vazia (`Count == 0`), faixas inclusivas e alertas com flag.
    *   _Estudo de Caso: inventário da oficina e consolidação da telemetria das docas._

Após concluir a leitura de cada aula, resolva a lista de exercícios correspondente em [../exercicios](../exercicios/README.md) — da [Aula 1](../exercicios/aula1-exercicios.md) à [Aula 5](../exercicios/aula5-exercicios.md).
