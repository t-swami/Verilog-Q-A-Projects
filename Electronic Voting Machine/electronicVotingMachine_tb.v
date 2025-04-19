`timescale 1ns / 1ps
module electronicVotingMachine_tb;

    reg clk, rst, c1, c2, c3, endVoting;
    wire [1:0] winner;
    wire [7:0] count_c1, count_c2, count_c3;
    wire c1_tie_c2, c2_tie_c3, c1_tie_c3;

    electronicVotingMachine uut (
                                .clk(clk), .rst(rst),
                                .c1(c1), .c2(c2), .c3(c3),
                                .endVoting(endVoting),
                                .winner(winner),
                                .count_c1(count_c1),   
                                .count_c2(count_c2),   
                                .count_c3(count_c3),
                                .c1_tie_c2(c1_tie_c2),
                                .c2_tie_c3(c2_tie_c3),
                                .c1_tie_c3(c1_tie_c3)
                                );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
                
        $monitor("Time: %0t Counts => C1: %d, C2: %d, C3: %d | Winner: %d | ",$time, count_c1, count_c2, count_c3, winner);
        $monitor ("Ties => C1-C2: %b, C1-C3: %b, C2-C3: %b", c1_tie_c2, c1_tie_c3, c2_tie_c3);
        clk = 0;
        rst = 1;
        c1 = 0; c2 = 0; c3 = 0;
        endVoting = 0;
        #10 rst = 0;

        vote(1, 0, 0); // C1 =1
        vote(0, 1, 0); // C2 =1
        vote(0, 0, 1); // C3 =1
        vote(0, 0, 1); // C3 =2
        vote(1, 0, 0); // C1 =2
        vote(1, 0, 0); // C1 =3
        vote(0, 0, 1); // C3 =3
        vote(1, 0, 0); // C1 =4

        // End voting
        #10 endVoting = 1;

        #20 $stop;

        
    end


    task vote(input v1, input v2, input v3);
    begin
        @(posedge clk);
        c1 = v1; c2 = v2; c3 = v3;
        @(posedge clk);
        c1 = 0; c2 = 0; c3 = 0;
    end
    endtask


endmodule
