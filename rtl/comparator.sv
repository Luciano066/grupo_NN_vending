module comparator (
  input  logic [7:0] credit,
  input  logic [7:0] price,
  input  logic [7:0] stock,
  output logic       can_sell
);

  // Logica combinacional de decisao de venda.
  // can_sell so fica ativo quando ha credito suficiente e estoque disponivel.
  assign can_sell = (credit >= price) && (stock > 8'd0);

endmodule
