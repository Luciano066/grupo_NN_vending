/*
 * Caminho combinacional de cálculo do troco.
 * Entradas: crédito acumulado e preço lido da memória.
 * Saída: diferença de 8 bits entregue ao registrador change_out no estado CHANGE.
 */
module subtractor (
  input  logic [7:0] credit,
  input  logic [7:0] price,
  output logic [7:0] change
);

  // Calcula o troco em centavos. A FSM só carrega este resultado depois que
  // o comparador garantiu credit >= price, evitando uso de uma subtração negativa.
  assign change = credit - price;

endmodule
