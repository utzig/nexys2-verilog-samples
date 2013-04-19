module uart
(
	input                clk,
	input                rxd,
	output reg           txd,
	input        [7:0]   data_in,
	output       [7:0]   data_out,
	input                rd,
	input                wr,
	output reg           rda,
	output reg           tbe,
	output       [3:0]   leds
);

// States
parameter IDLE=4'b0001, START=4'b0010, DATA=4'b0100, END=4'b1000;
reg [3:0] tx_sm;
reg [3:0] rx_sm;

// 50Mhz / 115200 / 2
// One bit can be transmitted at every rising edge
parameter txdivisor = 8'd217;

// 50Mhz / 115200 / 8
// One bit is read at 2nd cycle of every 4th
parameter rxdivisor = 8'd54;

reg    [7:0]  txcounter;
reg    [7:0]  txdata;
reg           txclk;
reg    [3:0]  txbit;
reg    [2:0]  idle_cycle;

reg    [7:0]  rxcounter;
reg    [7:0]  rxdata;
reg    [2:0]  rxclkcnt;
reg           rxclk;
reg    [3:0]  rxbit;

initial begin
	txcounter = 8'd0;
	rxcounter = 8'd0;
	txclk = 1'b0;
	rxclk = 1'b0;
	rxclkcnt = 3'd0;
	txd = 1'b1;
	tx_sm = IDLE;
	rx_sm = IDLE;
	idle_cycle = 3'd0;
	tbe = 1'b1;
end

assign data_out = rxdata;

assign leds[3:0] = rx_sm[3:0];

// TX related routines

always @(posedge clk) begin
	if (txcounter == txdivisor) begin
		txcounter <= 8'd0;
		txclk <= ~txclk;
	end else
		txcounter <= txcounter + 8'd1;
end

always @(posedge txclk) begin
	if (tx_sm == IDLE) begin
		txd <= 1'b1;
		if (wr == 1'b1)
			tx_sm <= START;
	end else if (tx_sm == START) begin
		// Send start bit
		tbe <= 1'b0;
		txd <= 1'b0;
		txbit <= 4'd0;
		txdata <= data_in;
		tx_sm <= DATA;
	end else if (tx_sm == DATA) begin
		if (txbit == 4'd8) begin
			// Send stop bit
			txbit <= 4'd0;
			txd <= 1'b1;
			tx_sm <= END;
		end else begin
			txd <= txdata[0];
			txdata <= { 1'b0, txdata[7:1] };
			txbit <= txbit + 4'd1;
		end
	end else if (tx_sm == END) begin
		tbe <= 1'b1;
		if (wr == 1'b0)
			tx_sm <= IDLE;
	end
end

// RX related routines

always @(posedge clk) begin
	if (rxcounter == rxdivisor) begin
		rxcounter <= 8'd0;
		rxclk <= ~rxclk;
	end else
		rxcounter <= rxcounter + 8'd1;
end

always @(posedge rxclk) begin
	if (rx_sm == IDLE) begin
		rxclkcnt <= 3'd0;
		if (rd == 1'b1)
			rx_sm <= START;
	end else if (rx_sm == START) begin
		rda <= 1'b0;
		// a valid start bit must be low for at least 3 rx clock cycles
		if (rxclkcnt == 3'd0 || rxclkcnt == 3'd1 || rxclkcnt == 3'd2) begin
			if (rxd == 1'b0)
				rxclkcnt <= rxclkcnt + 3'd1;
			else
				rxclkcnt <= 3'd0;
		end else if (rxclkcnt == 3'd3) begin
			rxclkcnt <= 3'd0;
			rxbit <= 4'd0;
			rxdata <= 8'd0;
			rx_sm <= DATA;
		end
	end else if (rx_sm == DATA) begin
		if (rxbit == 3'd8) begin
			rxclkcnt <= 3'd0;
			rx_sm <= END;
		end else if (rxclkcnt == 3'd1) begin
			rxdata <= { rxdata[6:0], rxd };
			rxclkcnt <= rxclkcnt + 3'd1;
		end else if (rxclkcnt == 3'd3) begin
			rxclkcnt <= 3'd0;
			rxbit <= rxbit + 3'd1;
		end else
			rxclkcnt <= rxclkcnt + 3'd1;
	end else if (rx_sm == END) begin
		// Finish with receipt of stop bit
		if (rxclkcnt == 3'd3) begin
			rda <= 1'b1;
			if (rd == 1'b0)
				rx_sm <= IDLE;
		end else
			rxclkcnt <= rxclkcnt + 3'd1;
	end
end

endmodule
