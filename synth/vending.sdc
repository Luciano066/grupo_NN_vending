create_clock -name clk -period 5.0 [get_ports clk]

set_clock_uncertainty 0.5 [get_clocks clk]

set_input_delay 3.0 -clock [get_clocks clk] [get_ports {rst confirm cancel coin_in* sel_item*}]

set_output_delay 3.0 -clock [get_clocks clk] [get_ports {dispense error change_out* display* state_out*}]

set_load 0.05 [get_ports {dispense error change_out* display* state_out*}]

set_drive 0.1 [get_ports {rst confirm cancel coin_in* sel_item*}]
