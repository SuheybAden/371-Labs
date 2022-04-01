// Suheyb Aden
// 2/25/2022
// EE 371
// Lab #4, Task #2

// This module accepts 1-bit clk, reset, and start signals as well
// as a 5-bit input named A. The output is an 8-bit output named L
// as well as 1-bit found and not_found signals. This module conducts
// a binary search on a sorted array and looks for a value equal to A.
// If found, the found signal will go high and the address of the found
// data will be outputted on L. Otherwise, not_found will go high instead.
module binary_search(input logic clk,
							input logic reset,
							input logic start,
							input logic[7:0] A,
							output logic[4:0] L,
							output logic found,
							output logic not_found);
	logic [7:0] curr_data;
	logic [5:0] curr_addr;
	logic  A_ld, top_ld, top_s,
			bottom_ld, bottom_s, gt_A, lt_A;
	
	// Connecting controller, datapath, and RAM modules
	binary_search_controller controller(.clk, .reset, .start,
														.found, .not_found,
														.gt_A, .lt_A, .A_ld,
														.top_ld, .top_s,
														.bottom_ld, .bottom_s);
														
	binary_search_datapath datapath(.clk, .reset, .A_ld, .new_target(A),
												.top_s, .top_ld, .bottom_s, .bottom_ld,
												.curr_data, .curr_addr, .gt_A, .lt_A,
												.found, .not_found, .L);
	
	ram32x8 ram (.clock(clk), .data(8'b0), .rdaddress(curr_addr[4:0]), 
						.wraddress(5'b0), .wren(1'b0), .q(curr_data));

endmodule

// Control path for the binary search module
module binary_search_controller(	// inputs from main module
											input logic clk,
											input logic reset,
											input logic start,
											// inputs from datapath
											input logic found,
											input logic not_found,
											input logic gt_A,
											input logic lt_A,
											
											output logic top_ld, top_s,
																bottom_ld, bottom_s,
																A_ld);
	
	enum {RESET, IDLE, SEARCH, DONE} ps, ns;
	
	// Determines the next state of the control path
	always_comb begin
		case(ps)
			RESET: begin
						if(start) ns <= IDLE;
						else ns <= RESET;
					end
			
			IDLE: begin
						ns <= SEARCH;
					end

			SEARCH: begin
							if(found || not_found) ns <= DONE;
							else ns <= IDLE;
						end
						
			DONE: begin
						if(start) ns <= DONE;
						else ns <= RESET;
					end
		endcase
	end
	
	
	// Assigns outputs for control signals
	assign A_ld = (ns == RESET) && !start;
	
	assign top_s = (ps == RESET);
	assign top_ld = (ps == RESET) || ((ns == IDLE) && (gt_A));
	
	assign bottom_s = (ps == RESET);
	assign bottom_ld = (ps == RESET) || ((ns == IDLE) && (lt_A));
	
	// Updates the state of the control path
	always_ff @(posedge clk) begin
		if(reset) ps <= RESET;
		else ps <= ns;
	end
	
endmodule


// Datapath for binary search module
module binary_search_datapath(input logic clk,
										input logic reset,
										input logic A_ld,
										input logic[7:0] new_target,
										input logic top_s,
										input logic top_ld,
										input logic bottom_s,
										input logic bottom_ld,
										input logic[7:0] curr_data,
										// output to RAM module
										output logic[5:0] curr_addr,
										// output to control path module
										output logic gt_A,
										output logic lt_A,
										
										output logic found,
										output logic not_found,
										output logic[4:0] L);
	logic[7:0] A;
	logic[4:0] top;
	logic[4:0] bottom;
	
	// Datapath logic
	always_ff @(posedge clk) begin
		
		if(A_ld) A <= new_target;
		else A <= A;
		
		// Update the value of the top pointer
		if(top_ld) begin
			// IDLE default value to top pointer
			if(top_s) top <= 6'd31;
			// This line is used when the current address is greater than target
			else top <= curr_addr;
		end
		
		// Updates the value of the bottom pointer
		if(bottom_ld) begin
			// Loads the default value to the bottom pointer
			if(bottom_s) bottom <= 'd0;
			// This line is used when the current address is less than target
			else begin
				// Needed for when the bottom pointer is 1 less than the top
				if(top == bottom + 1) bottom <= top;
				else bottom <= curr_addr;
			end
		end
		
	end
	
	// Outputs the current address if the target data is found there
	assign L = found ? curr_addr : 6'd0;
	
	// Sets the current address to halfway between the top and bottom pointers
	assign curr_addr = ((top + bottom) / 2'b10);
	
	// Signals whether the current data is greater or less than the target
	assign gt_A = (curr_data > A);
	assign lt_A = (curr_data < A);
	
	// Signals whether the target was found or not found
	assign found = (curr_data == A);
	assign not_found = (!found && (top == bottom));
	
endmodule


// Testbench for the binary_search module
`timescale 1 ps / 1 ps
module binary_search_testbench();
	logic clk;
	logic reset;
	logic start;
	logic[7:0] A;
	logic[4:0] L;
	logic found;
	logic not_found;
	
	binary_search dut(.*);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end
	
	// Tests searching for the number 11 in the data array
	initial begin
		reset <= 0;
		A <= 'd33;
		start <= 0;	@(posedge clk);
		start <= 1;	repeat(30) @(posedge clk);
		$stop;
	end
endmodule
