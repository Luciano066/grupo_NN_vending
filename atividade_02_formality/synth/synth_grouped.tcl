# Síntese grouped da vending machine; execute a partir do diretório synth/.
# Esta variante preserva a hierarquia dos módulos durante compile_ultra.

# SCRIPT_DIR obtém o diretório deste próprio arquivo, independentemente do
# caminho usado para invocá-lo. TOP identifica o projeto raiz a sintetizar.
set SCRIPT_DIR [file dirname [file normalize [info script]]]
set TOP vending_top

# Diretórios de resultados e biblioteca de trabalho desta variante.
file mkdir reports
file mkdir netlist
file mkdir logs
file mkdir work/grouped

define_design_lib WORK -path [file join $SCRIPT_DIR work grouped]

# A biblioteca tecnológica SAED32 fornece células, modelos temporais e de área.
# search_path localiza RTL/bibliotecas; target_library é usada no mapeamento e
# link_library permite resolver tanto os projetos carregados quanto suas células.
set_app_var search_path [list ../rtl ../libs]
set_app_var target_library [list ../libs/saed32rvt_tt1p05v25c.db]
set_app_var link_library [concat "*" $target_library]

remove_design -all

# O SVF registra as transformações da síntese que orientarão o Formality.
set_svf reports/default_grouped.svf

# analyze lê e compila cada fonte SystemVerilog na ordem de dependências.
analyze -format sverilog -library WORK ../rtl/vending_pkg.sv
analyze -format sverilog -library WORK ../rtl/comparator.sv
analyze -format sverilog -library WORK ../rtl/subtractor.sv
analyze -format sverilog -library WORK ../rtl/credit_reg.sv
analyze -format sverilog -library WORK ../rtl/memory.sv
analyze -format sverilog -library WORK ../rtl/control_unit.sv
analyze -format sverilog -library WORK ../rtl/vending_top.sv

# elaborate constrói a hierarquia do TOP; current_design seleciona o projeto;
# link resolve todas as referências aos módulos e às células tecnológicas.
elaborate $TOP -library WORK
current_design $TOP
link

# Validação estrutural anterior à compilação e aplicação das restrições SDC.
check_design > reports/check_design_grouped.rpt
# read_sdc aplica clock, atrasos, cargas e demais restrições de temporização.
read_sdc [file join $SCRIPT_DIR vending.sdc]

# -no_autoungroup impede o desagrupamento automático e mantém a hierarquia
# grouped. As otimizações e o mapeamento lógico continuam ativos.
compile_ultra -no_autoungroup
# Encerra a gravação do SVF depois das transformações que devem ser guiadas.
set_svf -off

# Relatórios de área, temporização, potência e violações das restrições.
report_area > reports/area_grouped.rpt
report_timing -max_paths 10 -delay_type max > reports/timing_grouped.rpt
report_power > reports/power_grouped.rpt
report_constraint -all_violators > reports/constraint_grouped.rpt

# Gera a netlist Verilog mapeada e o SDC correspondente para uso posterior.
write -format verilog -hierarchy -output netlist/vending_top_netlist_grouped.v
write_sdc netlist/vending_top_mapped_grouped.sdc

quit
