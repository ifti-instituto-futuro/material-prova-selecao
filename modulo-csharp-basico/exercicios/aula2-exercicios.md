# Aula 2: Entrada de Dados, Conversões e Relatórios no Console

Nesta lista de exercícios, você colocará em prática `Console.ReadLine`, as conversões com `TryParse` (`int`, `decimal` e `bool`), a conversão de textos com ponto decimal usando `CultureInfo.InvariantCulture`, a validação de entradas em loop e a montagem de relatórios em seções. Os três primeiros exercícios acontecem na PedalUrbano; o último simula uma questão de prova em outro cenário.

Lembre-se do padrão do módulo: chaves `{}` apenas em blocos com **mais de uma instrução** — bloco de uma única instrução fica sem chaves, apenas indentado.

---

## Exercício 1 (guiado): Ficha de Devolução no Totem

### Cenário:
Ao devolver uma bike, o cliente informa os dados da corrida no totem da estação. Você vai montar esse fluxo passo a passo — siga os TODOs do esqueleto abaixo.

### Requisitos:
1. Copie o esqueleto para o seu `Program.cs` e resolva um TODO por vez, executando `dotnet run` a cada passo.
2. No TODO 1, leia o código da bike com `Console.ReadLine() ?? ""` e normalize com `Trim().ToUpper()`.
3. No TODO 2, leia os minutos de uso e converta com `int.TryParse`. Se a conversão falhar, exiba `"Minutos invalidos."` e encerre com `return;`.
4. No TODO 3, leia o valor por minuto (digitado com vírgula, ex.: `0,45`) e converta com `decimal.TryParse`. Se falhar, exiba `"Valor invalido."` e encerre.
5. No TODO 4, calcule o custo da corrida (minutos × valor por minuto).
6. No TODO 5, imprima a ficha em seção única `=== DEVOLUCAO ===` com: código da bike, minutos, valor por minuto e custo — os valores monetários com `ToString("C")`.

```csharp
// Program.cs - Ficha de devolucao
Console.WriteLine("=== TOTEM DE DEVOLUCAO ===");

// TODO 1: ler e normalizar o codigo da bike
// TODO 2: ler os minutos de uso com int.TryParse (encerrar se invalido)
// TODO 3: ler o valor por minuto com decimal.TryParse (encerrar se invalido)
// TODO 4: calcular o custo da corrida
// TODO 5: imprimir a ficha formatada
```

---

## Exercício 2: Recarga com Validação Insistente

### Cenário:
A central percebeu que muitos clientes erram a digitação na primeira tentativa. Em vez de encerrar o programa, o totem deve **insistir até receber um valor válido**.

### Requisitos:
1. Leia o valor da recarga em um laço `while`: repita até a entrada converter para `decimal` **e** ser maior ou igual a R$ 5,00. A cada erro, mostre uma mensagem explicando o problema.
2. Leia a quantidade de meses do plano em outro laço `while`: repita até converter para `int` **e** estar entre 1 e 24.
3. Após as duas leituras, aplique a regra: recargas de R$ 50,00 ou mais ganham 10% de bônus em créditos. Calcule o crédito final.
4. Exiba o resumo com valor pago, bônus (se houver) e crédito final, tudo com `ToString("C")` e o bônus como Sim/Não usando ternário.

---

## Exercício 3: Importação de Corridas do Aplicativo

### Cenário:
O aplicativo exporta cada corrida como três textos no formato internacional (ponto decimal). A central precisa validar campo a campo antes de aceitar o registro — inclusive quando os dados vêm corrompidos.

### Requisitos:
1. Declare os dados recebidos: `string tarifaTexto = "18.70";`, `string minutosTexto = "52";` e `string planoAtivoTexto = "true";`.
2. Converta a tarifa com `decimal.TryParse` usando `NumberStyles.Number` e `CultureInfo.InvariantCulture` (não esqueça o `using System.Globalization;`). Converta os minutos com `int.TryParse` e o plano com `bool.TryParse`.
3. Imprima uma seção `VALIDACAO` com uma linha `OK`/`ERRO` para cada um dos três campos, usando ternário.
4. Se todas as conversões passaram, imprima a seção `CORRIDA IMPORTADA` com os valores convertidos (tarifa com `ToString("C")`, plano como Sim/Não). Se qualquer uma falhou, imprima apenas `"Registro rejeitado."`.
5. Rode de novo trocando `tarifaTexto` para `"18,70x"` e confira que o programa reporta o `ERRO` sem quebrar.
6. Explique em um comentário no código: o que aconteceria se a tarifa `"18.70"` fosse convertida **sem** `InvariantCulture` em um computador brasileiro?

---

## Exercício 4 (livre): Matrícula em Curso Online

### Cenário:
Uma escola de cursos online recebe matrículas por um formulário que entrega todos os campos como texto. O sistema precisa validar as conversões, calcular o valor da matrícula e exibir o comprovante. Resolva como se fosse uma questão de prova: sem passos guiados, apenas com os dados e a saída esperada.

Os dados chegaram assim: nome `"Carla Menezes"` (texto), idade `"22"` (texto), mensalidade `"149.90"` (texto, formato internacional) e bolsista `"true"` (texto). Bolsistas têm 30% de desconto na mensalidade. Menores de 18 anos precisam exibir a linha `Autorizacao do responsavel: PENDENTE` no comprovante; maiores, `Autorizacao do responsavel: Nao se aplica`.

### Saída Esperada:

```
=== MATRICULA ONLINE ===

VALIDACAO
Idade convertida: OK
Mensalidade convertida: OK
Bolsista convertido: OK

COMPROVANTE
Aluna: Carla Menezes
Idade: 22 anos
Bolsista: Sim
Mensalidade: R$ 149,90
Desconto (30%): R$ 44,97
Valor Final: R$ 104,93
Autorizacao do responsavel: Nao se aplica
```

---
*Dica: nos exercícios 3 e 4, provoque erros de propósito (troque `"true"` por `"sim"`, o ponto por vírgula) e observe qual conversão falha — saber PREVER o erro é o que a prova avalia.*
