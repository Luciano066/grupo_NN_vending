# Script de sintese - Vending Machine
# Top-level: vending_top

set TOP vending_top
set PROJ_DIR [pwd]

file mkdir ${PROJ_DIR}/synth/reports
file mkdir ${PROJ_DIR}/synth/netlist
file mkdir ${PROJ_DIR}/synth/work

define_design_lib WORK -path ${PROJ_DIR}/synth/work

set_app_var search_path [list ${PROJ_DIR}/rtl ${PROJ_DIR}/libs]
set_app_var target_library [list ${PROJ_DIR}/libs/saed32rvt_tt1p05v25c.db]
set_app_var link_library [concat "*" $target_library]

remove_design -all

analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/vending_pkg.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/comparator.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/subtractor.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/credit_reg.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/memory.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/control_unit.sv
analyze -format sverilog -library WORK ${PROJ_DIR}/rtl/vending_top.sv

elaborate $TOP -library WORK
current_design $TOP
link

check_design > ${PROJ_DIR}/synth/reports/check_design.rpt

read_sdc ${PROJ_DIR}/synth/vending.sdc

compile_ultra

report_area > ${PROJ_DIR}/synth/reports/area.rpt
report_timing -max_paths 10 -delay_type max > ${PROJ_DIR}/synth/reports/timing.rpt
report_power > ${PROJ_DIR}/synth/reports/power.rpt
report_constraint -all_violators > ${PROJ_DIR}/synth/reports/constraint.rpt

write -format verilog -hierarchy -output ${PROJ_DIR}/synth/netlist/vending_top_netlist.v
write_sdc ${PROJ_DIR}/synth/netlist/vending_top_mapped.sdc

quit
