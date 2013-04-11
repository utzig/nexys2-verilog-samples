module vga
(
	input             clk,
	input             rst,
	output            hs,
	output            vs,
	output reg [2:0]  red,
	output reg [2:0]  green,
	output reg [1:0]  blue,
	output            blank
);

wire   [10:0]  hcount;
wire   [10:0]  vcount;
reg            clk_2;
reg    [7:0]   counter;

always @(posedge clk) begin
	clk_2 <= ~clk_2;
end

vga_controller vga0
(
	.rst         ( rst     ),
	.pixel_clk   ( clk_2   ),
	.hcount      ( hcount  ),
	.vcount      ( vcount  ),
	.hs          ( hs      ),
	.vs          ( vs      ),
	.blank       ( blank   ),
	.vblank      ( vblank  )
);

always @(posedge clk_2) begin
	if (
	      hcount >= 11'd300 && hcount <= 11'd340 &&
	      vcount >= 11'd220 && vcount <= 11'd260
	   ) begin
		red = 3'b111;
		green = 3'b000;
		blue = 2'b00;
	end else begin
		red = 3'b000;
		green = 3'b000;
		blue = 2'b00;
	end
end

endmodule
