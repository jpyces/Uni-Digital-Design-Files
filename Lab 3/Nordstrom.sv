module Nordstrom (
	//	Ports
	input logic U, P, C, Mark,
	output logic Discounted, Stolen
	);
	
	// Discount Circuit
	logic UC;
	assign UC = (U & C);
	assign Discounted = UC | P;
	
	// Stolen Circuit
	logic Unor_notC;
	assign Unor_notC = ~(U | ~C);
	assign Stolen = ~(Unor_notC | P | Mark);
	
endmodule

module Nordstrom_tb ();
	
	// Necessary ports
	logic U, P, C, Mark, Discounted, Stolen;
		
	// DUT instantiation
	Nordstrom dut (.U(U), .P(P), .C(C), .Mark(Mark), .Discounted(Discounted), .Stolen(Stolen));
	
	int i;
	initial begin
	
		for (i = 0; i < 8; i++) begin
			{U, P, C} = i; #10;
			
			Mark = 0; #20;
			Mark = 1; #20;
		end
		$stop;
	end	
	
endmodule
