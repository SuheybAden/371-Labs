// Suheyb Aden
// 2/11/2022
// EE 371
// Lab #3, Task #2

// This module takes in a 1-bit clock and reset signal and outputs a
// 32-bit signal holding the divided clocks. Each index of the 
// divided_clocks signal holds a clock signal with half the frequency of
// the preceding clock/index
// EX: divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... 
//     [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, reset, divided_clocks);
 input logic clock, reset;
 output logic [31:0] divided_clocks = 0;

 always_ff @(posedge clock) begin
	if(reset) divided_clocks <= 0;
	else divided_clocks <= divided_clocks + 1;
 end

endmodule

// Testbench for the clock divider module the generated clock signals
// over time
module clock_divider_testbench();
	logic clk, reset;
	logic [31:0] divided_clocks = 0;
	
	clock_divider dut(.clock(clk), .reset, .divided_clocks);
	
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
