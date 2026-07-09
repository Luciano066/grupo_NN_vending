import vending_pkg::*;

// Modulo top-level que conecta FSM, credito, memoria, comparador e troco.
module vending_top (
  input  logic       clk,
  input  logic       rst,
  input  logic [1:0] coin_in,
  input  logic [1:0] sel_item,
  input  logic       confirm,
  input  logic       cancel,

  output logic       dispense,
  output logic [7:0] change_out,
  output logic       error,
  output logic [7:0] display,
  output logic [2:0] state_out
);

  state_t current_state;

  // Sinais de dados internos em centavos.
  logic [7:0] credit;
  logic [7:0] price;
  logic [7:0] stock;
  logic [7:0] change;

  // Resultado combinacional da verificacao de credito e estoque.
  logic can_sell;

  // Sinais de controle gerados pela FSM para os demais blocos.
  logic mem_read;
  logic mem_write;
  logic clear_credit;
  logic change_load;
  logic refund_credit;

  // Exporta o estado atual como vetor para facilitar observacao externa.
  assign state_out = current_state;

  // Unidade de controle: sequencia a FSM e gera sinais de controle.
  control_unit u_control_unit (
    .clk           (clk),
    .rst           (rst),
    .cancel        (cancel),
    .coin_in       (coin_in),
    .confirm       (confirm),
    .can_sell      (can_sell),
    .mem_read      (mem_read),
    .mem_write     (mem_write),
    .dispense      (dispense),
    .error         (error),
    .clear_credit  (clear_credit),
    .change_load   (change_load),
    .refund_credit (refund_credit),
    .state_out     (current_state)
  );

  // Registrador de credito: acumula moedas e limpa credito quando necessario.
  credit_reg u_credit_reg (
    .clk          (clk),
    .rst          (rst),
    .cancel       (cancel),
    .state        (current_state),
    .coin_in      (coin_in),
    .clear_credit (clear_credit),
    .credit       (credit)
  );

  // Memoria de produtos: fornece preco/estoque e decrementa estoque vendido.
  memory u_memory (
    .clk       (clk),
    .rst       (rst),
    .mem_read  (mem_read),
    .mem_write (mem_write),
    .addr      (sel_item),
    .price     (price),
    .stock     (stock)
  );

  // Comparador de venda: valida credito suficiente e estoque disponivel.
  comparator u_comparator (
    .credit   (credit),
    .price    (price),
    .stock    (stock),
    .can_sell (can_sell)
  );

  // Subtrator de troco: calcula credit - price para compras validas.
  subtractor u_subtractor (
    .credit (credit),
    .price  (price),
    .change (change)
  );

  // Registradores de saida para troco e display.
  // No cancelamento ou erro, display/troco refletem o credito a devolver.
  always_ff @(posedge clk) begin
    if (rst) begin
      change_out <= 8'd0;
      display    <= 8'd0;
    end else if (cancel) begin
      change_out <= credit;
      display    <= 8'd0;
    end else if (change_load) begin
      change_out <= change;
      display    <= 8'd0;
    end else if (refund_credit) begin
      change_out <= credit;
      display    <= credit;
    end else begin
      display <= credit;
    end
  end

endmodule
