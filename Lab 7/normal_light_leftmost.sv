module normal_light_leftmost (
	input logic clk, rst,

  // L - True when left key (KEY[3]) is pressed
  // R - True when right key (KEY[0]) is pressed
  // NR - True when the light to the right of this one is ON
  input logic L, R, NR,

  // lightOn – True when this normal light should be ON/lit
  output logic lightOn, endGame
	);
	
	enum logic {off = 1'b0, on = 1'b1} ps, ns;
	
	always_comb begin
			endGame = 0;
			ns = ps;
			case(ps)
				
				off: begin
					if	(NR == 1 & L == 1)	ns = on;
				end	
				
				on: begin
					if (L == 1) begin
						ns = off;
						endGame = 1;
					end
					else if (R == 1) ns = off;
				end
				
				default: ns = ps;
			endcase
	end
	
	
	assign lightOn = ps;
	
	
	always_ff @(posedge clk) begin
		if (rst) begin
			ps <= off;
		end
		else 
			ps <= ns;
	end

endmodule

module normal_light_leftmost_tb();
	logic clk, rst;
	logic L, R, NR;
	logic lightOn, endGame;
	
	normal_light_leftmost dut(.*);
  
	// YOUR CODE GOES HERE
  
	// Clock setup
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	initial begin
		rst <= 1;	L <= 0;	R <= 0;	NR <= 0;	@(posedge clk);	// defaults
															@(posedge clk);	
		rst <= 0;										@(posedge clk);
															@(posedge clk);	// curr state: off
															
						L <= 1;							@(posedge clk);	
															@(posedge clk);
															
						L <= 0;	R <= 1; 				@(posedge clk);
															@(posedge clk);
							
												NR <= 1;	@(posedge clk);
															@(posedge clk);	// curr state: off
															
									R <= 0; 				@(posedge clk);
															@(posedge clk);
															
						L <= 1;							@(posedge clk);	// curr state: on
						L <= 0;									@(posedge clk);	
						L <= 1;									@(posedge clk);
															@(posedge clk);
									
									R <= 1;				@(posedge clk);
															@(posedge clk);
														
												NR <= 0; @(posedge clk);
															@(posedge clk);
															
						L <= 0;	R <= 0;	NR <= 0;	@(posedge clk);
															@(posedge clk);
															
						L <= 0;	R <= 1; 				@(posedge clk);
															@(posedge clk);
							
												NR <= 1;	@(posedge clk);
															@(posedge clk);	// curr state: off
															
									R <= 0; 				@(posedge clk);
															@(posedge clk);
															
						L <= 1;							@(posedge clk);	// curr state: on
															@(posedge clk);	// should never turn back - player has won!!
															@(posedge clk);
															@(posedge clk);
									
									R <= 1;				@(posedge clk);
															@(posedge clk);
														
												NR <= 0; @(posedge clk);
															@(posedge clk);
															
						L <= 0;	R <= 0;	NR <= 0;	@(posedge clk);
		$stop;	
	end
endmodule

