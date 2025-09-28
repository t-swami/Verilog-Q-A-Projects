// vga_controller.v
// Generates VGA timing signals for 640x480 @ 60Hz resolution.
// Requires a 25.175 MHz clock, which must be generated from the 100MHz system clock
// using a Clocking Wizard IP core in Vivado. For simplicity in this example,
// we will assume a 25MHz clock is provided.

module vga_controller (
    input  wire clk,        // IMPORTANT: This should be a ~25MHz pixel clock
    input  wire rst,        // Active-high reset
    output reg  h_sync,
    output reg  v_sync,
    output wire video_on,
    output wire [9:0] pixel_x,
    output wire [9:0] pixel_y
);

    // Horizontal Timing Parameters (in pixels) for 640x480 @ 60Hz
    localparam H_DISPLAY    = 640; // Visible area
    localparam H_FP         = 16;  // Front porch
    localparam H_SYNC_PULSE = 96;  // Sync pulse
    localparam H_BP         = 48;  // Back porch
    localparam H_TOTAL      = H_DISPLAY + H_FP + H_SYNC_PULSE + H_BP; // 800 total

    // Vertical Timing Parameters (in lines)
    localparam V_DISPLAY    = 480; // Visible area
    localparam V_FP         = 10;  // Front porch
    localparam V_SYNC_PULSE = 2;   // Sync pulse
    localparam V_BP         = 33;  // Back porch
    localparam V_TOTAL      = V_DISPLAY + V_FP + V_SYNC_PULSE + V_BP; // 525 total

    // Counters for horizontal and vertical position
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    // Update counters on each pixel clock edge
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count < H_TOTAL - 1) begin
                h_count <= h_count + 1;
            end else begin
                h_count <= 0;
                if (v_count < V_TOTAL - 1) begin
                    v_count <= v_count + 1;
                end else begin
                    v_count <= 0;
                end
            end
        end
    end

    // Generate HSync signal
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_sync <= 1'b1;
        end else begin
            // HSync is active low during the sync pulse period
            if (h_count >= H_DISPLAY + H_FP && h_count < H_DISPLAY + H_FP + H_SYNC_PULSE) begin
                h_sync <= 1'b0;
            end else begin
                h_sync <= 1'b1;
            end
        end
    end

    // Generate VSync signal
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            v_sync <= 1'b1;
        end else begin
            // VSync is active low during the sync pulse period
            if (v_count >= V_DISPLAY + V_FP && v_count < V_DISPLAY + V_FP + V_SYNC_PULSE) begin
                v_sync <= 1'b0;
            end else begin
                v_sync <= 1'b1;
            end
        end
    end

    // Assign pixel coordinates (visible area only)
    assign pixel_x = (h_count < H_DISPLAY)? h_count : 10'd0;
    assign pixel_y = (v_count < V_DISPLAY)? v_count : 10'd0;

    // Generate video_on signal (high only during visible area)
    assign video_on = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);

endmodule