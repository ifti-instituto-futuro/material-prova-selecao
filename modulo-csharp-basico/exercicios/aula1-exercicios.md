# Aula 1: Lógica de Programação e C# Básico

Nesta lista de exercícios, você colocará em prática variáveis, tipos, operadores, conversões, condicionais, enums, laços de repetição, coleções e strings, sempre no cenário da PedalUrbano. Crie um projeto console (`dotnet new console`) para cada exercício, ou um único projeto com as soluções separadas por comentários.

Lembre-se do padrão do módulo: chaves `{}` apenas em blocos com **mais de uma instrução** — bloco de uma única instrução fica sem chaves, apenas indentado.

---

## Exercício 1: Ficha da Corrida

### Cenário:
Uma cliente acabou de encerrar sua primeira corrida na PedalUrbano e o aplicativo precisa montar a ficha do aluguel: dados da bike, tempo de uso e custo bruto, tudo formatado para exibição.

### Requisitos:
1. Declare as variáveis da corrida com os tipos corretos: código da bike (`string`, ex.: `"PU-0042"`), minutos de uso (`int`), valor por minuto (`decimal`, ex.: `0.45m`), plano ativo (`bool`) e categoria da bike (`char`, ex.: `'E'` para elétrica).
2. Calcule o custo bruto da corrida (minutos de uso multiplicados pelo valor por minuto) e guarde em uma variável `decimal`.
3. Simule uma entrada digitada pelo usuário: declare `string entradaMinutos = "38";` e converta para `int` usando `int.TryParse`. Teste também com um valor inválido (ex.: `"3b"`) e exiba uma mensagem de erro amigável nesse caso, sem deixar o programa quebrar.
4. Calcule quantas horas completas e quantos minutos restantes a corrida durou, usando divisão inteira (`/`) e resto (`%`).
5. Exiba a ficha completa da corrida usando interpolação (`$"..."`) e o custo formatado como moeda com `ToString("C")`.

---

## Exercício 2: Tarifas e Status da Estação

### Cenário:
A central de operações precisa automatizar duas decisões: o cálculo da tarifa por faixa de tempo e a ação recomendada para cada status de estação. Também é preciso validar se um desbloqueio de bike pode ser autorizado.

### Requisitos:
1. Calcule a tarifa de uma corrida usando `if / else if / else` com 4 faixas: até 15 minutos (R$ 4,00), de 16 a 30 (R$ 7,00), de 31 a 60 (R$ 12,00) e acima de 60 (R$ 12,00 mais R$ 0,30 por minuto excedente). Teste com pelo menos 3 durações diferentes.
2. Crie o `enum StatusEstacao` com os valores `Operacional`, `Cheia`, `Vazia` e `EmManutencao`. Declare uma variável desse enum e use um `switch` para imprimir a ação recomendada para cada status (ex.: `Cheia` orienta redistribuir bikes; `EmManutencao` bloqueia novas devoluções).
3. Valide a autorização de um desbloqueio com uma única expressão booleana composta: o desbloqueio é permitido se (o saldo do cliente for suficiente para a taxa **e** a estação estiver `Operacional`) **ou** se o cliente for mensalista. Use `&&`, `||` e parênteses.
4. Quando o desbloqueio for negado, informe o motivo exato (saldo insuficiente ou estação indisponível) usando condicionais aninhadas ou testes separados.

---

## Exercício 3: Relatório da Frota

### Cenário:
Fim de expediente na PedalUrbano. A equipe de operações precisa consolidar os números da frota: tempo de uso, bikes cadastradas e a validação dos códigos no padrão da empresa.

### Requisitos:
1. Declare um array `int[]` com as durações (em minutos) de 10 corridas do dia. Percorra-o com `for`, somando o total de minutos e identificando a corrida mais longa (valor e posição).
2. Crie uma `List<string>` com códigos de bikes (ex.: `"PU-0001"`, `"PU-0002"`...). Adicione 2 códigos com `Add`, remova 1 com `Remove` e verifique com `Contains` se um código específico está na frota — tratando com mensagem adequada o caso de código inexistente.
3. Percorra a lista com `foreach` pulando (com `continue`) as bikes marcadas como em manutenção (defina uma segunda lista ou array com esses códigos) e interrompendo a varredura (com `break`) se encontrar um código vazio (`""`).
4. Valide o formato de cada código: deve começar com `"PU-"` (use `StartsWith`) e ter 4 dígitos após o traço (use `Split` e o comprimento da segunda parte). Normalize códigos digitados em minúsculas com `ToUpper` antes de validar.
5. Imprima o relatório final numerado (use o índice do laço) com: total de minutos rodados, corrida mais longa, quantidade de bikes ativas e a lista de códigos válidos.

---
*Dica: rode o programa após cada requisito concluído (`dotnet run`) em vez de escrever tudo de uma vez — encontrar um erro em 5 linhas novas é muito mais fácil do que em 50.*
