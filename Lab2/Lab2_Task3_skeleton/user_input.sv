// Suheyb Aden
// 01/28/2022
// Lab #2, Task 3

// This module takes in a 1-bit clk, reset, and input signal and then
// outputs a 1-bit out signal that is high for one clock cycle
module user_input(clk, reset, btnInput, out);
	input logic clk, reset, btnInput;
	output logic out;
	
	enum{ btn_up, btn_down} ps, ns;
	
	// Next State Logic
	always_comb begin
		case (ps)
			btn_up: if(btnInput) ns = btn_down;
						else ns = btn_up;
			btn_down: if(btnInput) ns = btn_down;
						else ns = btn_up;
		endcase
	end
	
	// Output's true if it's transitioning from up to down state
	assign out = (ps == btn_up) & (ns == btn_down);
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= btn_up;
		else
			ps <= ns;
	end
	
endmodule

// Tests setting the button input to high for longer than one clock cycle
module user_input_testbench();
	logic clk, reset, btnInput;
	logic out;
	
	user_input dut (.clk, .reset, .btnInput, .out);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end  

	// Test the design. 
	initial begin
		btnInput <= 0; @(posedge clk);
		btnInput <= 1;	repeat(5) @(posedge clk); 
		btnInput <= 0; repeat(5) @(posedge clk);
		btnInput <= 1;	repeat(5) @(posedge clk); 
		$stop; // End the simulation.  
	end
	
endmodule 