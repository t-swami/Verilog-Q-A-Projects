`timescale 1ns / 1ps
module Q1_tb;
reg a,clk,rst;
wire q,out;

always  #5 clk = ~clk;
integer i;
              
Q1 dut(.a(a), .clk(clk),.rst(rst),.q(q),.out(out));
initial begin 
$monitor ("$time = %t,clk = %b , a = %b, q = %b, out = %b",$time,a,clk,q,out);
clk = 1'b0;
a =0;
rst = 1'd1; #3 rst = 1'd0;  
              for(i=0;i<6'd30;i=i+1)
              begin
                a = ~a;#6;
              end            
#20 $finish;
end
endmodule
