# Restrições de temporização e de interface da vending machine.
# Clock principal na porta clk, atualmente com período de 5 ns (200 MHz).
create_clock -name clk -period 5.0 [get_ports clk]

# Margem de 0,5 ns para variações e incertezas do clock na análise temporal.
set_clock_uncertainty 0.5 [get_clocks clk]

# Atraso externo de chegada para reset, controle, moedas e seleção do produto.
set_input_delay 3.0 -clock [get_clocks clk] [get_ports {rst confirm cancel coin_in* sel_item*}]

# Tempo reservado ao circuito externo que recebe entrega, erro, troco e display.
set_output_delay 3.0 -clock [get_clocks clk] [get_ports {dispense error change_out* display* state_out*}]

# Carga capacitiva estimada nas portas de saída para o cálculo de atraso.
set_load 0.05 [get_ports {dispense error change_out* display* state_out*}]

# Capacidade de acionamento assumida para quem dirige as entradas primárias.
set_drive 0.1 [get_ports {rst confirm cancel coin_in* sel_item*}]
