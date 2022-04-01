// Suheyb Aden
// 01/28/2022
// Lab #2, Task 2

// This module takes in a 1-bit clk signal, 4-bit KEY and 10-bit SW as inputs
// and returns 7-bti HEX0, HEX1, HEX2, HEX3, HEX4 and HEX5 as outputs.
// This module lets the user write to 32x4 RAM through the SW inputs and
// displays the current stored data for about a second in a loop.
// This serves as the top-level module that uses the 32x4 ram generated from
// the IP catalog.
module ram_implementation(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input logic CLOCK_50;
	input logic[3:0] KEY;
	input logic[9:0] SW;
	output logic[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	logic reset;
	logic[3:0] read_data, write_data;
	logic[4:0] write_address, read_address = 0;
	logic[31:0] counter = 0;
	
	// Connects input values to their corresponding SW/KEY
	assign write_data = SW[3:0];
	assign write_address = SW[8:4];
	
	// Resets back to the first address
	assign reset = !KEY[0];
	
	// Takes CLOCK_50, write_data, read_address, write_address, and KEY[3]
	// as inputs and outputs q as read_data
	ram32x4 r(.clock(CLOCK_50), .data(write_data), .rdaddress(read_address),
				.wraddress(write_address), .wren(!KEY[3]), .q(read_data));
	
	// Increments the read address about once every second
	always_ff @(posedge CLOCK_50) begin
		if(reset) begin
			read_address <= 0;
			counter <= 0;
		end
		else if(counter == 1) begin
			read_address <= read_address + 1;
			counter <= 0;
		end
		else begin
			counter <= counter + 1;
		end
	end
	
	// Displays each of the values on their respective HEX display
	display_hex_value write_address_MSB_display({3'b0, write_address[4]}, HEX5);
	display_hex_value write_address_LSB_display(write_address[3:0], HEX4);
	
	display_hex_value read_address_MSB_display({3'b0, read_address[4]}, HEX3);
	display_hex_value read_address_LSB_display(read_address[3:0], HEX2);
	
	display_hex_value write_data_display(write_data, HEX1);
	
	display_hex_value read_data_display(read_data, HEX0);
	
endmodule

// Tests writing to an address as well as scrolling through and
// reading memory addresses in order
`timescale 1 ps / 1 ps
module ram_implementation_testbench();
	logic clk;
	logic[3:0] KEY;
	logic[9:0] SW;
	logic[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	ram_implementation dut(.CLOCK_50(clk), .KEY(KEY), .SW(SW), .HEX0(HEX0), .HEX1(HEX1),
				.HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end  

	// Test the design. 
	initial begin
		SW <= 0;
		KEY <= 4'b1111; @(posedge clk);
		SW[8:4] <= 5'b10111;
		SW[3:0] <= 4'b1111; repeat(4) @(posedge clk);
		$stop; // End the simulation.  
	end
endmodule
