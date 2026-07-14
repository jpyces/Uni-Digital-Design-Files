module runway_lightsFSM(
	input logic [1:0] SW, 
	input logic clk, reset,
	output logic [2:0] out
	);
	
	enum logic [2:0] {A = 3'b101, B = 3'b010, C = 3'b001, D = 3'b100} ps, ns;
	
	always_comb begin
		case (ps)	 
			A: begin
				if 		(SW == 2'b00) 	ns = B;
				else if	(SW == 2'b01) 	ns = C;
				else if	(SW == 2'b10) 	ns = D;
				else 							ns = A;
			end
			
			B: begin
				if 		(SW == 2'b00) 	ns = A;
				else if	(SW == 2'b01) 	ns = D;
				else if	(SW == 2'b10) 	ns = C;
				else 							ns = B;
			end
			
			C: begin
				if 		(SW == 2'b00) 	ns = A;
				else if	(SW == 2'b01) 	ns = B;
				else if	(SW == 2'b10) 	ns = D;
				else 							ns = C;
			end
			
			D: begin
				if 		(SW == 2'b00) 	ns = A;
				else if	(SW == 2'b01) 	ns = C;
				else if	(SW == 2'b10) 	ns = B;
				else 							ns = D;
			end
			
			default:
				ns = ps;
		endcase			
	end
	
	assign out = ps;
	
	always_ff @(posedge clk) begin
		if (reset)
			ps <= A;
		else
			ps <= ns;
	end
	
endmodule

module runway_lightsFSM_tb ();
	logic clk, reset;
	logic [1:0] SW;
	logic [2:0] out;
	
	runway_lightsFSM dut(.*);
	
	// Set up the clock
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; SW[1:0] <= 2'b00; @(posedge clk);	// reset
		reset <= 0;							@(posedge clk);	// curr state: A
												@(posedge clk);	// curr state: B
												@(posedge clk);	// curr state: A
												@(posedge clk);	// curr state: B
												@(posedge clk);	// curr state: A
												
						SW[1:0] <= 2'b01;	@(posedge clk);	// curr state: C
												@(posedge clk);	// curr state: B
												@(posedge clk);	// curr state: D
												@(posedge clk);	// curr state: C
												@(posedge clk);	// curr state: B
												@(posedge clk);	// curr state: D
						
						SW[1:0] <= 2'b00;	@(posedge clk);	// curr state: A
						
						SW[1:0] <= 2'b10;	@(posedge clk);	// curr state: D
												@(posedge clk);	// curr state: B
												@(posedge clk);	// curr state: C
												@(posedge clk);	// curr state: D
												@(posedge clk);	// curr state: B
												@(posedge clk);	// curr state: C
						
						SW[1:0] <= 2'b00;	@(posedge clk);	// curr state: A
		$stop;
	end
endmodule
