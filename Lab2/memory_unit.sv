// Suheyb Aden
// 01/28/2022
// Lab #2, Task 1

// This module takes in a 5-bit address and 4-bit input data from SW as
// well as a 1-bit write signal from SW[9] and 1-bit clk signal from KEY[0]
// This module outputs the address, input data, and output data on
// 7-bit segement displays in hex form.
// This is the top-level module for the self-implemented memory unit
module memory_unit(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	// Defines inputs and outputs
	input logic[3:0] KEY;
	input logic[9:0] SW;
	output logic[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	logic [3:0] memory_array [31:0];
	logic [3:0] input_data, output_data = 0;
	logic [4:0] address;
	logic write, clk;
	
	// Clears out HEX 1 and 3 since they are unused
	assign HEX1 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	
	// Connects all the input values to their corresponding SW/KEY
	assign input_data = SW[3:0];
	assign address = SW[8:4];
	assign write = SW[9];
	assign clk = !KEY[0];

	// Writes the input data into the current memory address
	always_ff @(posedge clk) begin
		if(write) begin
			memory_array[address] <= input_data;
		end
		output_data <= memory_array[address];
	end
	
	// Displays the address, input_data, and data_out on the hex displays
	display_hex_value address_MSB_display({3'b000, address[4]}, HEX5);
	display_hex_value address_LSB_display(address[3:0], HEX4);
	display_hex_value input_data_display(input_data, HEX2);
	display_hex_value output_data_display(output_data, HEX0);

endmodule

// Tests out changing the value of addresses as well as
// switching between addresses in the memory unit
module memory_unit_testbench();
	// Define inputs and outputs
	logic[9:0] SW;
	logic[3:0] KEY;
	logic[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	memory_unit dut (.SW, .KEY, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);
	
	// Connecting SW and KEY inputs to custom logic inputs
	// so they are easier to keep track of and manipulate
	logic[4:0] address;
	logic[3:0] data;
	logic write, clk;
	
	assign SW[8:4] = address;
	assign SW[3:0] = data;
	assign SW[9] = write;
	assign KEY[0] = clk;
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end  
	
	initial begin
		KEY[3:1] <= 0;
		address <= 0;
		data <= 0;
		write <= 0;		repeat(2) @(posedge clk)
		
		address <= 5'b00000;
		data <= 4'b1100;	
		write <= 1;		repeat(2) @(posedge clk);
		
		address <= 5'b00001;
		data <= 4'b1100;	
		write <= 0;		repeat(2) @(posedge clk);
		
		address <= 5'b00001;
		data <= 4'b0011;	
		write <= 1;		repeat(2) @(posedge clk);
		
		address <= 5'b00000;
		data <= 4'b0000;	
		write <= 0;		repeat(2) @(posedge clk);
		
		$stop; // End the simulation. 
	end
	
endmodule
