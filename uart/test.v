module test
(
	input                clk,
	input                rxd,
	output               txd,
	input                btn,
	output       [7:0]   leds
);

reg       [7:0]   data_in;
wire      [7:0]   data_out;
reg               rd;
reg               wr;
wire              rda;
wire              tbe;

reg       [7:0]   data;
reg       [2:0]   state;

assign leds[7:5] = state;
assign leds[4] = 1'b0;

uart uart0
(
	.clk          ( clk          ),
	.rxd          ( rxd          ),
	.txd          ( txd          ),
	.data_in      ( data_in      ),
	.data_out     ( data_out     ),
	.rd           ( rd           ),
	.wr           ( wr           ),
	.rda          ( rda          ),
	.tbe          ( tbe          ),
	.leds         ( leds[3:0]    )
);

initial begin
	state = 3'd0;
	wr = 1'b0;
	rd = 1'b0;
end

always @(posedge clk) begin
	if (state == 3'd0 && rd == 1'b0 && wr == 1'b0 && btn == 1'b1) begin
		rd <= 1'b1;
		state <= 3'd1;
	end else if (state == 3'd1 && rda == 1'b0) begin
		state <= 3'd2;
	end else if (state == 3'd2 && rda == 1'b1) begin
		rd <= 1'b0;
		data <= data_out;
		state <= 3'd3;
	end else if (state == 3'd3 && tbe == 1'b1) begin
		data_in <= data;
		//data_in <= 8'h30;
		wr <= 1'b1;
		state <= 3'd4;
	end else if (state == 3'd4 && tbe == 1'b0) begin
		state <= 3'd5;
	end else if (state == 3'd5 && tbe == 1'b1) begin
		wr <= 1'b0;
		state <= 3'd0;
	end
end

endmodule
