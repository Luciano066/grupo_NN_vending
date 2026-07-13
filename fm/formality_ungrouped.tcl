# Equivalencia formal da sintese ungrouped.
# Execute este script a partir do diretorio fm/.

file mkdir logs
file mkdir reports
file mkdir reports/ungrouped

read_db ../libs/saed32rvt_tt1p05v25c.db
set_svf ../synth/reports/default_ungrouped.svf
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
read_verilog -i ../synth/netlist/vending_top_netlist_ungrouped.v

set_top r:/WORK/vending_top
set_top i:/WORK/vending_top

match

report_status > reports/ungrouped/status_after_match.rpt
report_matched_points > reports/ungrouped/matched_points.rpt
report_unmatched_points > reports/ungrouped/unmatched_points.rpt
report_svf_operation -status accepted > reports/ungrouped/svf_accepted.rpt
report_svf_operation -status rejected > reports/ungrouped/svf_rejected.rpt

verify

report_status > reports/ungrouped/status_final.rpt
report_passing_points > reports/ungrouped/passing_points.rpt
report_failing_points > reports/ungrouped/failing_points.rpt
report_unmatched_points > reports/ungrouped/unmatched_points_final.rpt

quit
