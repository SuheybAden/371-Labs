// Suheyb Aden
// 01/28/2022
// Lab #2, Task 3

// DE1_SoC takes a 1-bit CLOCK_50, 3-bit KEY, and 10-bit SW signal as inputs
// and outputs to a 10-bit LEDR and 7-bit HEX0, HEX1, HEX2, HEX3, HEX4, HEX5.
// HEX5 and 4 are driven by the input data entered on the SW and HEX1 and 0
// are driven by the data read from the FIFO
// This is the top level entity for the FIFO implemented in this lab
module DE1_SoC(CLOCK_50, KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input logic CLOCK_50;
	input logic[3:0] KEY;
	input logic[9:0] SW;
	output logic[9:0] LEDR;
	output logic[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	// Blanks out hex displays 2 and 3
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	
	// Sets parameters
	parameter depth = 4, width = 8;
	
	// Connects reset signal to SW[9]
	logic reset;
	assign reset = SW[9];
	
	// Defines input and output buses
	logic[width-1:0] inputBus;
	logic[width-1:0] outputBus;
	assign inputBus = SW[width-1:0];
	
	// Receives read/write signal from keys 3 and 0 respectively
	logic read;
	logic write;
	user_input read_input(.clk(CLOCK_50), .reset, .btnInput(!KEY[3]),
									.out(read));
	user_input write_input(.clk(CLOCK_50), .reset, .btnInput(!KEY[0]),
									.out(write));
	
	// Creates an instance of the FIFO
	// Displays on LEDs 8 and 9 whether FIFO is empty or full
	FIFO#(depth, width) fifo(.clk(CLOCK_50), .reset, .read, .write,
										.inputBus, .empty(LEDR[8]), .full(LEDR[9]),
										.outputBus);
	
	// Displays the input and output data on the HEX display
	display_hex_value input_data_MSB_display(inputBus[7:4], HEX5);
	display_hex_value input_data_LSB_display(inputBus[3:0], HEX4);
	display_hex_value output_data_MSB_display(outputBus[7:4], HEX1);
	display_hex_value output_data_LSB_display(outputBus[3:0], HEX0);
endmodule

// Tests writing a bunch of data into the FIFO and then reading out all that data
`timescale 1 ps / 1 ps
module DE1_SoC_testbench();	
	logic clk;
	logic[3:0] KEY;
	logic[9:0] SW;
	logic[9:0] LEDR;
	logic[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	DE1_SoC dut (.CLOCK_50(clk), .KEY, .SW, .LEDR, .HEX0, .HEX1,
						.HEX2, .HEX3, .HEX4, .HEX5);
	
	parameter CLK_Period = 100;
	initial begin
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	logic reset, read, write;
	logic[7:0] inputBus;
	
	assign SW[9] = reset;
	assign SW[7:0] = inputBus;
	assign KEY[3] = !read;
	assign KEY[0] = !write;
	
	// Starts testing
	initial begin
	
		reset <= 1;
		read <= 0;
		inputBus <= 0;
		write <= 0;		repeat(2) @(posedge clk);
		
		reset <= 0;
		inputBus <= 4'b1100;	
		write <= 1;		@(posedge clk);
		write <= 0;		@(posedge clk);
		
		inputBus <= 4'b1001;	
		write <= 1;		@(posedge clk);
		write <= 0;		@(posedge clk);
		
		inputBus <= 4'b0011;	
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
		read <= 1;		@(posedge clk);
		
		$stop; // End the simulation. 
	end
endmodule

