`timescale 1ns / 1ps

module vendingMachine_tb;

reg clk, rst, select_button;
reg [3:0] coin_in;
wire dispense, notValidCoin;
wire [3:0]timer;

// Instantiate the vending machine module
vendingMachine uut (
    .clk(clk),
    .rst(rst),
    .select_button(select_button),
    .coin_in(coin_in),
    .dispense(dispense),
    .notValidCoin(notValidCoin),
    .timer(timer)
);

// Clock generator: toggles every 5ns (10ns clock period)
always #5 clk = ~clk;

// Task to wait based on the coin value
task wait_based_on_coin;
    input [3:0] coin;
    begin
        if (coin == 4'd10)
            repeat(18) @(posedge clk);
        else
            repeat(3) @(posedge clk);
    end
endtask

initial begin
    $display("Starting vending machine testbench...");
    $monitor("Time=%0t | select_button = %b, coin_in = %d | dispense = %b, notValidCoin = %b", 
              $time, select_button, coin_in, dispense, notValidCoin);

    // Initial setup
    clk = 0;
    rst = 1;
    select_button = 0;
    coin_in = 0;
    #20;

    rst = 0;


    select_button = 1; #15;
    select_button = 0; coin_in = 10;
    wait_based_on_coin(coin_in);

    coin_in = 4'd7;
    wait_based_on_coin(coin_in);

    coin_in = 4'd10;
    wait_based_on_coin(coin_in);

    select_button = 1; #15;
    select_button = 0; coin_in = 4'd5;
    wait_based_on_coin(coin_in);

    select_button = 1; #15;
    select_button = 0; coin_in = 4'd10;
    wait_based_on_coin(coin_in);

    $finish;
end

endmodule
