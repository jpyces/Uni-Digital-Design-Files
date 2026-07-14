module hex_decoder (
	input logic [3:0] data,
	output logic [6:0] display
);
	always_comb begin
		case (data)
			4'h0: display = 7'b1000000;
			4'h1: display = 7'b1111001;
			4'h2: display = 7'b0100100;
			4'h3: display = 7'b0110000;
			4'h4: display = 7'b0011001;
			4'h5: display = 7'b0010010;
			4'h6: display = 7'b0000010;
			4'h7: display = 7'b1111000;
			4'h8: display = 7'b0000000;
			4'h9: display = 7'b0011000;
			default: display = 7'b1111111;
		endcase
	end

endmodule

module hex_decoder_tb ();
	logic [3:0] data;
	logic [6:0] display;
	
	hex_decoder seg_display(.*);
	
	initial begin
		for (int i = 0; i < 10; i++) begin
			data = i; #10;
		end
	end

endmodule
