module center_light (
  input logic clk, rst,

  // L - True when left key (KEY[3]) is pressed
  // R - True when right key (KEY[0]) is pressed
  // NL - True when the light to the left of this one is ON
  // NR - True when the light on the right of this one is ON
  input logic L, R, NL, NR,

  // lightOn – True when this normal light should be ON/lit
  output logic lightOn
  );
	
  // YOUR CODE GOES HERE

  enum logic {off = 1'b0, on = 1'b1} ps, ns;
  
  always_comb begin
		ns = ps;

			case(ps)
				off: begin
					if 		(NR == 1 & L == 1 & R != 1)	ns = on;
					else if  (NL == 1 & R == 1 & L != 1)	ns = on;
				end
				
				on: begin
					if 		(L == 1 | R == 1)						ns = off;
				end
				
				default: ns = ps;	
			endcase
	end
	
	
	assign lightOn = ps;
	
	
	always_ff @(posedge clk) begin
		
		if (rst) begin
			ps <= on;
		end
		else
			ps <= ns;
	end


endmodule  // normal_light

module center_light_tb();
  logic clk, rst;
  logic L, R, NL, NR;
  logic lightOn;
	
	center_light dut(.*);
  
  // YOUR CODE GOES HERE
  
  // Clock setup
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	initial begin
		
		rst <= 1; 	NR <= 0; 	NL <= 0; 	R <= 0;	L <= 0; 	@(posedge clk);	// Resetting to default - FOR CENTER
																				@(posedge clk);
		rst <= 0; 															@(posedge clk);	
						NR <= 1; 								L <= 1;	@(posedge clk);	// Testing one of the on conditions. Curr State: On
						NR <= 0;												@(posedge clk);
																				@(posedge clk);
																				
														R <= 1;				@(posedge clk);	// off to on condition. Curr state: off
														R <= 0;				@(posedge clk);	// don't wanna instantly go back from on to off. Curr state: on
																				
						NR <= 1; 					R <= 1;				@(posedge clk);	// Testing one of the non-on from off conditions. Curr State: Off
																				@(posedge clk);
																	L <= 1;	@(posedge clk);	// inputs should cancel out - not do anything in off state. Curr state: off
																				@(posedge clk);
																				
						NR <= 0;						R <= 0;	L <= 0;	@(posedge clk);	// return back to 0s. Curr state: off
																				@(posedge clk);
																				
						NR <= 1; 	NL <= 1;								@(posedge clk);	// Should not be possible, but module should do nothing. Curr state: off
																				@(posedge clk);
						
						NR <= 0; 					R <= 1;	L <= 1;	@(posedge clk);	// condition where it should not be on. Curr state: off
																				@(posedge clk);
																	L <= 0;	@(posedge clk); 	// curr state: on
														R <= 0;				@(posedge clk);	// curr state: on
																				@(posedge clk);	
																	
																	L <= 1;	@(posedge clk);	// should turn off. curr state: off
																				@(posedge clk);
																				
										NL <= 0;					L <= 0;	@(posedge clk);
																				@(posedge clk);
																				
		$stop;
	end

endmodule  // normal_light_tb
