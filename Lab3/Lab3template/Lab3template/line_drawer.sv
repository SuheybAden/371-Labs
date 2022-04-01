// Suheyb Aden
// 2/11/2022
// EE 371
// Lab #3, Task #1

// This module takes in a 1-bit clk and reset signal as well as a 10-bit
// x0, x1 signal and a 9-bit y0, y1 signal. It then outputs a 10-bit x
// signal and a 9-bit y signal. This module implements Bresenham's line
// algorithm to calculate what x and y coordinates need to be written
// to for the line between the x and y input pairs to be displayed.
module line_drawer(
	input logic clk, reset,
	
	// x and y coordinates for the start and end points of the line
	input logic [9:0]	x0, x1, 
	input logic [8:0] y0, y1,

	//outputs cooresponding to the coordinate pair (x, y)
	output logic [9:0] x,
	output logic [8:0] y 
	);
	
/*
	 * You'll need to create some registers to keep track of things
	 * such as error and direction
	 * Example: */
	logic signed [11:0] error, delta_x, delta_y, diff_x, diff_y;
	logic signed [1:0] ystep;
	logic steep;
	logic [10:0] start_x, start_y, end_x, end_y, out_x, out_y;
	
	enum{INIT_1, INIT_2, DRAW} state;
	
	assign diff_x = (x1 > x0) ? (x1 - x0) : (x0 - x1);
	assign diff_y = (y1 > y0) ? (y1 - y0) : (y0 - y1);
	assign steep = diff_y > diff_x;
	assign ystep = (y0 < y1 ? 1 : -1);

	
	always_ff @(posedge clk)  begin
		case (state)
			// First state handles initializing the start and end
			// coordinates as well as calculating delta x and delta y
			INIT_1: begin
					if (steep) begin
						if (y0 > y1) begin
							start_x <= y1;
							start_y <= x1;
							end_x <= y0;
							end_y <= x0;
							delta_x <= y0 - y1;
						end
						else begin
							start_x <= y0;
							start_y <= x0;
							end_x <= y1;
							end_y <= x1;
							delta_x <= y1 - y0;
						end
						delta_y <= (x1 > x0) ? (x1 - x0) : (x0 - x1);
					end
					else begin
						if (x0 > x1) begin
							start_x <= x1;
							start_y <= y1;
							end_x <= x0;
							end_y <= y0;
							delta_x <= x0 - x1;
						end
						else begin
							start_x <= x0;
							start_y <= y0;
							end_x <= x1;
							end_y <= y1;
							delta_x <= x1 - x0;
						end
						delta_y <= (y1 > y0) ? (y1 - y0) : (y0 - y1);
					end
					state <= INIT_2;
				end
			
			// Second init state sets error and out x and out y values
			INIT_2: begin
					error <= {delta_x[11], delta_x[11:1]};
					out_x <= start_x;
					out_y <= start_y;
					state <= DRAW;
					end
			
			// Draw state calculates what x and y coordinates need to be
			// written to. This state stays active until the line is fully drawn.
			DRAW: begin 
					if (steep) begin
						x <= out_y;
						y <= out_x;
					end else begin 
						x <= out_x;
						y <= out_y;
					end
					out_x <= out_x + 11'd1;
					if (error - delta_y < 0) begin
						error <= error - delta_y + delta_x;
						out_y <= out_y + ystep;
					end else begin
						error <= error - delta_y;
					end
					if (out_x == end_x) begin
						state <= INIT_1;
					end
				end
				
			default: state <= INIT_1;
		endcase
	end
endmodule

// Testbench for the line_drawer module that tests drawing a line
// from (300,300) to (200, 50) for 20 clock cycles
module line_drawer_testbench();
	logic clk, reset;
	
	// x and y coordinates for the start and end points of the line
	logic [9:0]	x0, x1; 
	logic [8:0] y0, y1;

	//outputs cooresponding to the coordinate pair (x, y)
	logic [9:0] x;
	logic [8:0] y;
	
	line_drawer dut(.clk, .reset, .x0, .x1, .y0, .y1, .x, .y);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end 
	
	// Tests getting the 
	initial begin
		reset <= 0;
		x0 <= 300; x1 <= 200;
		y0 <= 300; y1 <= 50; repeat(200) @(posedge clk);
		$stop;
	end
endmodule
