# Equivalência formal da síntese ungrouped; execute a partir do diretório fm/.
# Nesta variante, o SVF também orienta as mudanças de hierarquia por ungroup.

# Diretórios de saída gerais e específicos da execução ungrouped.
file mkdir logs
file mkdir reports
file mkdir reports/ungrouped

# Habilita ajustes automáticos compatíveis com o Design Compiler. A configuração
# deve vir antes de set_svf para que o guia seja interpretado no modo correto.
set synopsys_auto_setup true
# Disponibiliza as células tecnológicas presentes na netlist mapeada.
read_db ../libs/saed32rvt_tt1p05v25c.db
# Usa o SVF produzido junto com a netlist ungrouped, sem misturar execuções.
set_svf ../synth/reports/default_ungrouped.svf

# Carrega o RTL SystemVerilog no container de referência r:.
read_sverilog -r {
  ../rtl/vending_pkg.sv
  ../rtl/comparator.sv
  ../rtl/subtractor.sv
  ../rtl/credit_reg.sv
  ../rtl/memory.sv
  ../rtl/control_unit.sv
  ../rtl/vending_top.sv
}
# Define o único top de referência, vending_top em r:/WORK.
set_top r:/WORK/vending_top

# Carrega a netlist Verilog no container de implementação i:.
read_verilog -i ../synth/netlist/vending_top_netlist_ungrouped.v

# Define o único top de implementação, correspondente ao top de referência.
set_top i:/WORK/vending_top

# Associa os compare points dos dois containers antes de iniciar as provas.
match

# Registra o estado do match, os pontos associados/unmatched e as operações do
# SVF que foram aceitas ou rejeitadas pela versão utilizada do Formality.
report_status > reports/ungrouped/status_after_match.rpt
report_matched_points > reports/ungrouped/matched_points.rpt
report_unmatched_points > reports/ungrouped/unmatched_points.rpt
report_svf_operation -status accepted > reports/ungrouped/svf_accepted.rpt
report_svf_operation -status rejected > reports/ungrouped/svf_rejected.rpt

# Prova a equivalência lógica de todos os compare points associados.
verify

# Passing points foram provados equivalentes; failing points indicam falha ou
# contraexemplo; unmatched points não encontraram correspondência entre r: e i:.
report_status > reports/ungrouped/status_final.rpt
report_passing_points > reports/ungrouped/passing_points.rpt
report_failing_points > reports/ungrouped/failing_points.rpt
report_unmatched_points > reports/ungrouped/unmatched_points_final.rpt

quit
