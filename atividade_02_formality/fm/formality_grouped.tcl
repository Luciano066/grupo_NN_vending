# Equivalência formal da implementação grouped; execute a partir de fm/.
# Os diretórios separam logs gerais e relatórios próprios desta variante.
file mkdir logs
file mkdir reports
file mkdir reports/grouped

# O modo automático ajusta o Formality para interpretar transformações comuns
# do Design Compiler. Esta configuração deve preceder obrigatoriamente set_svf.
set synopsys_auto_setup true

# Carrega a biblioteca tecnológica para resolver as células da netlist mapeada.
read_db ../libs/saed32rvt_tt1p05v25c.db

# Associa o SVF da mesma rodada grouped. Operações aceitas serão usadas como
# orientação; operações rejeitadas serão registradas para diagnóstico.
set_svf ../synth/reports/default_grouped.svf

# Lê o SystemVerilog original no container de referência r:. A opção -r é
# importante para que estes arquivos sejam tratados como o projeto de referência.
read_sverilog -r {
  ../rtl/vending_pkg.sv
  ../rtl/comparator.sv
  ../rtl/subtractor.sv
  ../rtl/credit_reg.sv
  ../rtl/memory.sv
  ../rtl/control_unit.sv
  ../rtl/vending_top.sv
}

# Seleciona o top vending_top elaborado em WORK dentro do container r:.
set_top r:/WORK/vending_top

# Lê a netlist sintetizada como implementação no container i:.
read_verilog -i ../synth/netlist/vending_top_netlist_grouped.v

# Seleciona exatamente o top correspondente dentro do container i:.
set_top i:/WORK/vending_top

# match associa compare points da referência aos da implementação. Os relatórios
# seguintes mostram pontos casados e unmatched (sem correspondência encontrada).
match

report_status \
  > reports/grouped/status_after_match.rpt

report_matched_points \
  > reports/grouped/matched_points.rpt

report_unmatched_points \
  > reports/grouped/unmatched_points.rpt

# Relaciona separadamente as operações SVF aceitas e rejeitadas pela ferramenta.
report_svf_operation -status accepted \
  > reports/grouped/svf_accepted.rpt

report_svf_operation -status rejected \
  > reports/grouped/svf_rejected.rpt

# verify prova a equivalência dos compare points casados. Passing points foram
# provados; failing points falharam ou produziram contraexemplo; unmatched points
# não puderam ser associados e são conferidos novamente no status final.
verify

report_status \
  > reports/grouped/status_final.rpt

report_passing_points \
  > reports/grouped/passing_points.rpt

report_failing_points \
  > reports/grouped/failing_points.rpt

report_unmatched_points \
  > reports/grouped/unmatched_points_final.rpt

quit
