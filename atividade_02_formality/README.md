# Verificação de Equivalência Formal da Vending Machine

## Objetivo da atividade

Esta atividade verifica formalmente se duas implementações sintetizadas da vending machine — uma com a hierarquia preservada (`grouped`) e outra com desagrupamento automático (`ungrouped`) — mantêm o mesmo comportamento lógico do RTL SystemVerilog. A síntese é feita no Synopsys Design Compiler e a comparação, no Synopsys Formality.

A máquina aceita moedas, acumula crédito, consulta preço e estoque do produto selecionado, entrega o produto quando a compra é válida, calcula o troco e trata cancelamento, crédito insuficiente e estoque zerado.

## Conceitos principais

- **RTL (Register Transfer Level):** descrição do circuito em termos de registradores, lógica combinacional e transferências de dados controladas por clock.
- **Netlist sintetizada:** representação do mesmo circuito após a síntese, composta por células da biblioteca tecnológica e suas conexões.
- **Equivalência formal:** prova matemática de que a referência RTL e a implementação sintetizada produzem comportamentos equivalentes sob as configurações utilizadas, sem depender de vetores de teste.
- **Compare points:** pontos de comparação criados pelo Formality, normalmente associados a saídas e elementos sequenciais dos dois projetos.
- **SVF (Synopsys Verification Format):** guia produzido pelo Design Compiler com informações sobre transformações realizadas na síntese. O Formality usa essas informações para facilitar o casamento entre referência e implementação.
- **Grouped:** síntese executada com `compile_ultra -no_autoungroup`, preservando as fronteiras hierárquicas dos módulos.
- **Ungrouped:** síntese executada com `compile_ultra`, permitindo que o Design Compiler remova fronteiras hierárquicas para otimizar o circuito.
- **match:** etapa que associa os compare points do RTL aos pontos correspondentes da netlist.
- **verify:** etapa que prova a equivalência dos compare points associados.

## Estrutura das pastas

```text
atividade_02_formality/
|-- README.md
|-- rtl/                 # Fontes SystemVerilog da vending machine
|-- synth/
|   |-- synth_grouped.tcl
|   |-- synth_ungrouped.tcl
|   `-- vending.sdc
|-- fm/
|   |-- formality_grouped.tcl
|   `-- formality_ungrouped.tcl
`-- scripts/
    |-- run_synth_formality.sh
    |-- run_formality.sh
    `-- check_results.sh
```

Os diretórios `synth/netlist/`, `synth/reports/`, `synth/logs/`, `fm/reports/` e `fm/logs/` são criados durante a execução. Diretórios temporários como `work/` e `formality_svf/` também podem surgir, mas não devem ser versionados.

## Módulos RTL

| Arquivo | Responsabilidade |
| --- | --- |
| `rtl/vending_pkg.sv` | Declara o tipo enumerado e os estados `IDLE`, `COLLECT`, `CHECK`, `DISPENSE`, `CHANGE` e `ERROR`. |
| `rtl/comparator.sv` | Autoriza a venda quando o crédito cobre o preço e o estoque é maior que zero. |
| `rtl/subtractor.sv` | Calcula o troco pela diferença entre crédito e preço. |
| `rtl/credit_reg.sv` | Decodifica as moedas, acumula o crédito e o limpa após reset, cancelamento ou compra. |
| `rtl/memory.sv` | Armazena preço e estoque de quatro produtos, fornece a leitura selecionada e decrementa uma unidade vendida. |
| `rtl/control_unit.sv` | Implementa a FSM que coordena coleta, consulta, entrega, troco, erro e cancelamento. |
| `rtl/vending_top.sv` | Integra a unidade de controle e todo o caminho de dados, expondo entrega, troco, erro, display e estado. |

## Scripts principais

### `synth/synth_grouped.tcl`

Analisa e elabora o RTL, liga o projeto à biblioteca SAED32, aplica `synth/vending.sdc`, grava o SVF e executa `compile_ultra -no_autoungroup`. A opção preserva as instâncias dos módulos. Ao final, escreve a netlist grouped, o SDC mapeado e os relatórios de síntese.

### `synth/synth_ungrouped.tcl`

Executa o mesmo fluxo, mas usa `compile_ultra` sem `-no_autoungroup`. Assim, o Design Compiler pode desagrupar módulos e otimizar através das fronteiras hierárquicas. Netlist, SDC, SVF e relatórios recebem nomes próprios da variante ungrouped.

### `fm/formality_grouped.tcl`

Habilita `synopsys_auto_setup`, carrega a biblioteca e o SVF grouped, lê o RTL no container de referência `r:` e a netlist no container de implementação `i:`. Depois seleciona os dois tops, executa `match` e `verify` e escreve relatórios de status, pontos e operações SVF.

### `fm/formality_ungrouped.tcl`

Repete a comparação com a netlist e o SVF ungrouped. As informações de transformação presentes no SVF ajudam o Formality a relacionar o RTL hierárquico à implementação que teve módulos desagrupados.

## Pré-requisitos

- Ambiente Linux com Bash.
- Synopsys Design Compiler (`dc_shell`).
- Synopsys Formality (`fm_shell`).
- Biblioteca tecnológica `saed32rvt_tt1p05v25c.db`.
- Ambiente Synopsys, licenças e variáveis configurados; os scripts usam `source /Tools/synopsys/snps.sh` no servidor em que a atividade foi executada.

As ferramentas Synopsys não devem ser executadas no Windows.

## Biblioteca tecnológica

O arquivo licenciado da biblioteca não pertence ao repositório. Antes da síntese, ele deve ser disponibilizado, por cópia local ou link simbólico, exatamente neste destino relativo à raiz da atividade:

```text
libs/saed32rvt_tt1p05v25c.db
```

O caminho de origem depende da instalação autorizada do laboratório. Não adicione o arquivo `.db` ao Git.

## Execução

Todos os comandos desta seção partem da raiz de `atividade_02_formality`. Execute-os somente no ambiente Linux configurado com as ferramentas e licenças Synopsys.

### Síntese grouped

```bash
mkdir -p synth/logs
(cd synth && dc_shell -f synth_grouped.tcl 2>&1 | tee logs/synth_grouped.log)
```

### Síntese ungrouped

```bash
mkdir -p synth/logs
(cd synth && dc_shell -f synth_ungrouped.tcl 2>&1 | tee logs/synth_ungrouped.log)
```

As duas sínteses também podem ser executadas na ordem correta pelo script:

```bash
bash scripts/run_synth_formality.sh
```

### Formality grouped

Execute somente depois de gerar a netlist e o SVF grouped na mesma rodada:

```bash
mkdir -p fm/logs fm/reports/grouped
(cd fm && fm_shell -f formality_grouped.tcl 2>&1 | tee logs/formality_grouped.log)
```

### Formality ungrouped

Execute somente depois de gerar a netlist e o SVF ungrouped na mesma rodada:

```bash
mkdir -p fm/logs fm/reports/ungrouped
(cd fm && fm_shell -f formality_ungrouped.tcl 2>&1 | tee logs/formality_ungrouped.log)
```

As duas verificações também podem ser executadas sequencialmente por:

```bash
bash scripts/run_formality.sh
```

Não misture uma netlist com o SVF de outra variante ou de outra rodada.

### Conferência dos resultados

Depois de executar as duas verificações no ambiente Synopsys, confira os logs e os relatórios finais com:

```bash
bash scripts/check_results.sh
```

O conferidor procura `Verification SUCCEEDED` nos dois logs, mostra o status de cada variante e exibe os resumos de failing e unmatched points. Se os logs necessários ainda não existirem, ele encerra com código diferente de zero e orienta a gerar os resultados no ambiente Synopsys.

## Arquivos gerados por etapa

A síntese grouped produz:

- `synth/netlist/vending_top_netlist_grouped.v`;
- `synth/netlist/vending_top_mapped_grouped.sdc`;
- `synth/reports/default_grouped.svf`;
- `synth/reports/check_design_grouped.rpt`;
- `synth/reports/area_grouped.rpt`;
- `synth/reports/timing_grouped.rpt`;
- `synth/reports/power_grouped.rpt`;
- `synth/reports/constraint_grouped.rpt`;
- `synth/logs/synth_grouped.log` quando usado o comando acima ou o script de automação.

A síntese ungrouped produz os arquivos equivalentes com o sufixo `_ungrouped`:

- `synth/netlist/vending_top_netlist_ungrouped.v`;
- `synth/netlist/vending_top_mapped_ungrouped.sdc`;
- `synth/reports/default_ungrouped.svf`;
- relatórios `check_design`, `area`, `timing`, `power` e `constraint` em `synth/reports/`;
- `synth/logs/synth_ungrouped.log` quando usado o comando acima ou o script de automação.

O Formality grouped escreve `fm/logs/formality_grouped.log` e, em `fm/reports/grouped/`, os relatórios `status_after_match.rpt`, `matched_points.rpt`, `unmatched_points.rpt`, `svf_accepted.rpt`, `svf_rejected.rpt`, `status_final.rpt`, `passing_points.rpt`, `failing_points.rpt` e `unmatched_points_final.rpt`.

O Formality ungrouped escreve o log correspondente em `fm/logs/formality_ungrouped.log` e os mesmos nomes de relatórios em `fm/reports/ungrouped/`.

Os arquivos SVF são regenerados em cada síntese e não são versionados. Para preservar a coerência da prova, cada SVF deve ser usado com a netlist produzida na mesma variante e na mesma rodada.

## Resultados obtidos no servidor

| Métrica | Grouped | Ungrouped |
| --- | ---: | ---: |
| Verificação | SUCCEEDED | SUCCEEDED |
| Compare points aprovados | 101 | 101 |
| Portas | 21 | 21 |
| Flip-flops | 80 | 80 |
| Failing points | 0 | 0 |
| Unmatched points | 0 | 0 |
| Operações SVF aceitas | 64 | 69 |
| Operações SVF rejeitadas | 0 | 0 |
| Tempo do Formality | 14 s | 14 s |

A variante ungrouped teve cinco operações SVF aceitas a mais. Elas correspondem ao `ungroup` das cinco instâncias que formam o top-level:

- `u_control_unit`;
- `u_credit_reg`;
- `u_memory`;
- `u_comparator`;
- `u_subtractor`.

O total de compare points permaneceu igual nas duas implementações: 21 portas mais 80 flip-flops resultaram em 101 pontos aprovados.

## Avisos observados

- O Formality X-2025.06-SP3 avisou que o bloco `INITIAL` de `memory.sv` não é suportado. O bloco foi mantido no RTL, e o reset síncrono também inicializa a memória.
- Foram emitidos avisos relacionados às células de alimentação da biblioteca tecnológica.
- Foi informada a ausência da operação `guide_hier_map` no guia SVF.

Esses avisos não impediram o casamento dos pontos nem a prova: ambas as execuções terminaram com `Verification SUCCEEDED`, sem failing points, unmatched points ou operações SVF rejeitadas.

## Relatório técnico

- [Relatório em PDF](docs/relatorio.pdf)
- [Código-fonte LaTeX](docs/relatorio.tex)

O código-fonte utiliza as evidências presentes nas pastas `docs/imagens` e `docs/dados`.

## Arquivos que não devem ser versionados

Não adicione ao Git dados licenciados nem artefatos temporários das ferramentas:

- arquivos `*.db`, incluindo a biblioteca em `libs/`;
- diretórios `work/`;
- diretórios `formality_svf/`;
- arquivos e diretórios temporários;
- diretórios `alib-*`;
- arquivos de backup;
- executáveis, bancos intermediários e logs gerados localmente.

Netlists, SVFs e relatórios devem representar somente execuções reais; nunca crie artefatos fictícios para preencher o fluxo.

## Conclusão

Nas configurações utilizadas no servidor, tanto a netlist grouped quanto a netlist ungrouped foram formalmente equivalentes ao RTL da vending machine. As duas verificações concluíram com `Verification SUCCEEDED` e aprovaram todos os 101 compare points, demonstrando que a preservação ou remoção das fronteiras hierárquicas não alterou o comportamento lógico verificado.
