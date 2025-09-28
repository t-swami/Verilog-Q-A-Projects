// pacman_nexys4.v
// Top-level module for the Pac-Man game.
// Updated to connect ghost coordinates between modules.

module pacman_nexys4 (
    input  wire clk,
    input  wire cpu_resetn,
    input  wire btnU,
    input  wire btnD,
    input  wire btnL,
    input  wire btnR,
    output wire h_sync,
    output wire v_sync,
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b
);

    // Internal Wires
    wire rst;
    wire video_on;
    wire [9:0] pixel_x, pixel_y;
    wire [11:0] rgb_out;
    wire clk_100mhz, clk_25mhz, locked;
    wire move_up, move_down, move_left, move_right;

    // --- Character Coordinate Wires ---
    wire [15:0] pacman_x, pacman_y;
    wire [15:0] blinky_x, blinky_y;
    wire [15:0] pinky_x,  pinky_y;
    wire [15:0] inky_x,   inky_y;
    wire [15:0] clyde_x,  clyde_y;

    // --- Clock and Reset Logic ---
    assign clk_100mhz = clk;
    assign rst = ~cpu_resetn;
    clk_wiz_0 clk_wiz_inst (.clk_out1(clk_25mhz),.reset(0),.locked(locked),.clk_in1(clk_100mhz));

    // --- Module Instantiations ---
    vga_controller vga_inst (.clk(clk_25mhz),.rst(rst),.h_sync(h_sync),.v_sync(v_sync),.video_on(video_on),.pixel_x(pixel_x),.pixel_y(pixel_y));
    input_handler input_inst (.clk(clk_100mhz),.rst(rst),.btnU_in(btnU),.btnD_in(btnD),.btnL_in(btnL),.btnR_in(btnR),.move_up(move_up),.move_down(move_down),.move_left(move_left),.move_right(move_right));

    game_fsm game_logic_inst (
       .clk(clk_100mhz),.rst(rst),
       .move_up(move_up),.move_down(move_down),.move_left(move_left),.move_right(move_right),
       .pacman_x_out(pacman_x),.pacman_y_out(pacman_y),
       .blinky_x_out(blinky_x),.blinky_y_out(blinky_y),
       .pinky_x_out(pinky_x),  .pinky_y_out(pinky_y),
       .inky_x_out(inky_x),    .inky_y_out(inky_y),
       .clyde_x_out(clyde_x),  .clyde_y_out(clyde_y)
    );

    render_engine render_inst (
       .clk(clk_25mhz),.rst(rst),
       .pixel_x(pixel_x),.pixel_y(pixel_y),
       .pacman_x_in(pacman_x),.pacman_y_in(pacman_y),
       .blinky_x_in(blinky_x),.blinky_y_in(blinky_y),
       .pinky_x_in(pinky_x),  .pinky_y_in(pinky_y),
       .inky_x_in(inky_x),    .inky_y_in(inky_y),
       .clyde_x_in(clyde_x),  .clyde_y_in(clyde_y),
       .rgb_out(rgb_out)
    );

    // --- Output Assignments ---
    assign vga_r = video_on? rgb_out[11:8] : 4'h0;
    assign vga_g = video_on? rgb_out[7:4]  : 4'h0;
    assign vga_b = video_on? rgb_out[3:0]  : 4'h0;

endmodule