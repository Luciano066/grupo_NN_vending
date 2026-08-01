# Síntese ungrouped da vending machine; execute a partir do diretório synth/.
# Esta variante permite otimizações que atravessem as fronteiras hierárquicas.

# SCRIPT_DIR aponta para o diretório do script e TOP nomeia o projeto raiz.
set SCRIPT_DIR [file dirname [file normalize [info script]]]
set TOP vending_top

# Diretórios de resultados e biblioteca de trabalho isolada da variante grouped.
file mkdir reports
file mkdir netlist
file mkdir logs
file mkdir work/ungrouped

define_design_lib WORK -path [file join $SCRIPT_DIR work ungrouped]

# Configuração da biblioteca tecnológica SAED32 usada para resolver e mapear
# as células. O arquivo .db deve estar disponível em ../libs sem ser versionado.
set_app_var search_path [list ../rtl ../libs]
set_app_var target_library [list ../libs/saed32rvt_tt1p05v25c.db]
set_app_var link_library [concat "*" $target_library]

remove_design -all

# O SVF guarda as transformações da síntese, inclusive operações de ungroup,
# para orientar a correspondência entre RTL e implementação no Formality.
set_svf reports/default_ungrouped.svf

# analyze compila os arquivos SystemVerilog na biblioteca WORK.
analyze -format sverilog -library WORK ../rtl/vending_pkg.sv
analyze -format sverilog -library WORK ../rtl/comparator.sv
analyze -format sverilog -library WORK ../rtl/subtractor.sv
analyze -format sverilog -library WORK ../rtl/credit_reg.sv
analyze -format sverilog -library WORK ../rtl/memory.sv
analyze -format sverilog -library WORK ../rtl/control_unit.sv
analyze -format sverilog -library WORK ../rtl/vending_top.sv

# elaborate instancia a hierarquia do TOP; current_design a seleciona; link
# associa referências de projeto e células à biblioteca tecnológica.
elaborate $TOP -library WORK
current_design $TOP
link

# Verifica a estrutura e lê as restrições de clock e interface do SDC.
check_design > reports/check_design_ungrouped.rpt
# read_sdc aplica ao projeto as restrições definidas em vending.sdc.
read_sdc [file join $SCRIPT_DIR vending.sdc]

# Sem -no_autoungroup, compile_ultra pode achatar hierarquias para otimizar o
# circuito. Essa é a diferença funcional do fluxo de síntese ungrouped.
compile_ultra
# Interrompe a gravação do SVF após a etapa de compilação e mapeamento.
set_svf -off

# Produz relatórios de qualidade e de atendimento às restrições.
report_area > reports/area_ungrouped.rpt
report_timing -max_paths 10 -delay_type max > reports/timing_ungrouped.rpt
report_power > reports/power_ungrouped.rpt
report_constraint -all_violators > reports/constraint_ungrouped.rpt

# Escreve a netlist mapeada e as restrições SDC propagadas desta variante.
write -format verilog -hierarchy -output netlist/vending_top_netlist_ungrouped.v
write_sdc netlist/vending_top_mapped_ungrouped.sdc

quit
