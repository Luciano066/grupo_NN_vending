/*
 * Tipos compartilhados pelo controlador da máquina de vendas.
 * O pacote evita que a codificação dos estados seja repetida nos módulos.
 */
package vending_pkg;

  // Estados da FSM, representados externamente por state_out[2:0].
  typedef enum logic [2:0] {
    IDLE     = 3'b000, // Aguarda a insercao de moeda.
    COLLECT  = 3'b001, // Acumula credito enquanto o usuario insere moedas.
    CHECK    = 3'b010, // Le preco/estoque e verifica se a venda e possivel.
    DISPENSE = 3'b011, // Libera o produto e solicita decremento de estoque.
    CHANGE   = 3'b100, // Calcula/devolve troco e limpa o credito.
    ERROR    = 3'b101  // Indica falha de venda ate o usuario cancelar.
  } state_t;

endpackage
