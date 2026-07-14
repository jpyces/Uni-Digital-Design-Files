module double_seg7 (
	input logic [7:0] SW , 
	output logic [6:0] HEX0, 
	output logic [6:0] HEX1
	);
	
	logic [6:0] hex0_signal, hex1_signal;
	
	seg7 seg1(.bcd(SW[3:0]), .leds(hex0_signal));
	seg7 seg2(.bcd(SW[7:4]), .leds(hex1_signal));
	
	assign HEX0 = ~hex0_signal;
	assign HEX1 = ~hex1_signal;
	

endmodule

module double_seg7_tb ();

		// Necessary ports
		logic SW[7:0]; 
		logic [6:0] HEX0, HEX1;
		
		// DUT Instantiation
		double_seg7 dut (.SW(SW), .HEX0(HEX0), .HEX1(HEX1));
		
		int i;
		initial begin
			for (i = 0; i < 256; i++) begin 
				SW[7:0] = i; #20;
			end
			$stop;
		end
endmodule
