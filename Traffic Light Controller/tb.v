`timescale 1ns / 1ps
module tb ;
reg clk,reset;
wire r1,r2,r3,r4,y1,y2,y3,y4,g1,g2,g3,g4;
wire [2:0]c;
always #15 clk = ~clk;
traffic_light_controller x(clk,reset,c,r1,r2,r3,r4,y1,y2,y3,y4,g1,g2,g3,g4);
initial
    begin
    $monitor("Time =%t, Delay = %b, ",$time,c);
     $monitor("                     r1 = %b | r2 = %b | r3 = %b | r4 = %b",r1,r2,r3,r4);
    $monitor("                      y1 = %b | y2 = %b | y3 = %b | y4 = %b",y1,y2,y3,y4);
    $monitor("                      g1 = %b | g2 = %b | g3 = %b | g4 = %b",g1,g2,g3,g4);
        clk = 0;
        reset = 1;
        #2 reset = 0;
    end
endmodule

