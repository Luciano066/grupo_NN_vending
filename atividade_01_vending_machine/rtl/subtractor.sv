module subtractor (
  input  logic [7:0] credit,
  input  logic [7:0] price,
  output logic [7:0] change
);

  // Calcula o troco em centavos.
  // A FSM usa este resultado apos o comparador garantir credit >= price.
  assign change = credit - price;

endmodule
