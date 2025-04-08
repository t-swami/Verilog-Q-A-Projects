`timescale 1ns / 1ps
/*
    Question by: Akshay Joshi-Linkedin 
Question:
    Given an input stream of 0s and 1s, detect the first 
    occurrence of 1. Once the first 1 is detected, output should be 1 
    continuously for the rest of the stream.
*/


module Q1( input a,clk,rst,
            output q,out
            );
wire w1;
or o(w1,a,q);
dff top(.d(w1),.clk(clk),.rst(rst),.q(q));
assign out = q;
endmodule

module dff (
    input wire d, clk, rst,
    output reg q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 1'b0; 
            end
        else
        begin
            q <= d;
        end
   end
endmodule