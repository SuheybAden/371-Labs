// Suheyb Aden
// 01/15/2022
// Lab #1, Task 1

// This modules reports whether or not a car has
// entered or exited the parking lot based on the inputs a and b
module gatekeeper(clk, reset, a, b, enter, exit);
	input logic clk, reset, a, b;
	output logic enter, exit;
	
	// Defines the states for defining each of the entering
	// and exiting stages
	enum{empty, enter1, enter2, enter3, enter4, exit1, exit2, exit3, exit4} ps, ns;
	
	// Determines the next state of the FSM
	always_comb begin
		case(ps)
			empty:	if(a && !b) ns = enter1;
						else if (!a && b) ns = exit1;
						else ns = empty;
						
			enter1:	if(a && b)	ns = enter2;
						else if(a && !b) ns = enter1;
						else ns = empty;
			enter2:	if(!a && b)	ns = enter3;
						else if(a && b)	ns = enter2;
						else ns = enter1;
			enter3:	if(!a && !b) ns = enter4;
						else if(!a && b)	ns = enter3;
						else ns = enter2;
			enter4:	if(a && !b) ns = enter1;
						else if (!a && b) ns = exit1;
						else ns = empty;
			
			exit1:	if(a && b) ns = exit2;
						else if(!a && b) ns = exit1;
						else ns = empty;
			exit2:	if(a && !b) ns = exit3;
						else if(a && b) ns = exit2;
						else ns = exit1;
			exit3:	if(!a && !b) ns = exit4;
						else if(a && !b) ns = exit3;
						else ns = exit2;
			exit4:	if(a && !b) ns = enter1;
						else if (!a && b) ns = exit1;
						else ns = empty;
			
			default:	ns = empty;
		endcase
	end
	
	// Outputs true if the FSM is at the final enter or exit state
	assign enter = (ns == enter4);
	assign exit = (ns == exit4);
	
	always_ff @(posedge clk) begin
		if(reset) ps <= empty;
		else ps <= ns;
	end
	
endmodule

// Testbench for the gatekeeper module that tests a vehicle fully
// entering and fully exiting as well as backtracking while entering
module gatekeeper_testbench();
	logic clk, reset, a, b, enter, exit;
	
	gatekeeper dut(.clk, .reset, .a, .b, .enter, .exit);
	
	// Set up a simulated clock.   
	parameter CLOCK_PERIOD=100;  
	initial begin   
		clk <= 0;  
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end 
	
	initial begin
		reset <= 0;
		a <= 1;
		b <= 0;	@(posedge clk);
		a <= 1;
		b <= 1;	@(posedge clk);
		a <= 0;
		b <= 1;	@(posedge clk);
		a <= 1;
		b <= 1;	@(posedge clk);
		a <= 0;
		b <= 1;	@(posedge clk);
		a <= 0;
		b <= 0;	@(posedge clk);
		a <= 0;
		b <= 1;	@(posedge clk);
		a <= 1;
		b <= 1;	@(posedge clk);
		a <= 1;
		b <= 0;	@(posedge clk);
		a <= 0;
		b <= 0;	@(posedge clk);
		$stop;	
	end
	
endmodule
