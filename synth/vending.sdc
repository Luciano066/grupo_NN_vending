# Clock principal da vending.
# Para a sintese inicial de 20 ns, ajuste este periodo para 20.0;
# o valor abaixo reflete o ponto atualmente configurado no arquivo.
create_clock -name clk -period 5.0 [get_ports clk]

# Margem de incerteza usada na analise temporal do clock.
set_clock_uncertainty 0.5 [get_clocks clk]

# Atraso externo assumido para sinais de entrada.
set_input_delay 3.0 -clock [get_clocks clk] [get_ports {rst confirm cancel coin_in* sel_item*}]

# Atraso externo reservado para os sinais de saida.
set_output_delay 3.0 -clock [get_clocks clk] [get_ports {dispense error change_out* display* state_out*}]

# Carga capacitiva aplicada as saidas.
set_load 0.05 [get_ports {dispense error change_out* display* state_out*}]

# Drive equivalente usado nas entradas primarias.
set_drive 0.1 [get_ports {rst confirm cancel coin_in* sel_item*}]
