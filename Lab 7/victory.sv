module victory(
	input logic p1win, p2win, rst, clk, 
	output logic [6:0] display,
	output logic win
	);
	
	enum logic [6:0] {ZERO = 7'b1111111, p1w = 7'b1111001, p2w = 7'b0100100} ps, ns;
	logic win_ns;
	
	always_comb begin
		ns = ps;
		win_ns = (ps != ZERO);	// not in zero implies someone won
		
		case (ps)
			ZERO: begin
				if 		(p1win == 1 & p2win != 1)	begin
					ns = p1w;
					win_ns = 1;
				end
				
				else if 	(p2win == 1 & p1win != 1)	begin
					ns = p2w;
					win_ns = 1;
				end
			end
			
			default: ns = ps;
		endcase
		
	end
	
	assign display = ps;
	
	always_ff @(posedge clk) begin
		if (rst) begin
			ps <= ZERO;
			win <= 1'b0;
		end
		else begin
			ps <= ns;
			win <= win_ns;
		end
	end
	
	

	
endmodule

module victory_tb();
	logic p1win, p2win, rst, clk, win;
	logic [6:0] display;
	
	victory win_detector(.p2win(p2win), .p1win(p1win), .rst(rst), .clk(clk), .display(display), .win(win));
	
	// Clock setup
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		rst <= 1;	win <= 0;	p1win <= 0;		p2win <= 0; @(posedge clk);	// defaults
															@(posedge clk);
										
		rst <= 0;										@(posedge clk);
															@(posedge clk);
					
						p1win <= 1;						@(posedge clk); 	// curr state: p1w
															@(posedge clk);
											p2win <= 1; @(posedge clk);
															@(posedge clk);
						p1win <= 0;						@(posedge clk);
															@(posedge clk);
											p2win <= 0; @(posedge clk);
															@(posedge clk);
															
		rst <= 1;	p1win <= 0;		p2win <= 0; @(posedge clk);	// defaults
															@(posedge clk);
		rst <= 0;										@(posedge clk);
															@(posedge clk);
											p2win <= 1;	@(posedge clk);	// curr state: p2w
															@(posedge clk);
						p1win <= 1;						@(posedge clk);
															@(posedge clk);
															
						p1win <= 0;						@(posedge clk);
															@(posedge clk);
											p2win <= 0; @(posedge clk);
															@(posedge clk);
										
		$stop;
	end

endmodule
