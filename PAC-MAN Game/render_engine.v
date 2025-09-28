// render_engine.v
// Draws Pac-Man, all four ghosts, the maze, and pellets.

module render_engine (
    input  wire clk,
    input  wire rst,
    input  wire [9:0] pixel_x,
    input  wire [9:0] pixel_y,
    // Pac-Man coordinates
    input  wire [15:0] pacman_x_in,
    input  wire [15:0] pacman_y_in,
    // Ghost coordinates
    input  wire [15:0] blinky_x_in,
    input  wire [15:0] pinky_x_in,
    input  wire [15:0] inky_x_in,
    input  wire [15:0] clyde_x_in,
    input  wire [15:0] blinky_y_in,
    input  wire [15:0] pinky_y_in,
    input  wire [15:0] inky_y_in,
    input  wire [15:0] clyde_y_in,
    output reg  [11:0] rgb_out
);

    // Define colors
    localparam COLOR_BLACK   = 12'h000;
    localparam COLOR_MAZE    = 12'h00F;
    localparam COLOR_PELLET  = 12'hFFB;
    localparam SPRITE_SIZE   = 16;

    // --- Wires for ROM data and addresses ---
    wire [11:0] pacman_sprite_color, blinky_sprite_color, pinky_sprite_color, inky_sprite_color, clyde_sprite_color;
    wire [7:0]  pacman_sprite_addr,  blinky_sprite_addr,  pinky_sprite_addr,  inky_sprite_addr,  clyde_sprite_addr;
    wire is_wall, has_pellet;
    wire [11:0] map_address;

    // --- Wires to check if a pixel is part of a character ---
    wire is_pacman, is_blinky, is_pinky, is_inky, is_clyde;

    // --- Bounding Box Checks ---
    assign is_pacman = (pixel_x >= pacman_x_in) && (pixel_x < pacman_x_in + SPRITE_SIZE) && (pixel_y >= pacman_y_in) && (pixel_y < pacman_y_in + SPRITE_SIZE);
    assign is_blinky = (pixel_x >= blinky_x_in) && (pixel_x < blinky_x_in + SPRITE_SIZE) && (pixel_y >= blinky_y_in) && (pixel_y < blinky_y_in + SPRITE_SIZE);
    assign is_pinky  = (pixel_x >= pinky_x_in)  && (pixel_x < pinky_x_in  + SPRITE_SIZE) && (pixel_y >= pinky_y_in)  && (pixel_y < pinky_y_in  + SPRITE_SIZE);
    assign is_inky   = (pixel_x >= inky_x_in)   && (pixel_x < inky_x_in   + SPRITE_SIZE) && (pixel_y >= inky_y_in)   && (pixel_y < inky_y_in   + SPRITE_SIZE);
    assign is_clyde  = (pixel_x >= clyde_x_in)  && (pixel_x < clyde_x_in  + SPRITE_SIZE) && (pixel_y >= clyde_y_in)  && (pixel_y < clyde_y_in  + SPRITE_SIZE);

    // --- Address Calculations ---
    assign pacman_sprite_addr = (pixel_y - pacman_y_in) * 16 + (pixel_x - pacman_x_in);
    assign blinky_sprite_addr = (pixel_y - blinky_y_in) * 16 + (pixel_x - blinky_x_in);
    assign pinky_sprite_addr  = (pixel_y - pinky_y_in)  * 16 + (pixel_x - pinky_x_in);
    assign inky_sprite_addr   = (pixel_y - inky_y_in)   * 16 + (pixel_x - inky_x_in);
    assign clyde_sprite_addr  = (pixel_y - clyde_y_in)  * 16 + (pixel_x - clyde_x_in);
    assign map_address        = (pixel_y >> 4) * 40 + (pixel_x >> 4);
    wire is_pellet_pixel      = (pixel_x[3:2] == 2'b10) && (pixel_y[3:2] == 2'b10);

    // --- Instantiate all ROMs ---
    pacman_sprite_rom pacman_rom_inst (.clka(clk),.ena(1'b1),.addra(pacman_sprite_addr),.douta(pacman_sprite_color));
    ghost_sprite_rom  blinky_rom_inst (.clka(clk),.ena(1'b1),.addra(blinky_sprite_addr),.douta(blinky_sprite_color));
    pinky_sprite_rom  pinky_rom_inst  (.clka(clk),.ena(1'b1),.addra(pinky_sprite_addr),.douta(pinky_sprite_color));
    inky_sprite_rom   inky_rom_inst   (.clka(clk),.ena(1'b1),.addra(inky_sprite_addr), .douta(inky_sprite_color));
    clyde_sprite_rom  clyde_rom_inst  (.clka(clk),.ena(1'b1),.addra(clyde_sprite_addr),.douta(clyde_sprite_color));
    maze_rom          maze_rom_inst   (.clka(clk),.ena(1'b1),.addra(map_address),      .douta(is_wall));
    pellet_rom        pellet_rom_inst (.clka(clk),.ena(1'b1),.addra(map_address),      .douta(has_pellet));

    // --- Final Drawing Logic with Priority ---
    always @(*) begin
        if (is_pacman && pacman_sprite_color!= COLOR_BLACK)
            rgb_out = pacman_sprite_color;
        else if (is_blinky && blinky_sprite_color!= COLOR_BLACK)
            rgb_out = blinky_sprite_color;
        else if (is_pinky && pinky_sprite_color!= COLOR_BLACK)
            rgb_out = pinky_sprite_color;
        else if (is_inky && inky_sprite_color!= COLOR_BLACK)
            rgb_out = inky_sprite_color;
        else if (is_clyde && clyde_sprite_color!= COLOR_BLACK)
            rgb_out = clyde_sprite_color;
        else if (is_wall)
            rgb_out = COLOR_MAZE;
        else if (has_pellet && is_pellet_pixel)
            rgb_out = COLOR_PELLET;
        else
            rgb_out = COLOR_BLACK;
    end

endmodule