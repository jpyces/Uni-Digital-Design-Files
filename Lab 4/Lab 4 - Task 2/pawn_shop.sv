module pawn_shop (
	input logic [9:0] SW,
	output logic [9:0] LEDR,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
	);
	
	Nordstrom nord(.U(SW[9]), .P(SW[8]), .C(SW[7]), .Mark(SW[0]), .Discounted(LEDR[9]), .Stolen(LEDR[0]));
	
	upc_display display(.U(SW[9]), .P(SW[8]), .C(SW[7]), .m0(HEX5), .m1(HEX4), .m2(HEX3), .m3(HEX2), .m4(HEX1), .m5(HEX0));

endmodule

module pawn_shop_tb();
	logic [9:0] SW, LEDR;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	pawn_shop PSdut(.*);
		
	initial begin
		for (int i = 0; i < 8; i++) begin
			{SW[9], SW[8], SW[7]} = i; SW[0] = 0; #20;
									SW[0] = 1; #20;
		end
		$stop;
	end
endmodule
