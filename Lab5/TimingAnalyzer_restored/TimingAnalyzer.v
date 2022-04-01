module TimingAnalyzer(clock, A, B, C, sum);
	input clock;
	localparam input_width = 128;
	localparam sum_width = 258;
	localparam mult_width = 32;
	
	input [input_width-1:0] A,B;
	input [mult_width-1:0] C;
	output [sum_width-1:0] sum;

	reg [input_width-1:0] reg_A, reg_B 	/* synthesis keep */;
	reg [mult_width-1:0] reg_C 			/* synthesis keep */;
	reg [sum_width-1:0] reg_sum 			/* synthesis keep */;

	always @(posedge clock)
	begin
		reg_A <= A;
		reg_B <= B;
		reg_C <= C;
		reg_sum <= (reg_A + reg_B) * reg_C;
	end
	
	assign sum = reg_sum;
	
endmodule 