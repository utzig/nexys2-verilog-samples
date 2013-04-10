module stopwatch
(
	input           clk,
	input           btn,
	output   [6:0]  seg,
	output   [3:0]  an,
	output          dp
);

reg  [27:0]  counter;
reg  [3:0]   sec0;
reg  [3:0]   sec1;
reg  [3:0]   min0;
reg  [3:0]   min1;
reg          counting;

sevenseg sevenseg0 (
	.clk1      ( clk    ),
	.digit0    ( min1   ),
	.digit1    ( min0   ),
	.digit2    ( sec1   ),
	.digit3    ( sec0   ),
	.decplace  ( 2'b10  ),
	.seg1      ( seg    ),
	.an1       ( an     ),
	.dp1       ( dp     )
);

always @(posedge btn) begin
	counting <= ~counting;
end

always @(posedge clk) begin
	if (counting == 1'b1) begin
		counter <= counter + 1;
		if (counter == 50000000) begin
			counter <= 1;
			sec0 <= sec0 + 1;
		end

		if (sec0 == 4'hA) begin
			sec1 <= sec1 + 1;
			sec0 <= 0;
		end

		if (sec1 == 4'h6) begin
			min0 <= min0 + 1;
			sec1 <= 0;
		end

		if (min0 == 4'hA) begin
			min1 <= min1 + 1;
			min0 <= 0;
		end

		if (min1 == 4'h6) min1 <= 0;
	end
end

endmodule
