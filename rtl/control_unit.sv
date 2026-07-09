import vending_pkg::*;

// FSM de Moore responsavel por sequenciar coleta, verificacao, venda e erro.
module control_unit (
  input  logic       clk,
  input  logic       rst,
  input  logic       cancel,
  input  logic [1:0] coin_in,
  input  logic       confirm,
  input  logic       can_sell,

  output logic       mem_read,
  output logic       mem_write,
  output logic       dispense,
  output logic       error,
  output logic       clear_credit,
  output logic       change_load,
  output logic       refund_credit,
  output state_t     state_out
);

  // Registradores de estado atual e proximo estado da FSM.
  state_t state, next_state;

  // check_valid cria um ciclo extra em CHECK para aguardar a leitura sincrona
  // da memoria antes de usar can_sell.
  logic check_valid;
  logic next_check_valid;

  // Exposicao do estado atual para o top-level/testbench.
  assign state_out = state;

  // Registradores sincronizados da FSM e do controle de leitura valida.
  always_ff @(posedge clk) begin
    if (rst) begin
      state       <= IDLE;
      check_valid <= 1'b0;
    end else begin
      state       <= next_state;
      check_valid <= next_check_valid;
    end
  end

  // Logica combinacional de proximo estado e saidas de Moore.
  always_comb begin
    next_state       = state;
    next_check_valid = check_valid;

    mem_read      = 1'b0;
    mem_write     = 1'b0;
    dispense      = 1'b0;
    error         = 1'b0;
    clear_credit  = 1'b0;
    change_load   = 1'b0;
    refund_credit = 1'b0;

    case (state)

      IDLE: begin
        // Espera a primeira moeda para iniciar a coleta de credito.
        next_check_valid = 1'b0;

        if (coin_in != 2'b00) begin
          next_state = COLLECT;
        end else begin
          next_state = IDLE;
        end
      end

      COLLECT: begin
        // Mantem a coleta ate o usuario confirmar a compra.
        next_check_valid = 1'b0;

        if (confirm) begin
          next_state = CHECK;
        end else begin
          next_state = COLLECT;
        end
      end

      CHECK: begin
        // Solicita leitura de preco/estoque e, no ciclo seguinte, avalia venda.
        mem_read = 1'b1;

        if (!check_valid) begin
          next_state       = CHECK;
          next_check_valid = 1'b1;
        end else begin
          next_check_valid = 1'b0;

          if (can_sell) begin
            next_state = DISPENSE;
          end else begin
            next_state = ERROR;
          end
        end
      end

      DISPENSE: begin
        // Libera o produto e decrementa o estoque do item selecionado.
        dispense        = 1'b1;
        mem_write       = 1'b1;
        next_check_valid = 1'b0;
        next_state      = CHANGE;
      end

      CHANGE: begin
        // Registra o troco calculado e zera o credito acumulado.
        change_load     = 1'b1;
        clear_credit    = 1'b1;
        next_check_valid = 1'b0;
        next_state      = IDLE;
      end

      ERROR: begin
        // Indica erro e mostra o credito para reembolso ate haver cancelamento.
        error           = 1'b1;
        refund_credit   = 1'b1;
        next_check_valid = 1'b0;
        next_state      = ERROR;
      end

      default: begin
        next_state       = IDLE;
        next_check_valid = 1'b0;
      end

    endcase

    // Cancelamento tem prioridade sobre a decisao do estado atual e volta a IDLE.
    if (cancel) begin
      next_state       = IDLE;
      next_check_valid = 1'b0;
    end
  end

endmodule
