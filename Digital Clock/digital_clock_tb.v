`timescale 1ns / 1ps
module digital_clock_tb;

reg clk,rst;
wire [5:0]sec;
wire [5:0]min;
wire [4:0] hrs;

digital_clock uut(.clk(clk), .rst(rst), .sec(sec), .min(min), .hrs(hrs));
always #1 clk = ~clk;
initial begin
$monitor("Time = %t, Hours = %d, Minutes = %d, Seconds = %d", $time,hrs,min,sec);
    clk =0;
    rst =1; #5;
    rst =0; #200000;
    $stop;
end
endmodule
