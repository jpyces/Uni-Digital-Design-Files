module state_display (
	input logic rst,
	input logic win,
	input logic endGame,
	output logic [6:0] display3, display4, display5
);

	always_comb begin
		if (rst) begin
			display5 = 7'b0001000;
			display4 = 7'b0010010;
			display3 = 7'b0111011;
		end
		
		else if (!rst && !win && !endGame) begin
			display5 = 7'b0001110;
			display4 = 7'b1000111;
			display3 = 7'b0010001;
		end
		
		else if (!rst && endGame && !win) begin
			display5 = 7'b1111111;
			display4 = 7'b1000111;
			display3 = 7'b1111111;
		end
		
		else if (!rst && endGame && win) begin
			display5 = 7'b1011011;
			display4 = 7'b1011011;
			display3 = 7'b1101101;
		end
		
		else begin
			display5 = 7'b0001110;
			display4 = 7'b1000111;
			display3 = 7'b0010001;
		end
	end
	
endmodule


module state_display_tb();

endmodule
