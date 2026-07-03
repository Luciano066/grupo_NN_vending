import vending_pkg::*;

module credit_reg (
  input  logic   clk,
  input  logic   rst,
  input  logic   cancel,
  input  state_t state,
  input  logic [1:0] coin_in,
  input  logic   clear_credit,
  output logic [7:0] credit
);

  function automatic logic [7:0] coin_to_value(input logic [1:0] coin);
    case (coin)
      2'b00: coin_to_value = 8'd0;
      2'b01: coin_to_value = 8'd25;
      2'b10: coin_to_value = 8'd50;
      2'b11: coin_to_value = 8'd100;
      default: coin_to_value = 8'd0;
    endcase
  endfunction

  always_ff @(posedge clk) begin
    if (rst) begin
      credit <= 8'd0;
    end else if (cancel) begin
      credit <= 8'd0;
    end else if (clear_credit) begin
      credit <= 8'd0;
    end else if ((state == IDLE || state == COLLECT) && coin_in != 2'b00) begin
      credit <= credit + coin_to_value(coin_in);
    end
  end

endmodule
