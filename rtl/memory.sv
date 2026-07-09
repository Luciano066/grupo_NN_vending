module memory (
  input  logic       clk,
  input  logic       rst,
  input  logic       mem_read,
  input  logic       mem_write,
  input  logic [1:0] addr,
  output logic [7:0] price,
  output logic [7:0] stock
);

  // Memoria de quatro produtos.
  // Organizacao de cada palavra: bits [15:8] = preco, bits [7:0] = estoque.
  logic [15:0] mem [0:3];

  // Inicializacao para simulacao: preco em centavos e estoque inicial.
  initial begin
    mem[0] = {8'd25,  8'd5};  // Café  - R$0,25 - estoque 5
    mem[1] = {8'd50,  8'd5};  // Água  - R$0,50 - estoque 5
    mem[2] = {8'd75,  8'd3};  // Suco  - R$0,75 - estoque 3
    mem[3] = {8'd100, 8'd2};  // Snack - R$1,00 - estoque 2
  end

  // Leitura e escrita sincronas.
  // No reset, restaura os produtos. Em venda, decrementa o estoque selecionado.
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
        // Escrita sincrona: mantem o preco e decrementa apenas o estoque.
        mem[addr] <= {mem[addr][15:8], mem[addr][7:0] - 8'd1};
      end

      if (mem_read) begin
        // Leitura sincrona do preco e estoque do item selecionado.
        price <= mem[addr][15:8];
        stock <= mem[addr][7:0];
      end

    end
  end

endmodule
