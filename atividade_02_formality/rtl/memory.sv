/*
 * Memória de produtos endereçada por sel_item através da entrada addr.
 * mem_read captura preço/estoque nas saídas; mem_write registra uma venda e
 * decrementa o estoque. clk e rst controlam as operações síncronas.
 */
module memory (
  input  logic       clk,
  input  logic       rst,
  input  logic       mem_read,
  input  logic       mem_write,
  input  logic [1:0] addr,
  output logic [7:0] price,
  output logic [7:0] stock
);

  // Quatro palavras armazenam os dados dos produtos.
  // Em cada palavra, os bits [15:8] representam o preço em centavos e os
  // bits [7:0] representam a quantidade disponível.
  logic [15:0] mem [0:3];

  /*
   * Inicialização dos preços e estoques usada pelo modelo RTL na simulação.
   * A versão do Formality utilizada mostrou aviso de que INITIAL não é
   * suportado. O bloco é preservado; o reset síncrono também repõe esses dados.
   */
  initial begin
    mem[0] = {8'd25,  8'd5};  // Café  - R$0,25 - estoque 5
    mem[1] = {8'd50,  8'd5};  // Água  - R$0,50 - estoque 5
    mem[2] = {8'd75,  8'd3};  // Suco  - R$0,75 - estoque 3
    mem[3] = {8'd100, 8'd2};  // Snack - R$1,00 - estoque 2
  end

  // Leitura e escrita síncronas na borda de subida do clock.
  // O reset restaura o catálogo e limpa as saídas price e stock.
  always @(posedge clk) begin
    if (rst) begin
      mem[0] <= {8'd25,  8'd5};
      mem[1] <= {8'd50,  8'd5};
      mem[2] <= {8'd75,  8'd3};
      mem[3] <= {8'd100, 8'd2};

      price <= 8'd0;
      stock <= 8'd0;
    end else begin

      if (mem_write && mem[addr][7:0] > 8'd0) begin
        // Uma venda mantém o preço e decrementa somente um item do estoque;
        // a condição evita que a quantidade passe abaixo de zero.
        mem[addr] <= {mem[addr][15:8], mem[addr][7:0] - 8'd1};
      end

      if (mem_read) begin
        // A leitura registra nas saídas o preço e o estoque do endereço selecionado.
        price <= mem[addr][15:8];
        stock <= mem[addr][7:0];
      end

    end
  end

endmodule
