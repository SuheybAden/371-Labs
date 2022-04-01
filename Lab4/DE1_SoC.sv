// Suheyb Aden
// 2/25/2022
// EE 371
// Lab #4, Task #1

// This is the top-level module for both the bit_counter and binary_search module.
// Connects the inputs of the modules to the peripherals on the DE1_SoC board.
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	
	// Connects reset and start to their respective keys/switches
	logic reset;
	logic s;
	
	assign reset = !KEY[0];
	assign s = SW[9];
	

	// ---------------------------- TASK 1 -------------------------- //
//	assign HEX1 = '1;
//	
//	parameter width = 8;
//
//	// Display when the algorithm is finished
//	logic done;
//	assign LEDR[9] = done;
//
//	// Connects input data for the counter module to their respective keys/switches
//	logic [0:width-1] data;
//	
//	assign data = SW[7:0];
//	
//	// Creates registers for output data
//	logic [0:3] data_out;
//	
//	// Instantiates bit counter module
//	bit_counter #(width) counter (.clk(CLOCK_50),
//											.reset(reset),
//											.s(s),
//											.data(data),
//											.done(done),
//											.data_out(data_out));
//
//	// Display number of 1s counted on HEX0
//	display_hex_value display_1s (.value(data_out), .hex_display(HEX0));


	// --------------------------- TASK 2 --------------------------- //
	logic found;
	logic not_found;
	logic [4:0] addr;
	logic [7:0] A;
	
	assign A = SW[7:0];
	
	// Instantiates binary_search module with A representing the input
	// data to search for and addr representing the address of the found data.
	binary_search search(.clk(CLOCK_50), .reset, .start(s), .A,
								.L(addr), .found, .not_found);
	
	// Displays the address of the found data on HEX0 and HEX1
	display_hex_value display_addr_LSB(.value(addr[3:0]),
													.hex_display(HEX0));
	display_hex_value display_addr_MSB(.value({3'b000, addr[4]}),
													.hex_display(HEX1));
	assign LEDR[9] = found;
	assign LEDR[8] = not_found;

endmodule

// Testbench for the DE1_SoC module that tests how the module behaves
// to searching the data array for an arbritrary 8-bit input
`timescale 1 ps / 1 ps
module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	logic CLOCK_50;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	
	DE1_SoC dut(.*);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		CLOCK_50 <= 0;  
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock 
	end 
	
	// Tests finding the value 254 from the data array
	initial begin
		SW <= 0; @(posedge CLOCK_50);
		SW[7:0] <= 8'b11111110;
		SW[9] <= 1; repeat(30) @(posedge CLOCK_50);
		$stop;
	end
	
//	// Tests counting the number of 1s in 00011010
//	initial begin
//		SW <= 0; @(posedge CLOCK_50);
//		SW[7:0] <= 8'b00011010;
//		SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
//		$stop;
//	end
endmodule
