// Suheyb Aden
// 01/15/2022
// Lab #1, Task 1

// This module takes one bit inc and dec parameters as inputs
// and respectively increments and decrements the 6-bit current capacity
// of the parking lot
module occupancy_counter(clk, reset, inc, dec, current_capacity);
	input logic inc, dec, clk, reset;
	output logic[5:0] current_capacity = 0;
	
	// The maximum capacity of the parking lot
	// This module can't increment beyond this limit
	logic[5:0] max_capacity = 25;
	
	// If within the upper and lower bounds, this section will increment
	// or decrement the current capacity.
	// If the reset signal goes high, current capacity will be set to 0
	always_ff @(posedge clk) begin
		if(reset) current_capacity <= 0;
		else if(inc && (current_capacity < max_capacity)) current_capacity++;
		else if(dec && (current_capacity > 0)) current_capacity--;
		else current_capacity <= current_capacity;
	end
	
endmodule

// Testbench for the occupancy_counter that tests the counter being
// incremented repeatedly then decremented repeatedly
module occupancy_counter_testbench();
	logic clk, reset, inc, dec;
	logic[5:0] current_capacity;

	occupancy_counter dut(.clk, .reset, .inc, .dec, .current_capacity);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end  
	
	initial begin
		inc <= 0; dec <= 0; @(posedge clk);
		inc <= 1; repeat(10) @(posedge clk);
		inc <= 0; @(posedge clk);
		dec <= 1; repeat(10) @(posedge clk);
		dec <= 0; @(posedge clk);
		$stop;
	end
	
endmodule
