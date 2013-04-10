module counter
(
	input             clk,
	input      [7:0]  sw,
	output     [7:0]  led
);

reg [29:0] counter;

assign led[7:0] = counter[29:22];

always @(posedge clk) begin
	counter <= counter + sw;
end

endmodule
