
import vending_pkg::*;

module tb_vending;

  logic clk;
  logic rst;
  logic [1:0] coin_in;
  logic [1:0] sel_item;
  logic confirm;
  logic cancel;

  logic dispense;
  logic [7:0] change_out;
  logic error;
  logic [7:0] display;
  logic [2:0] state_out;

  int pass_count;
  int fail_count;

  bit found;

  logic [1:0] coin_100 [0:0];
  logic [1:0] coin_25  [0:0];

  vending_top dut (
    .clk        (clk),
    .rst        (rst),
    .coin_in    (coin_in),
    .sel_item   (sel_item),
    .confirm    (confirm),
    .cancel     (cancel),
    .dispense   (dispense),
    .change_out (change_out),
    .error      (error),
    .display    (display),
    .state_out  (state_out)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("sim/vending.vcd");
    $dumpvars(0, tb_vending);
  end

  initial begin
    #5000;
    $error("TIMEOUT: a simulação demorou demais.");
    $finish;
  end

  task automatic check_eq(
    input logic [31:0] expected,
    input logic [31:0] actual,
    input string label
  );
    begin
      if (actual === expected) begin
        $display("PASS: %s", label);
        pass_count++;
      end else begin
        $display("FAIL: %s | esperado=%0d obtido=%0d", label, expected, actual);
        fail_count++;
      end
    end
  endtask

  task automatic reset_dut();
    begin
      @(negedge clk);
      rst      = 1'b1;
      coin_in  = 2'b00;
      sel_item = 2'b00;
      confirm  = 1'b0;
      cancel   = 1'b0;

      repeat (2) @(posedge clk);

      @(negedge clk);
      rst = 1'b0;

      @(posedge clk);
      #1;
    end
  endtask

  task automatic apply_coin(input logic [1:0] value);
    begin
      @(negedge clk);
      coin_in = value;

      @(negedge clk);
      coin_in = 2'b00;
    end
  endtask

  task automatic pulse_confirm(input logic [1:0] item);
    begin
      @(negedge clk);
      sel_item = item;
      confirm  = 1'b1;

      @(negedge clk);
      confirm = 1'b0;
    end
  endtask

  task automatic pulse_cancel();
    begin
      @(negedge clk);
      cancel = 1'b1;

      @(negedge clk);
      cancel = 1'b0;

      @(posedge clk);
      #1;
    end
  endtask

  task automatic buy_item(
    input logic [1:0] item,
    input logic [1:0] coins []
  );
    begin
      @(negedge clk);
      sel_item = item;

      foreach (coins[i]) begin
        apply_coin(coins[i]);
      end

      pulse_confirm(item);
    end
  endtask

  task automatic wait_for_state(
    input logic [2:0] expected_state,
    input int max_cycles,
    output bit ok
  );
    begin
      ok = 1'b0;

      for (int i = 0; i < max_cycles; i++) begin
        @(posedge clk);
        #1;

        if (state_out === expected_state) begin
          ok = 1'b1;
          return;
        end
      end
    end
  endtask

  task automatic wait_for_dispense(
    input int max_cycles,
    output bit ok
  );
    begin
      ok = 1'b0;

      for (int i = 0; i < max_cycles; i++) begin
        @(posedge clk);
        #1;

        if (dispense === 1'b1) begin
          ok = 1'b1;
          return;
        end
      end
    end
  endtask

  initial begin
    clk        = 1'b0;
    rst        = 1'b0;
    coin_in    = 2'b00;
    sel_item   = 2'b00;
    confirm    = 1'b0;
    cancel     = 1'b0;
    pass_count = 0;
    fail_count = 0;

    coin_100[0] = 2'b11;
    coin_25[0]  = 2'b01;

    $display("======================================");
    $display("INICIO DA SIMULACAO DA VENDING MACHINE");
    $display("======================================");

    // CENARIO 1: compra bem-sucedida com troco
    $display("\nCENARIO 1: compra cafe com R$1,00");

    reset_dut();

    buy_item(2'd0, coin_100);

    wait_for_dispense(10, found);
    check_eq(1, found, "C1: dispense ativado");

    wait_for_state(IDLE, 10, found);
    check_eq(1, found, "C1: FSM voltou para IDLE");

    check_eq(8'd75, change_out, "C1: troco deve ser 75 centavos");
    check_eq(8'd0, dut.u_credit_reg.credit, "C1: credito zerado ao final");

    // CENARIO 2: credito insuficiente
    $display("\nCENARIO 2: credito insuficiente para snack");

    reset_dut();

    buy_item(2'd3, coin_25);

    wait_for_state(ERROR, 10, found);
    check_eq(1, found, "C2: FSM foi para ERROR");
    check_eq(1, error, "C2: sinal error ativo");

    pulse_cancel();

    // CENARIO 3: cancelamento
    $display("\nCENARIO 3: cancelamento apos inserir R$2,00");

    reset_dut();

    apply_coin(2'b11);
    apply_coin(2'b11);

    check_eq(8'd200, dut.u_credit_reg.credit, "C3: credito acumulado igual a 200");

    pulse_cancel();

    check_eq(IDLE, state_out, "C3: FSM voltou para IDLE");
    check_eq(8'd0, dut.u_credit_reg.credit, "C3: credito zerado apos cancelamento");
    check_eq(8'd200, change_out, "C3: troco devolvido igual a 200");

    // CENARIO 4: estoque zerado
    $display("\nCENARIO 4: comprar cafe 5 vezes e tentar a sexta");

    reset_dut();

    for (int i = 0; i < 5; i++) begin
      buy_item(2'd0, coin_25);

      wait_for_dispense(10, found);
      check_eq(1, found, $sformatf("C4: compra %0d de cafe liberou produto", i + 1));

      wait_for_state(IDLE, 10, found);
      check_eq(1, found, $sformatf("C4: compra %0d voltou para IDLE", i + 1));
    end

    check_eq(8'd0, dut.u_memory.mem[0][7:0], "C4: estoque do cafe zerado");

    buy_item(2'd0, coin_25);

    wait_for_state(ERROR, 10, found);
    check_eq(1, found, "C4: sexta compra foi para ERROR");
    check_eq(1, error, "C4: error ativo na sexta compra");

    $display("\n======================================");
    $display("RESULTADO FINAL");
    $display("PASS = %0d", pass_count);
    $display("FAIL = %0d", fail_count);
    $display("======================================");

    if (fail_count == 0) begin
      $display("TODOS OS TESTES PASSARAM.");
    end else begin
      $display("ALGUNS TESTES FALHARAM.");
    end

    $finish;
  end

endmodule
