module multpath(clock_333, clock_666, A, B, sum);
	
	localparam  input_width = 4;
	localparam  sum_width   = 5;
	
	input 	   clock_333;
	input 	   clock_666; //twice as fast as clock_333
	input 	  [input_width-1:0] A,B;
	reg 		  [input_width-1:0] reg_A, reg_B;
	output reg [sum_width-1:0]   sum;
	wire       [sum_width-1:0]   reg_sum;	
	wire enable;
	
	always @(posedge clock_333)
	begin
		reg_A <= A;
		reg_B <= B;
	end

	assign reg_sum = reg_A + reg_B;	
	
	always @(posedge clock_666)
	begin
			sum <= reg_sum;
	end	
	
endmodule 