// Suheyb Aden
// 01/28/2022
// Lab #2, Task 3

// This module takes in a 1-bit clock, reset, read, and write signal as
// well as a variable width input bus signal. The module then outputs
// a 1-bit signal for the FIFO being empty and being full as well as a
// variable width output bus signal. The inputBus holds data that will
// be written on the next write signal high and the outputBus holds the
// data read at the current read address.
module FIFO #(
				  parameter depth = 4,
				  parameter width = 8
				  )(
					 input logic clk, reset,
					 input logic read, write,
					 input logic [width-1:0] inputBus,
					output logic empty, full,
					output logic [width-1:0] outputBus
				   );
					
	// Define variables
	logic[depth-1:0] wraddress;
	logic[depth-1:0] rdaddress;
	logic wren;
	
	// Instantiate Dual-Port Ram
	ram16x8 ram(.clock(clk), .data(inputBus), .rdaddress,
					.wraddress, .wren, .q(outputBus));
	
	// Instantiate FIFO_Control module			
	FIFO_Control #(depth) FC (.clk, .reset, 
									  .read, 
									  .write, 
									  .wr_en(wren),
									  .empty,
									  .full,
									  .readAddr(rdaddress), 
									  .writeAddr(wraddress)
									 );
endmodule 

// Tests writing a bunch of data into the FIFO and then reading out all that data
`timescale 1 ps / 1 ps
module FIFO_testbench();
	parameter depth = 4, width = 8;
	
	logic clk, reset;
	logic read, write;
	logic [width-1:0] inputBus;
	logic empty, full;
	logic [width-1:0] outputBus;
	
	FIFO #(depth, width) dut (.clk, .reset, .read, .write, .inputBus,
										.empty, .full, .outputBus);
	
	// Sets the clock signal
	parameter CLK_Period = 100;
	initial begin
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	// Starts testing
	initial begin
		reset <= 0;
		read <= 0;
		inputBus <= 0;
		write <= 0;		repeat(2) @(posedge clk);
		
		inputBus <= 8'b11001100;	
		write <= 1;		@(posedge clk);
		write <= 0;		@(posedge clk);
		
		inputBus <= 8'b10011001;	
		write <= 1;		@(posedge clk);
		write <= 0;		@(posedge clk);
		
		inputBus <= 8'b00110011;	
		write <= 1;		@(posedge clk);
		write <= 0;		@(posedge clk);
			
		read <= 1;		@(posedge clk);
		read <= 0;		@(posedge clk);
		read <= 1;		@(posedge clk);
		read <= 0;		@(posedge clk);
		read <= 1;		@(posedge clk);
		read <= 0;		@(posedge clk);
		read <= 1;		@(posedge clk);
		read <= 0;		@(posedge clk);
		
		$stop; // End the simulation. 
	end
endmodule 