`timescale 1ns / 1ps
module tb_tlc;
reg clk,rst,x,y;
wire r1,y1,g1,r2,y2,g2;

tlc_using_sensor dut(.clk(clk),.reset(rst),.x(x),.y(y),.r1(r1),.y1(y1),.g1(g1),.r2(r2),.y2(y2),.g2(g2));
initial clk =0;
always #5 clk = ~clk;
initial begin
$monitor("rst = %b, x = %b, y = %b",rst,x,y);
$monitor("              r1 = %b, y1 = %b, g1 = %b",r1,y1,g1);
$monitor("              r2 = %b, y2 = %b, g2 = %b",r2,y2,g2);

rst = 1; x =0;y =1;#15 
rst = 0 ;x = 0; y = 0; #70
x = 1; y = 0;#10 // for g1,r2
x = 0; y = 1;#10 //for r1,g2
x = 1; y = 1;#10 // for g1,g2
x =0 ; y = 0; #10 
$finish;
end
endmodule
