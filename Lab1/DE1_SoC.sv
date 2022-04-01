// Suheyb Aden
// 01/15/2022
// Lab #1, Task 1

// This module takes in a 34-bit GPIO_0 input and returns 7-bit HEX0,
// HEX1, HEX2, HEX3, HEX4, and HEX5 as outputs. The seven segment display
// are driven off the .
// This serves as the top-level module for the occupancy counter
module DE1_SoC(CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, GPIO_0);
	input logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	inout logic[33:0] GPIO_0;
	
	
	logic enter, exit, a, b, reset;
	assign reset = GPIO_0[8];
	assign GPIO_0[26] = GPIO_0[6];
	assign GPIO_0[27] = GPIO_0[7];
	
	
	logic[5:0] current_capacity;
	
	// Takes in the GPIO_0[6] and GPIO_0[7] as a and b respectively
	// and returns enter and exit
	gatekeeper gk(.clk(CLOCK_50), .reset, .a(GPIO_0[6]), .b(GPIO_0[6]),
						.enter, .exit);
	
	// The occupancy counter takes in the enter and exit signals outputted
	// by the gatekeeper as its inc and dec signals and returns the
	// current capacity of the parking lot.
	occupancy_counter oc(.clk(CLOCK_50), .reset, .inc(enter), .dec(exit), .current_capacity);
	
	// Drives the HEX display based on current_capacity
	always_comb begin
		case(current_capacity)
			0:	begin
				HEX5 = 7'b1000110; // C
				HEX4 = 7'b1000111; // L
				HEX3 = 7'b0000110; // E
				HEX2 = 7'b0001000; // A
				HEX1 = 7'b0101111; // r
				HEX0 = 7'b1000000; // 0
				end
			1: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111111; // blank
				HEX0 = 7'b1111001; // 1 
				HEX1 = 7'b1111111; // blank
				end
			2: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111111; // blank
				HEX0 = 7'b0100100; // 2 
				HEX1 = 7'b1111111; // blank
				end
			3: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111111; // blank
				HEX0 = 7'b0110000; // 3 
				HEX1 = 7'b1111111; // blank
				end
			4: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111111; // blank
				HEX0 = 7'b0011001; // 4 
				HEX1 = 7'b1111111; // blank
				end
			5: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111111; // blank
				HEX0 = 7'b0010010; // 5 
				HEX1 = 7'b1111111; // blank
				end
			6: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111111; // blank
				HEX0 = 7'b0000010; // 6 
				HEX1 = 7'b1111111; // blank
				end
			7: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111111; // blank
				HEX0 = 7'b1111000; // 7
				HEX1 = 7'b1111111; // blank
				end
			8: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111111; // blank
				HEX0 = 7'b0000000; // 8
				HEX1 = 7'b1111111; // blank
				end
			9: begin 
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111111; // blank
				HEX0 = 7'b0000100; // 9
				HEX1 = 7'b1111111; // blank
				end
			10: begin 
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b1000000; // 0
				end
			11: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b1111001; // 1 
				end
			12: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b0100100; // 2 
				end
			13: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b0110000; // 3 
				end
			14: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b0011001; // 4 
				end
			15: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b0010010; // 5 
				end
			16: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b0000010; // 6
				end
			17: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b1111000; // 7
				end
			18: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b0000000; // 8
				end
			19: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b1111001; // 1 
				HEX0 = 7'b0000100; // 9
				end
			20: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b0100100; // 2 
				HEX0 = 7'b1000000; // 0
				end
			21: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b0100100; // 2 
				HEX0 = 7'b1111001; // 1 
				end
			22: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b0100100; // 2 
				HEX0 = 7'b0100100; // 2 
				end
			23: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b0100100; // 2 
				HEX0 = 7'b0110000; // 3 
				end
			24: begin
				HEX5 = 7'b1111111; // blank
				HEX4 = 7'b1111111; // blank
				HEX3 = 7'b1111111; // blank
				HEX2 = 7'b1111111; // blank
				HEX1 = 7'b0100100; // 2 
				HEX0 = 7'b0011001; // 4 
				end
			default: begin
				HEX5 = 7'b0001110; // F
				HEX4 = 7'b1000001; // U
				HEX3 = 7'b1000111; // L
				HEX2 = 7'b1000111; // L
				HEX1 = 7'b0100100; // 2 
				HEX0 = 7'b0010010; // 5 
				end
			
		endcase
	end
	
endmodule

// Testbench for the DE1_SoC module that tests having one car fully
// enter and one car fully exit
module DE1_SoC_testbench();
	logic clk, a, b;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [33:0] GPIO_0;
	
	DE1_SoC dut(.CLOCK_50(clk), .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .GPIO_0);
		
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end 
	
	assign GPIO_0[6] = a;
	assign GPIO_0[7] = b;
	
	// Tests one car entering and one car leaving
	initial begin
		a <= 0;
		b <= 0; @(posedge clk);
		a <= 1;
		b <= 0; @(posedge clk);
		a <= 1;
		b <= 1; @(posedge clk);
		a <= 0;
		b <= 1; @(posedge clk);
		a <= 0;
		b <= 0; @(posedge clk);
		a <= 0;
		b <= 0; @(posedge clk);
		a <= 0;
		b <= 0; @(posedge clk);
		a <= 0;
		b <= 1; @(posedge clk);
		a <= 1;
		b <= 1; @(posedge clk);
		a <= 1;
		b <= 0; @(posedge clk);
		a <= 0;
		b <= 0; @(posedge clk);
		a <= 0;
		b <= 0; @(posedge clk);
		$stop;
	end
	
endmodule

