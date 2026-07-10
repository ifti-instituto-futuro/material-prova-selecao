# Aula 3: Decisões de Negócio — Classificações, Descontos e Menus

Nesta lista de exercícios, você colocará em prática condições compostas (`&&`, `||`, parênteses), cadeias de classificação `if/else if/else`, descontos e taxas encadeados, parcelamento e menus com `enum` (`Enum.GetValues` + `Enum.IsDefined`). Os três primeiros exercícios acontecem na PedalUrbano; o último simula uma questão de prova em outro cenário.

Lembre-se do padrão do módulo: chaves `{}` apenas em blocos com **mais de uma instrução** — bloco de uma única instrução fica sem chaves, apenas indentado.

---

## Exercício 1 (guiado): Classificador do PedalClub

### Cenário:
Você vai implementar o classificador oficial do PedalClub passo a passo, seguindo os TODOs do esqueleto. As regras: **Diamante** para gasto acima de R$ 300 OU (gasto acima de R$ 150 E mais de 12 meses de casa); **Ouro** para gasto entre R$ 80 e R$ 150 com cartão do clube; **Prata** para gasto entre R$ 40 e R$ 79,99; **Bronze** para o restante.

### Requisitos:
1. Copie o esqueleto e resolva um TODO por vez, rodando `dotnet run` a cada passo.
2. No TODO 1, escreva a condição do Diamante com `||`, `&&` e parênteses — leia a regra em voz alta antes.
3. No TODO 2, complete a cadeia `else if` na ordem correta (da categoria mais alta para a mais baixa) e feche com `else` para o Bronze.
4. No TODO 3, defina os benefícios com um switch expression: Diamante = `"30 min gratis + Bike eletrica + Suporte prioritario"`, Ouro = `"15 min gratis + Bike eletrica"`, Prata = `"10 min gratis"`, Bronze = `"5 min gratis na primeira corrida"`.
5. No TODO 4, se `ehEstudante` for verdadeiro, concatene `" + 20% na mensalidade"` aos benefícios com `+=`.
6. No TODO 5, exiba o relatório com os dados do cliente (booleanos como Sim/Não) e a classificação.
7. Teste com os três clientes indicados nos comentários e confira a categoria de cada um.

```csharp
// Program.cs - Classificador PedalClub
// Teste 1: gasto 180,00 / 14 meses / com cartao / estudante  -> Diamante
// Teste 2: gasto 95,50  / 5 meses  / com cartao / nao        -> Ouro
// Teste 3: gasto 260,00 / 8 meses  / sem cartao / nao        -> qual categoria? Por que?
decimal gastoMes = 180.00m;
int mesesCliente = 14;
bool possuiCartaoClube = true;
bool ehEstudante = true;

// TODO 1: condicao do Diamante (|| e && com parenteses)
// TODO 2: cadeia if / else if / else completa
// TODO 3: beneficios por categoria (switch expression)
// TODO 4: beneficio extra de estudante (+=)
// TODO 5: relatorio final
```

---

## Exercício 2: Fechamento com Descontos em Cascata

### Cenário:
No fechamento de uma corrida avulsa, a PedalUrbano aplica os ajustes **em sequência**, cada um sobre o valor já processado: primeiro o desconto do plano, depois o da forma de pagamento — e o parcelamento só existe no crédito.

### Requisitos:
1. Declare o valor da corrida (`decimal`, ex.: `48.00m`), o plano do cliente (`"Mensalista"`, 20% de desconto; `"Turista"`, 10%; `"Avulso"`, sem desconto) e a forma de pagamento como `string` (`"Dinheiro"`, `"Pix"`, `"Debito"` ou `"Credito"`).
2. Aplique o desconto do plano e guarde o resultado em uma variável própria (ex.: `valorAposPlano`).
3. Sobre o valor já processado, aplique o ajuste da forma de pagamento com um `switch`: Dinheiro −5%, Pix −3%, Débito 0%, Crédito +5% de taxa.
4. Se o pagamento for Crédito, calcule o valor de 4 parcelas; senão, exiba `"Pagamento a vista"`.
5. Exiba o relatório completo com o valor original, cada ajuste (valor em R$), o valor final e o parcelamento.
6. Confira no papel: para R$ 48,00, Mensalista, Crédito, o valor final deve ser R$ 40,32 (48 × 0,80 × 1,05). Se o seu programa mostrar outro número, algum ajuste não está em cascata.

---

## Exercício 3: Menu de Vistoria da Oficina

### Cenário:
A oficina da PedalUrbano faz vistorias guiadas por um menu no console. O mecânico escolhe o tipo de vistoria e o sistema informa o procedimento e o tempo previsto.

### Requisitos:
1. Crie o `enum TipoVistoria` com `Freios = 1`, `Pneus = 2`, `Bateria = 3` e `RevisaoCompleta = 4`.
2. Exiba o menu percorrendo o enum com `foreach` + `Enum.GetValues`, no formato `1 - Freios`.
3. Leia a escolha com `int.TryParse` e valide com `Enum.IsDefined`, repetindo a pergunta em loop até receber uma opção existente.
4. Com um `switch` sobre o enum, defina o procedimento e o tempo: Freios = ajuste e troca de pastilhas (20 min); Pneus = calibragem e inspeção (10 min); Bateria = teste de carga (15 min); RevisaoCompleta = todos os itens (45 min).
5. Exiba a ordem de serviço com a vistoria escolhida, o procedimento e o tempo previsto.
6. Extra: se a bike for elétrica (`bool` fixo) e a vistoria **não** for de Bateria, adicione a linha `"Recomendacao: incluir teste de bateria"` na ordem de serviço.

---

## Exercício 4 (livre): Plano de Academia

### Cenário:
Uma academia automatizou a venda de planos. O sistema classifica o aluno, monta os benefícios e calcula a primeira mensalidade com os ajustes de pagamento. Resolva como uma questão de prova: sem passos guiados, apenas com as regras e a saída esperada.

O aluno Diego Ramos, de 27 anos, treina há 3 anos e é estudante. Ele contratou o plano com mensalidade de R$ 120,00, pagará no Pix e não usará parcelamento. As regras: **Atleta** para quem treina há mais de 5 anos OU tem menos de 25 anos e treina há mais de 2; **Intermediario** para quem treina entre 2 e 5 anos; **Iniciante** para o restante. Benefícios: Atleta = `"Avaliacao fisica mensal + Acompanhamento nutricional"`, Intermediario = `"Avaliacao fisica trimestral"`, Iniciante = `"Aula inaugural gratuita"`. Estudantes ganham, além do benefício da categoria, `" + 15% de desconto na mensalidade"` (o desconto é aplicado no valor). Pagamento: Dinheiro −5%, Pix −3%, Crédito +5% (sobre o valor já com desconto de estudante, se houver).

### Saída Esperada:

```
=== PLANO ACADEMIA FORCA TOTAL ===
Aluno: Diego Ramos
Idade: 27 anos
Tempo de treino: 3 anos
Estudante: Sim

Categoria: Intermediario
Beneficios: Avaliacao fisica trimestral + 15% de desconto na mensalidade

Mensalidade: R$ 120,00
Desconto Estudante (15%): R$ 18,00
Ajuste Pix (3%): R$ 3,06
VALOR FINAL: R$ 98,94
Tipo de Pagamento: A vista
```

---
*Dica: no exercício 4, calcule a saída esperada no papel ANTES de rodar o programa. Se o seu resultado bater com a conta manual e com a saída esperada, você domina o encadeamento — é exatamente assim que o avaliador confere a prova.*
