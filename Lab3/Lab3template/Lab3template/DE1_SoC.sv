// Suheyb Aden
// 2/11/2022
// EE 371
// Lab #3, Task #1

// This is the top-level module for both the line drawer and animator.
// Connects the output of the animator to the input of the line drawer and
// connects their resets to switch 9.
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
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;
	
	logic [9:0] x0;
	logic [9:0] x1;
	logic [9:0] x;
	logic [8:0] y0;
	logic [8:0] y1;
	logic [8:0] y;
	logic frame_start;
	logic pixel_color;
	
	// Assigns reset to switch 9
	logic reset;
	assign reset = SW[9];
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	
	VGA_framebuffer fb(.clk(CLOCK_50), .rst(1'b0), .x, .y,
				.pixel_color, .pixel_write(1'b1), .dfb_en, .frame_start,
				.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_N, .VGA_SYNC_N);
	
	logic [31:0] clk;
	parameter whichClock = 23;
	clock_divider cdiv(.clock(CLOCK_50), .reset(reset), .divided_clocks(clk));
	
	
	// draw lines between (x0, y0) and (x1, y1)
	line_drawer lines (.clk(CLOCK_50), .reset,
				.x0, .y0, .x1, .y1, .x, .y);
	
	animator anmtr(.clk(CLOCK_50), .reset(reset), .color(pixel_color), 
						.start_x(x0), .start_y(y0), .end_x(x1), .end_y(y1));
//	
//	// draw an arbitrary line
//	assign x0 = 100;
//	assign y0 = 100;
//	assign x1 = 150;
//	assign y1 = 300;
//	assign pixel_color = 1'b1;
	
endmodule

// Testbench for the DE1_SoC module that tests how the module behaves
// when the reset switch is set to high
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
	
	// Tests getting the 
	initial begin
		SW <= 0; repeat(10) @(posedge CLOCK_50);
		SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
		$stop;
	end
endmodule
