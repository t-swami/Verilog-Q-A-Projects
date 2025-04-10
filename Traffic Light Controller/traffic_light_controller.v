`timescale 1ns / 1ps

module traffic_light_controller(clk,reset,c,
                                r1,r2,r3,r4,
                                y1,y2,y3,y4,
                                g1,g2,g3,g4);
input clk,reset;
output reg r1,r2,r3,r4,
            y1,y2,y3,y4,
            g1,g2,g3,g4;
output reg [2:0]c;

parameter [1:0]s0=2'd0;
parameter [1:0]s1=2'd1;
parameter [1:0]s2=2'd2;
parameter [1:0]s3=2'd3;

parameter [2:0]d7=3'd7;
parameter [2:0]d5=3'd5;
parameter [2:0]d2=3'd2;

reg [1:0]s;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        s<=s0;
        c<=0;
       end
    else
        begin
            case(s)
            s0:if(c<d7)
                begin
                    s<=s0;
                    c<=c+1'd1;
                end
                else
                    begin
                    s<=s1;
                    c<=3'b0;
                    end
            s1:if(c<d2)
                begin
                    s<=s1;
                    c<=c+1'd1;
                end
                else
                    begin
                    s<=s2;
                    c<=3'b0;
                    end
            s2:if(c<d5)
                begin
                    s<=s2;
                    c<=c+1'd1;
                end
                else
                    begin
                    s<=s3;
                    c<=3'b0;
                    end
            s3:if(c<d2)
                begin
                    s<=s3;
                    c<=c+1'd1;
                end
                else
                    begin
                    s<=s0;
                    c<=3'b0;
                    end
            default: s<=s0;
            endcase
     end            
end

always @(s)
begin
    case(s)
        s0: begin
                r1<=1'd0;
                y1<=1'd0;
                g1<=1'd1;
                r2<=1'd0;
                y2<=1'd0;
                g2<=1'd1;
                r3<=1'd1;
                y3<=1'd0;
                g3<=1'd0;
                r4<=1'd1;
                y4<=1'd0;
                g4<=1'd0;
            end
        s1: begin
                r1<=1'd0;
                y1<=1'd1;
                g1<=1'd0;
                r2<=1'd0;
                y2<=1'd1;
                g2<=1'd0;
                r3<=1'd1;
                y3<=1'd0;
                g3<=1'd0;
                r4<=1'd1;
                y4<=1'd0;
                g4<=1'd0;
            end 
        s2: begin
                r1<=1'd1;
                y1<=1'd0;
                g1<=1'd0;
                r2<=1'd1;
                y2<=1'd0;
                g2<=1'd0;
                r3<=1'd0;
                y3<=1'd0;
                g3<=1'd1;
                r4<=1'd0;
                y4<=1'd0;
                g4<=1'd1;
            end  
            s3: begin
                r1<=1'd1;
                y1<=1'd0;
                g1<=1'd0;
                r2<=1'd1;
                y2<=1'd0;
                g2<=1'd0;
                r3<=1'd0;
                y3<=1'd1;
                g3<=1'd0;
                r4<=1'd0;
                y4<=1'd1;
                g4<=1'd0;
            end         
    endcase
end
endmodule
