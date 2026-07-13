# Equivalencia formal da sintese grouped.
# Execute este script a partir do diretorio fm/.

file mkdir logs
file mkdir reports
file mkdir reports/grouped

read_db ../libs/saed32rvt_tt1p05v25c.db
set_svf ../synth/reports/default_grouped.svf
set synopsys_auto_setup true

read_verilog -r -sv {
  ../rtl/vending_pkg.sv
  ../rtl/comparator.sv
  ../rtl/subtractor.sv
  ../rtl/credit_reg.sv
  ../rtl/memory.sv
  ../rtl/control_unit.sv
  ../rtl/vending_top.sv
}
read_verilog -i ../synth/netlist/vending_top_netlist_grouped.v

set_top r:/WORK/vending_top
set_top i:/WORK/vending_top

match

report_status > reports/grouped/status_after_match.rpt
report_matched_points > reports/grouped/matched_points.rpt
report_unmatched_points > reports/grouped/unmatched_points.rpt
report_svf_operation -status accepted > reports/grouped/svf_accepted.rpt
report_svf_operation -status rejected > reports/grouped/svf_rejected.rpt

verify

report_status > reports/grouped/status_final.rpt
report_passing_points > reports/grouped/passing_points.rpt
report_failing_points > reports/grouped/failing_points.rpt
report_unmatched_points > reports/grouped/unmatched_points_final.rpt

quit
