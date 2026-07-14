module upc_display (
	input logic U, P, C,
	output logic [6:0] m0, m1, m2, m3, m4, m5
	);
	
	logic [2:0] UPC; 
	assign UPC = {U, P, C};
	
	enum logic [6:0] {
		S = 7'b0010010,
		D = 7'b1000000,
		F = 7'b0001110,
		G = 7'b0000010,
		T = 7'b1111000,
		H = 7'b0001001,
		i = 7'b1101111,
		E = 7'b0000110,
		A = 7'b0001000,
		O = 7'b0000000,
		NO = 7'b1111111,
		L = 7'b1000111,
		n = 7'b0101011
	} constants;
	
	
	always_comb begin
		// Default
			m0 = O;
			m1 = D;
			m2 = D;
			m3 = O;
			m4 = S;
			m5 = NO;
				
		case(UPC)
		
			3'b000: begin
				m0 = S;
				m1 = i;
				m2 = L;
				m3 = NO;
				m4 = NO;
				m5 = NO;
			end
			
			3'b001: begin
				m0 = D;
				m1 = E;
				m2 = O;
				m3 = NO;
				m4 = NO;
				m5 = NO;
			end
			
			3'b011: begin
				m0 = F;
				m1 = A;
				m2 = n;
				m3 = NO;
				m4 = NO;
				m5 = NO;
			end
			
			3'b100: begin
				m0 = G;
				m1 = O;
				m2 = L;
				m3 = D;
				m4 = NO;
				m5 = NO;
			end
			
			3'b101: begin
				m0 = T;
				m1 = E;
				m2 = E;
				m3 = NO;
				m4 = NO;
				m5 = NO;
			end
			
			3'b110: begin
				m0 = H;
				m1 = A;
				m2 = T;
				m3 = NO;
				m4 = NO;
				m5 = NO;
			end
			
			default: begin
				m0 = D;
				m1 = D;
				m2 = D;
				m3 = D;
				m4 = D;
				m5 = D;
			end
		endcase
	end
endmodule

module upc_display_tb ();
	logic U, P, C;
	logic [6:0] m0, m1, m2, m3, m4, m5;
	
	upc_display UPCDdut (.*);
	
	initial begin
		for (int i = 0; i < 8; i++) begin 
			{U, P, C} = i; #20;
		end
		$stop;
	end
	
endmodule
