# Aula 4: Loops na Prática — Relatórios e Estatísticas

Nesta lista de exercícios, você colocará em prática os padrões estatísticos: acumulador, contador condicional, maior/menor com inicialização correta, média (e o perigo da divisão inteira), a segunda passada para comparar com a média e o recálculo com `List`. Os três primeiros exercícios acontecem na PedalUrbano; o último simula uma questão de prova em outro cenário.

Lembre-se do padrão do módulo: chaves `{}` apenas em blocos com **mais de uma instrução** — bloco de uma única instrução fica sem chaves, apenas indentado.

---

## Exercício 1 (guiado): Relatório da Manhã

### Cenário:
A central quer o relatório das corridas da manhã. Os valores já estão no sistema — seu trabalho é montar a análise passo a passo, seguindo os TODOs.

### Requisitos:
1. Copie o esqueleto e resolva um TODO por vez, rodando `dotnet run` a cada passo.
2. No TODO 1, imprima as tarifas numeradas no formato `Corrida 1: R$ 12,50` (use `{i + 1}`).
3. No TODO 2, em uma única passada `foreach`, calcule o total (acumulador), conte as tarifas acima de R$ 10,00 (contador) e encontre a maior e a menor (inicializando as duas com `tarifas[0]`).
4. No TODO 3, calcule a média a partir do total.
5. No TODO 4, classifique a manhã: acima de R$ 60 = `"Otima"`, de R$ 40 a R$ 60 = `"Normal"`, abaixo de R$ 40 = `"Fraca"`.
6. No TODO 5, imprima o relatório em seções com `ToString("C")`.

```csharp
// Program.cs - Relatorio da manha
decimal[] tarifas = { 12.50m, 4.00m, 23.00m, 8.90m, 15.70m, 6.20m };

Console.WriteLine("=== RELATORIO DA MANHA ===");

// TODO 1: imprimir as tarifas numeradas
// TODO 2: uma passada: total, contador (> 10), maior e menor
// TODO 3: media
// TODO 4: classificacao da manha
// TODO 5: relatorio final em secoes
```

---

## Exercício 2: Minutos de Uso da Frota

### Cenário:
A operação analisa o tempo de uso das bikes — e aqui os valores são **inteiros** (minutos), o que esconde uma armadilha na média.

### Requisitos:
1. Leia do usuário a duração (em minutos, `int` validado em loop como maior que zero) de 6 corridas, preenchendo um array `int[]`.
2. Em uma passada, calcule o total de minutos e encontre a corrida mais longa **e a posição dela** (guarde valor e índice).
3. Calcule a média de minutos **com casas decimais** — converta com `(decimal)` antes de dividir e comprove no relatório que ela não veio truncada.
4. Na segunda passada, conte quantas corridas duraram acima da média.
5. Exiba o relatório: corridas numeradas, total, corrida mais longa (posição e valor), média com `ToString("N1")` e a contagem acima da média.

---

## Exercício 3: Auditoria com Corrida Extra

### Cenário:
Durante a auditoria do dia, o auditor decide quantas corridas vai conferir, digita os valores e, no fim, descobre uma corrida que ficou fora — as estatísticas precisam ser refeitas.

### Requisitos:
1. Pergunte quantas corridas serão auditadas (inteiro entre 2 e 15, validado em loop).
2. Leia cada tarifa (positiva, validada em loop) para dentro de uma `List<decimal>`.
3. Calcule e exiba: quantidade, total, maior, menor e média.
4. Leia a corrida extra (também validada como positiva) e adicione com `Add`.
5. Recalcule e exiba as mesmas estatísticas — confira que a quantidade aumentou em 1 e que os extremos consideram o novo valor.
6. Conte e exiba quantas tarifas ficaram acima de R$ 25,00 e quantas abaixo de R$ 8,00.

---

## Exercício 4 (livre): Boletim da Turma

### Cenário:
Uma escola processa as notas de uma avaliação e monta o boletim estatístico da turma. Resolva como uma questão de prova: sem passos guiados, apenas com as regras e a saída esperada.

O programa deve solicitar ao usuário as notas dos 6 alunos da turma (aceite valores com vírgula, de 0 a 10, validando em loop). Depois deve calcular a média da turma, encontrar a maior e a menor nota, contar quantos alunos ficaram acima da média e quantos ficaram abaixo de 6,0 (recuperação). Por fim, classifica a turma: média maior ou igual a 8 = `"Turma excelente"`, entre 6 e 7,99 = `"Turma regular"`, abaixo de 6 = `"Turma em recuperacao"`.

Para as notas `8,5`, `6,0`, `9,2`, `4,5`, `7,0` e `5,8`, a saída deve ser:

### Saída Esperada:

```
=== BOLETIM DA TURMA ===
Aluno 1: 8,5
Aluno 2: 6,0
Aluno 3: 9,2
Aluno 4: 4,5
Aluno 5: 7,0
Aluno 6: 5,8

Media da turma: 6,8
Maior nota: 9,2
Menor nota: 4,5
Alunos acima da media: 3
Alunos em recuperacao: 2

Classificacao: Turma regular
```

---
*Dica: no exercício 4, antes de codificar, responda no papel: quais estatísticas saem na primeira passada? Qual exige a segunda? Se "alunos acima da média" apareceu na sua primeira passada, releia a seção 1.5 da aula.*
