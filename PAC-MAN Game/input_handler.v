// input_handler.v
// FINAL CORRECTED VERSION: Includes pulse generation for clean, single-press events.

module input_handler (
    input  wire clk,
    input  wire rst,
    input  wire btnU_in,
    input  wire btnD_in,
    input  wire btnL_in,
    input  wire btnR_in,
    output wire move_up,
    output wire move_down,
    output wire move_left,
    output wire move_right
);

    // Wires to hold the continuous (debounced) button state
    wire btnU_debounced, btnD_debounced, btnL_debounced, btnR_debounced;

    // Instantiate debouncer for each button
    debounce_unit debounce_U (.clk(clk),.rst(rst),.button_in(btnU_in),.button_out(btnU_debounced) );
    debounce_unit debounce_D (.clk(clk),.rst(rst),.button_in(btnD_in),.button_out(btnD_debounced) );
    debounce_unit debounce_L (.clk(clk),.rst(rst),.button_in(btnL_in),.button_out(btnL_debounced) );
    debounce_unit debounce_R (.clk(clk),.rst(rst),.button_in(btnR_in),.button_out(btnR_debounced) );

    // Instantiate a pulse generator for each debounced signal
    pulse_generator pulse_U (.clk(clk),.rst(rst),.signal_in(btnU_debounced),.pulse_out(move_up) );
    pulse_generator pulse_D (.clk(clk),.rst(rst),.signal_in(btnD_debounced),.pulse_out(move_down) );
    pulse_generator pulse_L (.clk(clk),.rst(rst),.signal_in(btnL_debounced),.pulse_out(move_left) );
    pulse_generator pulse_R (.clk(clk),.rst(rst),.signal_in(btnR_debounced),.pulse_out(move_right) );

endmodule


// This new module detects a rising edge and generates a single-cycle pulse.
module pulse_generator (
    input wire clk,
    input wire rst,
    input wire signal_in,
    output reg pulse_out
);
    reg signal_prev = 1'b0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            signal_prev <= 1'b0;
            pulse_out   <= 1'b0;
        end else begin
            signal_prev <= signal_in;
            // Generate a pulse only on the clock cycle where the signal goes from low to high
            if (signal_in == 1'b1 && signal_prev == 1'b0) begin
                pulse_out <= 1'b1;
            end else begin
                pulse_out <= 1'b0;
            end
        end
    end
endmodule


// debounce_unit.v
// A simple, robust, counter-based debouncer.

module debounce_unit (
    input  wire clk,
    input  wire rst,
    input  wire button_in,
    output reg  button_out
);
    reg [19:0] counter = 0;
    reg last_state = 0;

    localparam MAX_COUNT = 20'd999999; // ~10ms debounce period at 100MHz

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            last_state <= 0;
            button_out <= 0;
        end else begin
            if (button_in!= last_state) begin
                last_state <= button_in;
                counter <= 0;
            end else begin
                if (counter < MAX_COUNT) begin
                    counter <= counter + 1;
                end else begin
                    button_out <= last_state;
                end
            end
        end
    end
endmodule