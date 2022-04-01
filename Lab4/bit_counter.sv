// Suheyb Aden
// 2/25/2022
// EE 371
// Lab #4, Task #1

// Module that accepts 1-bit clk, reset, and s signals as well as an
// n-bit wide data input. The module also outputs a 1-bit done signal
// and a 4-bit wide data_out signal. This module counts the number of
// bits in the n-bit wide input that are set to one and outputs this
// value to the data_out signal.
module bit_counter #(parameter width = 8)
							(input logic clk,
							input logic reset,
							input logic s,
							input logic[0:width-1] data,
							output logic done,
							output logic[0:3] data_out);
	// Shift register for holding the data input;
	logic [0:width-1] A = 0;
	// Stores the total number of bits set to 1
	logic [0:3] result = 0;
	
	enum{RESET, COUNTING, DONE} ps, ns;
	
	// Next state logic, state actions and conditional tests
	always_ff @(posedge clk) begin
		case(ps)
			RESET:	begin
							result <= 0;
							A <= data;
							if(s) ns <= COUNTING;
							else ns <= RESET;
						end
			
			COUNTING:	begin
								A <= A >> 1;
								if(A == 0) begin
									ns <= DONE;
								end
								else begin
									if(A[width-1] == 1) begin
										result <= result + 1;
										ns <= COUNTING;
									end
									else begin
										ns <= COUNTING;
									end
								end
							end

			DONE:	begin
						if(s) ns <= DONE;
						else ns <= RESET;
					end
					
			default: ns <= RESET;
		endcase
	end
	
	// Assigns outputs
	assign done = ps == DONE;
	assign data_out = done ? result : 0;
	
	// Updates previous state
	always_ff @(posedge clk) begin
		if(reset) ps <= RESET;
		else ps <= ns;
	end
endmodule


// Testbench for the bit_counter module that tests counting the number
// of bits set to 1 in an arbritrary 4-bit input
module bit_counter_testbench();
	parameter width = 4;

	logic clk;
	logic reset;
	logic s;
	logic[0:width-1] data;
	logic done;
	logic [0:3] data_out;
	
	bit_counter #(width) dut(.*);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end
	
	// Tests counting the number of 1s in 1111
	initial begin
		data <=	4'b1111;
		reset <= 0;
		s <= 0;	@(posedge clk);
		s <= 1;	repeat(10) @(posedge clk);
		$stop;
	end
endmodule
