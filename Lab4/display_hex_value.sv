// Suheyb Aden
// 02/25/2022
// Lab #4, Tasks 2

// Helper module for displaying hex value on a 7-segment display.
// This module takes in a 4-bit value representing the hex value to be displayed
// and outputs to a 7-bit segment display that shows the input value
module display_hex_value(value, hex_display);
	input logic [3:0] value;
	output logic [6:0] hex_display;
	
	always_comb begin
		case(value)
			4'h0: hex_display = 7'b1000000;
			4'h1:	hex_display = 7'b1111001;
			4'h2:	hex_display = 7'b0100100;
			4'h3:	hex_display = 7'b0110000;
			4'h4:	hex_display = 7'b0011001;
			4'h5:	hex_display = 7'b0010010;
			4'h6:	hex_display = 7'b0000010;
			4'h7:	hex_display = 7'b1111000;
			4'h8:	hex_display = 7'b0000000;
			4'h9:	hex_display = 7'b0010000;
			4'hA:	hex_display = 7'b0001000;
			4'hb:	hex_display = 7'b0000011;
			4'hC:	hex_display = 7'b1000110;
			4'hd:	hex_display = 7'b0100001;
			4'hE:	hex_display = 7'b0000110;
			4'hF:	hex_display = 7'b0001110;
			default: hex_display = 7'b1111111;
		endcase
	end
endmodule

// Testbench for the display_hex_value module that tests setting
// the display to an arbritrary value
module display_hex_value_testbench();
	logic clk;
	logic [3:0] value;
	logic [6:0] hex_display;
	
	display_hex_value dut (.*);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end
	
	// Tests displaying the number 8
	initial begin
		value <= 4'h8; repeat(5) @(posedge clk);
		$stop;
	end

endmodule
