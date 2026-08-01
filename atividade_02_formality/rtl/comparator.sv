/*
 * Comparador combinacional da condição de venda.
 * Entradas: crédito acumulado, preço e estoque do produto selecionado.
 * Saída: can_sell autoriza a transição da verificação para a entrega.
 */
module comparator (
  input  logic [7:0] credit,
  input  logic [7:0] price,
  input  logic [7:0] stock,
  output logic       can_sell
);

  // A venda somente é possível quando o crédito cobre o preço e há ao menos
  // uma unidade em estoque. Caso contrário, a unidade de controle sinaliza erro.
  assign can_sell = (credit >= price) && (stock > 8'd0);

endmodule
