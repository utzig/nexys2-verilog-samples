module uart
(
	input              clk,
	input              btn,
	output reg         txd,
	output reg         led0,
	output reg         led1
);

parameter TX_SIZE     = 4;

parameter TX_IDLE     = 4'b0001,
          TX_START    = 4'b0010,
          TX_DATA     = 4'b0100,
          TX_END      = 4'b1000;

reg [TX_SIZE-1:0] tx_sm;

parameter divisor = 8'd217;
//parameter value = 8'h30;
parameter idle_bits = 3'd2;

reg    [7:0]  counter;
reg    [7:0]  txdata;
reg    [7:0]  value;
reg           uartclk;
reg    [3:0]  txbit;
reg    [2:0]  idle_bit;

initial begin
	counter = 16'd0;
	uartclk = 1'b0;
	value = 8'd32; // space character
	txd = 1'b1;
	tx_sm = TX_IDLE;
	idle_bit = 3'd0;
	led0 = 1'b0;
	led1 = 1'b0;
end

always @(posedge clk) begin
	if (counter == divisor) begin
		counter <= 8'd0;
		uartclk <= ~uartclk;
	end else
		counter <= counter + 8'd1;
end

always @(posedge uartclk) begin
	led1 <= ~led1;
	if (tx_sm == TX_IDLE) begin
		if (btn == 1'b1)
			tx_sm <= TX_START;
		else
			txd <= 1'b1;
	end else if (tx_sm == TX_START) begin
		// Send start bit
		txd <= 1'b0;
		txbit <= 4'd0;
		txdata <= value;
		value <= value + 8'd1;
		if (value == 8'd128)
			value <= 8'd32;
		tx_sm <= TX_DATA;
		led0 <= 1'b1;
	end else if (tx_sm == TX_DATA) begin
		if (txbit == 4'd8) begin
			// Send stop bit
			txbit <= 4'd0;
			txd <= 1'b0;
			led0 <= 1'b0;
			tx_sm <= TX_END;
		end else begin
			txd <= txdata[0];
			txdata <= { 1'b0, txdata[7:1] };
			txbit <= txbit + 4'd1;
		end
	end else if (tx_sm == TX_END) begin
		txd <= 1'b1;
		if (idle_bit == 3'd2) begin
			idle_bit <= 3'd0;
			tx_sm <= TX_IDLE;
		end else
			idle_bit <= idle_bit + 1;
	end
end

endmodule
