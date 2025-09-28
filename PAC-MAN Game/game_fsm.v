// game_fsm.v
// Adds fixed starting positions for all four ghosts.

module game_fsm (
    input  wire clk,
    input  wire rst,
    input  wire move_up,
    input  wire move_down,
    input  wire move_left,
    input  wire move_right,
    output reg  [15:0] pacman_x_out,
    output reg  [15:0] pacman_y_out,
    // New outputs for ghost coordinates
    output wire [15:0] blinky_x_out,
    output wire [15:0] pinky_x_out,
    output wire [15:0] inky_x_out,
    output wire [15:0] clyde_x_out,
    output wire [15:0] blinky_y_out,
    output wire [15:0] pinky_y_out,
    output wire [15:0] inky_y_out,
    output wire [15:0] clyde_y_out
);

    // Game clock divider to slow down movement
    reg [19:0] slow_clk_counter = 0;
    wire move_enable;
    localparam MOVE_TICK_DIVISOR = 21'd1666666;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            slow_clk_counter <= 0;
        end else begin
            slow_clk_counter <= (slow_clk_counter < MOVE_TICK_DIVISOR - 1)? slow_clk_counter + 1 : 0;
        end
    end
    assign move_enable = (slow_clk_counter == 0);

    // --- Character Starting Positions ---
    localparam PACMAN_START_X = 16'd312;
    localparam PACMAN_START_Y = 16'd368;
    localparam BLINKY_START_X = 16'd312; // Red
    localparam BLINKY_START_Y = 16'd200;
    localparam PINKY_START_X  = 16'd280; // Pink
    localparam PINKY_START_Y  = 16'd232;
    localparam INKY_START_X   = 16'd312; // Cyan
    localparam INKY_START_Y   = 16'd232;
    localparam CLYDE_START_X  = 16'd344; // Orange
    localparam CLYDE_START_Y  = 16'd232;

    // Assign fixed positions for ghosts
    assign blinky_x_out = BLINKY_START_X;
    assign blinky_y_out = BLINKY_START_Y;
    assign pinky_x_out  = PINKY_START_X;
    assign pinky_y_out  = PINKY_START_Y;
    assign inky_x_out   = INKY_START_X;
    assign inky_y_out   = INKY_START_Y;
    assign clyde_x_out  = CLYDE_START_X;
    assign clyde_y_out  = CLYDE_START_Y;

    // --- Pac-Man Movement FSM (remains the same) ---
    localparam DIR_STOP  = 3'b000;
    localparam DIR_UP    = 3'b001;
    localparam DIR_DOWN  = 3'b010;
    localparam DIR_LEFT  = 3'b011;
    localparam DIR_RIGHT = 3'b100;
    reg [2:0] direction = DIR_STOP;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            direction <= DIR_STOP;
        end else begin
            if (move_up)      direction <= DIR_UP;
            else if (move_down)  direction <= DIR_DOWN;
            else if (move_left)  direction <= DIR_LEFT;
            else if (move_right) direction <= DIR_RIGHT;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pacman_x_out <= PACMAN_START_X;
            pacman_y_out <= PACMAN_START_Y;
        end else if (move_enable) begin
            case (direction)
                DIR_UP:    pacman_y_out <= pacman_y_out - 1;
                DIR_DOWN:  pacman_y_out <= pacman_y_out + 1;
                DIR_LEFT:  pacman_x_out <= pacman_x_out - 1;
                DIR_RIGHT: pacman_x_out <= pacman_x_out + 1;
                default:   begin
                    pacman_x_out <= pacman_x_out;
                    pacman_y_out <= pacman_y_out;
                end
            endcase
        end
    end

endmodule