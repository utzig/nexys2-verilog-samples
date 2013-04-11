module vga
(
	input             clk,
	input      [3:0]  sw,
	output            hs,
	output            vs,
	output reg [2:0]  red,
	output reg [2:0]  green,
	output reg [1:0]  blue
);

wire   [10:0]  hcount;
wire   [10:0]  vcount;
reg            clk_2;
reg    [7:0]   counter;

reg    [4:0]   ball_speed;
reg            ball_h_dir;
reg            ball_v_dir;

reg    [10:0]  ball_h_init;
reg    [10:0]  ball_v_init;

wire           vblank;
reg            blank;

`define HPIXELS     11'd640
`define VPIXELS     11'd480

`define BALL_HSIZE  11'd8
`define BALL_VSIZE  11'd8
`define BALL_RED    3'h7;
`define BALL_GREEN  3'h0;
`define BALL_BLUE   2'h0;

`define RIGHT       1'b0
`define LEFT        1'b1
`define DOWN        1'b0
`define UP          1'b1

initial begin
	ball_h_init = 10'd310;
	ball_v_init = 10'd230;
	ball_h_dir = 1'b0;
	ball_v_dir = 1'b0;
end

always @(posedge clk) begin
	clk_2 <= ~clk_2;
	ball_speed <= sw;
end

vga_controller vga0
(
	.rst         ( 1'b0    ),
	.pixel_clk   ( clk_2   ),
	.hcount      ( hcount  ),
	.vcount      ( vcount  ),
	.hs          ( hs      ),
	.vs          ( vs      ),
	.vblank      ( vblank  )
);

always @(posedge clk_2) begin
	blank <= vblank;

	if (hcount >= ball_h_init && hcount <= (ball_h_init + `BALL_HSIZE) &&
	    vcount >= ball_v_init && vcount <= (ball_v_init + `BALL_VSIZE))
	begin
		red <= 3'h7;
		green <= 3'h7;
		blue <= 2'h3;
	end else begin
		red <= 3'h0;
		green <= 3'h0;
		blue <= 2'h0;
	end
end

always @(posedge vblank) begin
	if (ball_h_dir == `RIGHT) begin
		if ((ball_h_init + `BALL_HSIZE + ball_speed) >= `HPIXELS)
			ball_h_dir <= `LEFT;
		else
			ball_h_init <= ball_h_init + ball_speed;
	end else begin
		if (ball_h_init < ball_speed)
			ball_h_dir <= `RIGHT;
		else
			ball_h_init <= ball_h_init - ball_speed;
	end

	if (ball_v_dir == `DOWN) begin
		if ((ball_v_init + `BALL_VSIZE + ball_speed) >= `VPIXELS)
			ball_v_dir <= `UP;
		else
			ball_v_init <= ball_v_init + ball_speed;
	end else begin
		if (ball_v_init < ball_speed)
			ball_v_dir <= `DOWN;
		else
			ball_v_init <= ball_v_init - ball_speed;
	end
end

endmodule
