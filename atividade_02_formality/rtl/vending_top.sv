import vending_pkg::*;

/*
 * Top-level que integra controle, crédito, catálogo, autorização e troco.
 * Entradas: clock/reset, moeda, seleção, confirmação e cancelamento.
 * Saídas: pulso de entrega, troco/reembolso, erro, display e estado da FSM.
 */
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

  // Estado tipado que interliga a unidade de controle ao restante do datapath.
  state_t current_state;

  // Caminho de dados: crédito, preço, estoque e troco usam 8 bits; os valores
  // monetários são representados em centavos.
  logic [7:0] credit;
  logic [7:0] price;
  logic [7:0] stock;
  logic [7:0] change;

  // Resultado combinacional da verificação de crédito e disponibilidade.
  logic can_sell;

  // Comandos gerados pela FSM para leitura/escrita, limpeza e saídas registradas.
  logic mem_read;
  logic mem_write;
  logic clear_credit;
  logic change_load;
  logic refund_credit;

  // Exporta o estado tipado como vetor de 3 bits para observação externa.
  assign state_out = current_state;

  // Unidade de controle: sequencia coleta, confirmação, compra, troco e erro.
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

  // Acumula moedas e zera o saldo após compra, reset ou cancelamento.
  credit_reg u_credit_reg (
    .clk          (clk),
    .rst          (rst),
    .cancel       (cancel),
    .state        (current_state),
    .coin_in      (coin_in),
    .clear_credit (clear_credit),
    .credit       (credit)
  );

  // Usa sel_item como endereço para ler o produto e baixar uma unidade vendida.
  memory u_memory (
    .clk       (clk),
    .rst       (rst),
    .mem_read  (mem_read),
    .mem_write (mem_write),
    .addr      (sel_item),
    .price     (price),
    .stock     (stock)
  );

  // Autoriza a venda apenas com crédito suficiente e estoque disponível.
  comparator u_comparator (
    .credit   (credit),
    .price    (price),
    .stock    (stock),
    .can_sell (can_sell)
  );

  // Calcula credit - price; o resultado só é capturado em uma compra válida.
  subtractor u_subtractor (
    .credit (credit),
    .price  (price),
    .change (change)
  );

  // Registradores de saída para troco/reembolso e display, atualizados no clock.
  // Reset limpa ambos. Cancelamento devolve o crédito e apaga o display;
  // CHANGE registra o troco; ERROR mostra e disponibiliza o crédito para reembolso.
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
