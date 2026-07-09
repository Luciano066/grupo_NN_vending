# Controlador de Vending Machine em SystemVerilog

Projeto RTL de um controlador digital para uma vending machine, desenvolvido em SystemVerilog.

O sistema implementa uma maquina de venda com quatro produtos, controle de credito, verificacao de estoque, calculo de troco, tratamento de erro e cancelamento.

Este projeto foi desenvolvido para a atividade de RTL Design da residencia em microeletronica.

## Repositorio

```text
https://github.com/luciano066/grupo_NN_vending
```

## Objetivo do Projeto

O objetivo e implementar, simular e sintetizar um controlador digital de vending machine usando uma estrutura RTL modular.

O projeto cobre:

- Maquina de estados finitos para controle da operacao.
- Registro e acumulacao de credito em centavos.
- Memoria simples de produtos com preco e estoque.
- Comparacao entre credito, preco e disponibilidade.
- Calculo de troco.
- Cancelamento com devolucao de credito.
- Tratamento de erro para credito insuficiente ou estoque zerado.
- Sintese logica usando Synopsys Design Compiler e biblioteca SAED32.

## Estrutura de Pastas

```text
grupo_NN_vending/
|-- README.md
|-- .gitignore
|-- files.f
|-- rtl/
|   |-- vending_pkg.sv
|   |-- comparator.sv
|   |-- subtractor.sv
|   |-- credit_reg.sv
|   |-- memory.sv
|   |-- control_unit.sv
|   `-- vending_top.sv
|-- sim/
|   |-- tb_vending.sv
|   `-- sim.log
|-- synth/
|   |-- synth.tcl
|   |-- vending.sdc
|   |-- reports/
|   `-- netlist/
|-- scripts/
|   |-- run_sim.sh
|   |-- run_synth.sh
|   `-- sweep_clock.sh
`-- docs/
    |-- imagens/
    `-- relatorio.pdf
```

## Modulos RTL

| Arquivo | Funcao |
| --- | --- |
| `vending_pkg.sv` | Define os estados da FSM. |
| `comparator.sv` | Verifica se ha credito suficiente e estoque disponivel. |
| `subtractor.sv` | Calcula o troco da compra. |
| `credit_reg.sv` | Registra e acumula o credito inserido. |
| `memory.sv` | Armazena preco e estoque dos produtos. |
| `control_unit.sv` | Implementa a FSM principal do controlador. |
| `vending_top.sv` | Integra todos os blocos do sistema. |

## Biblioteca SAED32

A sintese usa a biblioteca tecnologica:

```text
saed32rvt_tt1p05v25c.db
```

Esse arquivo `.db` nao esta no repositorio porque pertence ao ambiente do laboratorio e pode ter restricoes de licenca. Por isso, a pasta `libs/` e arquivos `*.db` devem permanecer fora do Git.

Para recriar o link simbolico da biblioteca local:

```bash
mkdir -p libs
ln -sfn /home/luciano.oliveira/acumulador-oficial/libs/saed32rvt_tt1p05v25c.db \
  libs/saed32rvt_tt1p05v25c.db
```

O script `scripts/run_synth.sh` tambem cria esse link automaticamente antes de rodar a sintese.

## Lista de Arquivos para Simulacao

O arquivo `files.f` contem a ordem de compilacao usada pelo VCS:

```text
rtl/vending_pkg.sv
rtl/comparator.sv
rtl/subtractor.sv
rtl/credit_reg.sv
rtl/memory.sv
rtl/control_unit.sv
rtl/vending_top.sv
sim/tb_vending.sv
```

## Como Rodar a Simulacao

No ambiente do laboratorio, execute:

```bash
bash scripts/run_sim.sh
```

O script realiza as seguintes etapas:

- Carrega o ambiente Synopsys com `source /Tools/synopsys/snps.sh`.
- Compila o projeto com VCS usando `-f files.f`.
- Executa o simulador `./simv`.
- Salva a saida em `sim/sim.log`.

Resultado registrado:

```text
PASS = 23
FAIL = 0
TODOS OS TESTES PASSARAM.
```

## Como Rodar a Sintese

No ambiente do laboratorio, execute:

```bash
bash scripts/run_synth.sh
```

O script realiza as seguintes etapas:

- Carrega o ambiente Synopsys.
- Cria a pasta `libs/`.
- Recria o link simbolico da biblioteca SAED32.
- Executa o Design Compiler com `synth/synth.tcl`.
- Salva o log em `synth/synth.log`.

Comando principal:

```bash
dc_shell -f synth/synth.tcl | tee synth/synth.log
```

## Restricoes de Sintese

As restricoes principais ficam em `synth/vending.sdc`:

- Clock principal em `clk`.
- Incerteza de clock.
- Delays de entrada.
- Delays de saida.
- Carga nas saidas.
- Drive equivalente das entradas.

## Exploracao de Clock

Para varrer diferentes periodos de clock:

```bash
bash scripts/sweep_clock.sh
```

O script testa os periodos:

```text
20 18 16 14 12 10 8 6 5 4
```

Para cada periodo, o script atualiza o SDC, roda o Design Compiler e salva relatorios em `synth/reports/`, por exemplo:

```text
synth/reports/area_20ns.rpt
synth/reports/timing_20ns.rpt
```

## Resultados Obtidos

### Simulacao

| Metrica | Valor |
| --- | ---: |
| Testes aprovados | 23 |
| Testes com falha | 0 |

Resultado final:

```text
TODOS OS TESTES PASSARAM.
```

### Sintese Inicial

| Metrica | Valor |
| --- | ---: |
| Clock | 20 ns |
| Frequencia | 50 MHz |
| Area total | 1122.808214 |
| Slack | 14.56 ns |

### Exploracao de Clock

| Periodo | Frequencia | Slack |
| ---: | ---: | ---: |
| 20 ns | 50.00 MHz | 14.56 ns |
| 18 ns | 55.56 MHz | 12.56 ns |
| 16 ns | 62.50 MHz | 10.56 ns |
| 14 ns | 71.43 MHz | 8.56 ns |
| 12 ns | 83.33 MHz | 6.56 ns |
| 10 ns | 100.00 MHz | 4.56 ns |
| 8 ns | 125.00 MHz | 2.56 ns |
| 6 ns | 166.67 MHz | 0.56 ns |
| 5 ns | 200.00 MHz | 0.06 ns |
| 4 ns | 250.00 MHz | -0.19 ns |

Conclusoes:

- Menor periodo com slack positivo: `5 ns`.
- Frequencia maxima confirmada: `200 MHz`.
- Primeiro periodo com violacao: `4 ns`.

## Caminho Critico

No periodo de `4 ns`, foi observado o seguinte caminho critico:

```text
Startpoint: coin_in[1]
Endpoint: u_credit_reg/credit_reg[5]
Modulo critico: credit_reg
Slack em 4 ns: -0.19 ns
```

## Comparacao com e sem -no_autoungroup

Comparacao da sintese em `5 ns`:

| Configuracao | Area | Slack |
| --- | ---: | ---: |
| `compile_ultra -no_autoungroup` | 1129.670102 | 0.06 ns |
| `compile_ultra` | 1045.548436 | 0.44 ns |

A versao sem `-no_autoungroup` permitiu maior otimizacao entre hierarquias, reduzindo a area e melhorando o slack no ponto de `5 ns`.

## Arquivos Gerados

Arquivos de simulacao, logs temporarios, bibliotecas locais e arquivos `.db` nao devem ser adicionados ao Git.

Exemplos ignorados pelo repositorio:

- `libs/`
- `*.db`
- `simv`
- `simv.daidir/`
- `csrc/`
- `vfastLog/`
- `verdiLog/`
- `synth/work/`
- `synth/*.log`

Os relatorios principais em `synth/reports/` e a netlist em `synth/netlist/` sao mantidos no projeto.

Arquivos de sintese presentes no repositorio:

- `synth/reports/area.rpt`
- `synth/reports/timing.rpt`
- `synth/reports/power.rpt`
- `synth/reports/constraint.rpt`
- `synth/reports/check_design.rpt`
- `synth/netlist/vending_top_netlist.v`
- `synth/netlist/vending_top_mapped.sdc`

## Documentacao

O relatorio do projeto fica em:

```text
docs/relatorio.pdf
```

A pasta `docs/imagens/` foi criada para armazenar futuramente imagens de waveforms e evidencias de simulacao.
