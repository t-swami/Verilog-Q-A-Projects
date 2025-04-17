`timescale 1ns / 1ps

module vendingMachine(
    input clk,
    input rst,
    input select_button,
    input [3:0] coin_in,
    output reg dispense,
    output reg notValidCoin,
    output reg [4:0] timer
);

parameter IDLE = 3'd0, TEA = 3'd1, COFFEE = 3'd2,
          DISPENSE_TEA = 3'd3, DISPENSE_COFFEE = 3'd4, NOT_VALID = 3'd5;

reg [2:0] pState, nState;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        pState <= IDLE;
        timer <= 0;
    end else begin
        pState <= nState;
        if (pState == DISPENSE_TEA || pState == DISPENSE_COFFEE || pState == NOT_VALID)
            timer <= timer + 1;
        else
            timer <= 0;
    end
end

// Next state logic
always @(*) begin
    nState = pState;
    case (pState)
        IDLE: begin
            if (select_button)
                nState = TEA;
            else
                nState = COFFEE;
        end
        TEA: begin
            if (coin_in == 4'd10)
                nState = DISPENSE_TEA;
            else if (coin_in != 4'd10)
                nState = NOT_VALID;
        end
        COFFEE: begin
            if (coin_in == 4'd10)
                nState = DISPENSE_COFFEE;
            else if (coin_in != 4'd10)
                nState = NOT_VALID;
        end
        DISPENSE_TEA: begin
            if (timer > 4'd15)
                nState = IDLE;
             else
                nState = DISPENSE_TEA;
        end
        DISPENSE_COFFEE: begin
            if (timer > 4'd15)
                nState = IDLE;
             else
                nState = DISPENSE_COFFEE;
        end
        NOT_VALID: begin
            nState = IDLE;
        end
    endcase
end



// Output logic
always @(*) begin
    dispense = (pState == DISPENSE_TEA || pState == DISPENSE_COFFEE);
    notValidCoin = (pState == NOT_VALID);
end

endmodule
