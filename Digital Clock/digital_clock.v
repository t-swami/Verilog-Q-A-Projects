

    module digital_clock(    input clk, rst,
                            output reg [5:0] sec, min,
                            output reg [4:0] hrs
                            );
                        

//for seconds
    always @(posedge clk or posedge rst) begin
        if (rst) sec <= 0;
      else if (sec == 59) sec <= 0;
        else sec <= sec+1;
    end

//for minutes
    always @(posedge clk or posedge rst) begin
        if(rst) min <= 0;
      else if (sec == 59) begin
              if(min == 59) min <= 0;
              else min <= min+1;
      end
        else min <= min;
    end
//for hours
    always @(posedge clk or posedge rst) begin
        if(rst) hrs <= 0;
      else if (sec == 59 && min == 59) begin
             if (hrs == 23) hrs <= 0;
             else hrs <= hrs+1;
      end
        else hrs<=hrs;
    end
    endmodule
