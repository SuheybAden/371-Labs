// Suheyb Aden
// 01/28/2022
// Lab #2, Task 3

// This module takes in a 1-bit clk, reset, read, and write signal and
// outputs a 1-bit write enable, empty, and full signal as well as a
// a variable size read address and write address signal. The "empty"
// and "full" outputs return true when the FIFO is empty or full
// respectfully. The readAddr and writeAddr point to an address in memory
// and their size is dependent on how many words there can be in the FIFO.
module FIFO_Control #(
							 parameter depth = 4
							 )(
								input logic clk, reset,
								input logic read, write,
							  output logic wr_en,
							  output logic empty, full,
							  output logic [depth-1:0] readAddr = 0, writeAddr = 0
							  );
	
	logic[depth-1:0] next_readAddr, next_writeAddr;
	
	// Sets conditions for when the empty and full signals are high
	assign empty = (readAddr == writeAddr);
	assign full = ((writeAddr + 1) % (2**depth)) == readAddr;
	
	// Determines next state of read/write addresses and enables wr_en
	always_comb begin
		if(!empty & read) begin
			next_readAddr <= ((readAddr + 1) % (2**depth));
		end
		else begin
			next_readAddr <= readAddr;
		end
		if(!full & write) begin
			wr_en <= 1'b1;
			next_writeAddr <= ((writeAddr + 1) % (2**depth));
		end
		else begin
			wr_en <= 1'b0;
			next_writeAddr <= writeAddr;
		end
	end
	
	// Handles resetting and updating addresses to their next state
	always_ff @(posedge clk) begin
		if(reset) begin
			readAddr <= '0;
			writeAddr <= '0;
		end
		else begin
			readAddr <= next_readAddr;
			writeAddr <= next_writeAddr;
		end
	end

endmodule 