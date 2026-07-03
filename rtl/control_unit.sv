import vending_pkg::*;

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

  state_t state, next_state;

  logic check_valid;
  logic next_check_valid;

  assign state_out = state;

  always_ff @(posedge clk) begin
    if (rst) begin
      state       <= IDLE;
      check_valid <= 1'b0;
    end else begin
      state       <= next_state;
      check_valid <= next_check_valid;
    end
  end

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
        next_check_valid = 1'b0;

        if (coin_in != 2'b00) begin
          next_state = COLLECT;
        end else begin
          next_state = IDLE;
        end
      end

      COLLECT: begin
        next_check_valid = 1'b0;

        if (confirm) begin
          next_state = CHECK;
        end else begin
          next_state = COLLECT;
        end
      end

      CHECK: begin
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
        dispense        = 1'b1;
        mem_write       = 1'b1;
        next_check_valid = 1'b0;
        next_state      = CHANGE;
      end

      CHANGE: begin
        change_load     = 1'b1;
        clear_credit    = 1'b1;
        next_check_valid = 1'b0;
        next_state      = IDLE;
      end

      ERROR: begin
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

    if (cancel) begin
      next_state       = IDLE;
      next_check_valid = 1'b0;
    end
  end

endmodule
