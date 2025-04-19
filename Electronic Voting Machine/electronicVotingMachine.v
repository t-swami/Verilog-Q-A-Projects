`timescale 1ns / 1ps
module electronicVotingMachine(
    input clk,
    input rst,
    input c1, c2, c3,
    input endVoting,
    output reg [1:0] winner, 
    output reg [7:0] count_c1, count_c2, count_c3,
    output reg c1_tie_c2, c2_tie_c3, c1_tie_c3
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count_c1 <= 0;
        count_c2 <= 0;
        count_c3 <= 0;
        c1_tie_c2 <= 0;
        c2_tie_c3 <= 0;
        c1_tie_c3 <= 0;
        winner <= 2'd0;
    end
    else if (!endVoting) begin
        if (c1) count_c1 <= count_c1 + 1;
        else if (c2) count_c2 <= count_c2 + 1;
        else if (c3) count_c3 <= count_c3 + 1;
    end
    else begin
        // Reset tie flags
        c1_tie_c2 <= 0;
        c2_tie_c3 <= 0;
        c1_tie_c3 <= 0;

        if (count_c1 == count_c2 && count_c1 > count_c3)
            c1_tie_c2 <= 1;
        else if (count_c1 == count_c3 && count_c1 > count_c2)
            c1_tie_c3 <= 1;
        else if (count_c2 == count_c3 && count_c2 > count_c1)
            c2_tie_c3 <= 1;
        else begin

            if (count_c1 > count_c2 && count_c1 > count_c3)
                winner <= 2'd1;
            else if (count_c2 > count_c1 && count_c2 > count_c3)
                winner <= 2'd2;
            else if (count_c3 > count_c1 && count_c3 > count_c2)
                winner <= 2'd3;
            else
                winner <= 2'd0;  
        end
    end
end

endmodule
