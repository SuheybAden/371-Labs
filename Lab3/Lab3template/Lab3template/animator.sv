// Suheyb Aden
// 2/11/2022
// EE 371
// Lab #3, Task #2

// This module takes in a 1-bit clock and reset signal and outputs a 1-bit
// color signal as well as 10-bit start_x and end_x signals and 9-bit
// start_y and end_y signals. This module updates the start and end
// coordinates of the line in order to form a simple animation
module animator(clk, reset, color, start_x, start_y, end_x, end_y);
	input logic clk, reset;
	output logic color;
	output logic [9:0] start_x, end_x;
	output logic [8:0] start_y, end_y;
	
	logic[8:0] x_offset;
	logic[1:0] current_color;
	enum{RESET, CLEAR, DRAW, UPDATE} ps, ns;
	
	// Determines the next state of the animation
	// If not reset, it will cycle through the states DRAW, CLEAR, and
	// UPDATE, in that order.
	always_ff @(posedge clk) begin
		case(ps)
			RESET: begin
					x_offset <= 0;
					current_color <= 1'b0;
					ns <= CLEAR;
					end
			DRAW: begin
					current_color <= 1'b1;
					ns <= CLEAR;
					end
			CLEAR: begin
					current_color <= 1'b0;
					ns <= UPDATE;
					end
			UPDATE: begin
					x_offset <= x_offset + 50;
					ns <= DRAW;
					end
			default: ns <= RESET;
		endcase
	end
	
	// Updates the previous state of the animation
	always_ff @(posedge clk) begin
		if(reset) ps <= RESET;
		else ps <= ns;
	end
	
	// Assigns the outputs
	assign color = current_color & !reset;
	assign start_x = 100 + x_offset;
	assign end_x = 100 + x_offset;
	assign start_y = 100;
	assign end_y = 380;
	
endmodule

// Testbench for the animator module that tests getting the start and end
// coordinates as well as the line color over the period of 10 clock cycles
module animator_testbench();
	logic clk, reset;
	logic color;
	logic [9:0] start_x, end_x;
	logic [8:0] start_y, end_y;

	animator dut(.clk, .reset, .color, .start_x, .start_y, .end_x, .end_y);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end 
	
	initial begin
		reset <= 0; repeat(10) @(posedge clk);
		$stop;
	end
endmodule
