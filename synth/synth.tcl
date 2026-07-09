# Script de sintese - Vending Machine
# Top-level: vending_top

# Define o modulo top-level e usa o diretorio atual como raiz do projeto.
set TOP vending_top
set PROJ_DIR [pwd]

# Cria pastas de trabalho, relatorios e netlist de saida.
file mkdir ${PROJ_DIR}/synth/reports
file mkdir ${PROJ_DIR}/synth/netlist
file mkdir ${PROJ_DIR}/synth/work

# Configura a biblioteca de trabalho do Design Compiler.
define_design_lib WORK -path ${PROJ_DIR}/synth/work

# Configura caminhos e biblioteca tecnologica SAED32 local.
set_app_var search_path [list ${PROJ_DIR}/rtl ${PROJ_DIR}/libs]
set_app_var target_library [list ${PROJ_DIR}/libs/saed32rvt_tt1p05v25c.db]
set_app_var link_library [concat "*" $target_library]

# Limpa projetos anteriores carregados na sessao.
remove_design -all

# Analise dos arquivos RTL em ordem de dependencia.
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/vending_pkg.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/comparator.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/subtractor.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/credit_reg.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/memory.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/control_unit.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/vending_top.sv

# Elaboracao do top, selecao do design corrente e ligacao com a biblioteca.
elaborate $TOP -library WORK
current_design $TOP
link

# Verificacao estrutural antes da sintese.
check_design > ${PROJ_DIR}/synth/reports/check_design.rpt

# Leitura das restricoes de clock, delays e cargas.
read_sdc ${PROJ_DIR}/synth/vending.sdc

# Sintese otimizada mantendo a hierarquia dos modulos RTL.
compile_ultra -no_autoungroup

# Geracao dos relatorios principais.
report_area > ${PROJ_DIR}/synth/reports/area.rpt
report_timing -max_paths 10 -delay_type max > ${PROJ_DIR}/synth/reports/timing.rpt
report_power > ${PROJ_DIR}/synth/reports/power.rpt
report_constraint -all_violators > ${PROJ_DIR}/synth/reports/constraint.rpt

# Exportacao da netlist mapeada e do SDC resultante.
write -format verilog -hierarchy -output ${PROJ_DIR}/synth/netlist/vending_top_netlist.v
write_sdc ${PROJ_DIR}/synth/netlist/vending_top_mapped.sdc

quit
