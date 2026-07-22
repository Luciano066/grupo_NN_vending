import vending_pkg::*;

/*
 * FSM de Moore que coordena a operação da máquina.
 * Entradas: clock/reset, cancelamento, moeda, confirmação e condição can_sell.
 * Saídas: comandos de memória, entrega, erro, crédito/troco e estado observado.
 */
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

  // state guarda o estado vigente; next_state é sua decisão combinacional.
  state_t state, next_state;

  // check_valid cria um ciclo extra em CHECK para aguardar a leitura síncrona
  // da memória antes de usar can_sell; next_check_valid calcula seu próximo valor.
  logic check_valid;
  logic next_check_valid;

  // Expõe o estado atual para o top-level e para observação na verificação.
  assign state_out = state;

  // Reset síncrono: retorna a IDLE e invalida qualquer leitura pendente.
  // Fora do reset, ambos os registradores avançam na borda de subida do clock.
  always_ff @(posedge clk) begin
    if (rst) begin
      state       <= IDLE;
      check_valid <= 1'b0;
    end else begin
      state       <= next_state;
      check_valid <= next_check_valid;
    end
  end

  // Lógica combinacional de próximo estado e saídas de Moore. Os valores
  // padrão desativam comandos, evitando retenções ou inferência de latches.
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
        // Aguarda a primeira moeda para iniciar a coleta de crédito.
        next_check_valid = 1'b0;

        if (coin_in != 2'b00) begin
          next_state = COLLECT;
        end else begin
          next_state = IDLE;
        end
      end

      COLLECT: begin
        // Continua recebendo moedas até o usuário confirmar a seleção.
        next_check_valid = 1'b0;

        if (confirm) begin
          next_state = CHECK;
        end else begin
          next_state = COLLECT;
        end
      end

      CHECK: begin
        // Solicita preço/estoque. No primeiro ciclo espera a saída registrada
        // da memória; no segundo, decide entre DISPENSE e ERROR por can_sell.
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
        // Ativa dispense por um ciclo e solicita o decremento do estoque.
        dispense        = 1'b1;
        mem_write       = 1'b1;
        next_check_valid = 1'b0;
        next_state      = CHANGE;
      end

      CHANGE: begin
        // Carrega o troco calculado, limpa o crédito e conclui a compra.
        change_load     = 1'b1;
        clear_credit    = 1'b1;
        next_check_valid = 1'b0;
        next_state      = IDLE;
      end

      ERROR: begin
        // Crédito insuficiente ou estoque zerado mantêm error ativo. O crédito
        // é apresentado para devolução até o cancelamento levar a FSM a IDLE.
        error           = 1'b1;
        refund_credit   = 1'b1;
        next_check_valid = 1'b0;
        next_state      = ERROR;
      end

      default: begin
        // Recuperação defensiva de uma codificação de estado inválida.
        next_state       = IDLE;
        next_check_valid = 1'b0;
      end

    endcase

    // O cancelamento sobrepõe a transição calculada, volta a IDLE e invalida CHECK.
    if (cancel) begin
      next_state       = IDLE;
      next_check_valid = 1'b0;
    end
  end

endmodule
