module tlc_using_sensor(
                        input clk, reset, x,y,
                        output reg r1,y1,g1,r2,y2,g2
                        );
parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010,
          s3 = 3'b011, s4 = 3'b100;


reg [2:0] state, next_state;

always @ (posedge clk or posedge reset) begin
if (reset)
    state <= s0;
else
    state <= next_state;
end

always @ (state or x or y) begin
 
    case (state)
        s0: next_state = s1;
        s1: if(x==1'd1 && y == 1'd0) next_state = s1;
            else if(x == 1'd0 && y ==1'd1) next_state = s3;
            else if(x == 1'd1 && y == 1'd1) next_state = s0;
            else next_state = s2;
        s2: if(x==1'd1 && y == 1'd0) next_state = s1;
            else if(x == 1'd0 && y ==1'd1) next_state = s3;
            else if(x == 1'd1 && y == 1'd1) next_state = s0;
            else next_state = s3;
        s3: if(x==1'd1 && y == 1'd0) next_state = s1;
            else if(x == 1'd0 && y ==1'd1) next_state = s3;
            else if(x == 1'd1 && y == 1'd1) next_state = s0;
            else next_state = s4;
        s4: if(x==1'd1 && y == 1'd0) next_state = s1;
            else if(x == 1'd0 && y ==1'd1) next_state = s3;
            else if(x == 1'd1 && y == 1'd1) next_state = s0;
            else next_state = s1;
        default: next_state = s0;
    endcase
end

always @ (state) begin
        case (state)
                s0: begin
                    r1 <= 1'd0;
                    y1 <= 1'd0;
                    g1 <= 1'd1;
                    r2 <= 1'd0;
                    y2 <= 1'd0;
                    g2 <= 1'd1;
                end
                s1: begin
                    r1 <= 1'd0;
                    y1 <= 1'd0;
                    g1 <= 1'd1;
                    r2 <= 1'd1;
                    y2 <= 1'd0;
                    g2 <= 1'd0;
                end
                s2: begin
                    r1 <= 1'd0;
                    y1 <= 1'd1;
                    g1 <= 1'd0;
                    r2 <= 1'd1;
                    y2 <= 1'd0;
                    g2 <= 1'd0;
                end
                s3: begin
                    r1 <= 1'd1;
                    y1 <= 1'd0;
                    g1 <= 1'd0;
                    r2 <= 1'd0;
                    y2 <= 1'd0;
                    g2 <= 1'd1;
                end
                s4: begin
                    r1 <= 1'd1;
                    y1 <= 1'd0;
                    g1 <= 1'd0;
                    r2 <= 1'd0;
                    y2 <= 1'd1;
                    g2 <= 1'd0;
                end

        endcase
end
endmodule