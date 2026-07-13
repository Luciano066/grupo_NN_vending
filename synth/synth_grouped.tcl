# Sintese grouped da vending machine.
# Execute este script a partir do diretorio synth/.

set TOP vending_top

file mkdir reports
file mkdir netlist
file mkdir logs
file mkdir work/grouped

define_design_lib WORK -path ./work/grouped

set_app_var search_path [list ../rtl ../libs]
set_app_var target_library [list ../libs/saed32rvt_tt1p05v25c.db]
set_app_var link_library [concat "*" $target_library]

remove_design -all

set_svf reports/default_grouped.svf

analyze -format sverilog -library WORK ../rtl/vending_pkg.sv
analyze -format sverilog -library WORK ../rtl/comparator.sv
analyze -format sverilog -library WORK ../rtl/subtractor.sv
analyze -format sverilog -library WORK ../rtl/credit_reg.sv
analyze -format sverilog -library WORK ../rtl/memory.sv
analyze -format sverilog -library WORK ../rtl/control_unit.sv
analyze -format sverilog -library WORK ../rtl/vending_top.sv

elaborate $TOP -library WORK
current_design $TOP
link

check_design > reports/check_design_grouped.rpt
read_sdc vending.sdc

compile_ultra -no_autoungroup
set_svf -off

report_area > reports/area_grouped.rpt
report_timing -max_paths 10 -delay_type max > reports/timing_grouped.rpt
report_power > reports/power_grouped.rpt
report_constraint -all_violators > reports/constraint_grouped.rpt

write -format verilog -hierarchy -output netlist/vending_top_netlist_grouped.v
write_sdc netlist/vending_top_mapped_grouped.sdc

quit
