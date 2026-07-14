module user_input(
	input 	logic clk, rst, key0, key1, key2, key3,
	output 	logic [3:0]	dir
	);
	
	//logic raw_pressed0, raw_pressed1, raw_pressed2, raw_pressed3;	// synched keypresses - to be pulsed after synching
	logic synched_key0, synched_key1, synched_key2, synched_key3;	// raw keypresses that are synched
	logic pressed0, pressed1, pressed2, pressed3;
	logic [3:0] dir_next;
	
	// 2 clock cycle delay
	synch synchronizer0(.clk(clk), .reset(rst), .in(key0), .out(synched_key0));
	synch synchronizer1(.clk(clk), .reset(rst), .in(key1), .out(synched_key1));
	synch synchronizer2(.clk(clk), .reset(rst), .in(key2), .out(synched_key2));
	synch synchronizer3(.clk(clk), .reset(rst), .in(key3), .out(synched_key3));

	
	
	// 2 total clock cycle delay for user_input
	
	always_comb begin
		pressed0 = synched_key0;
		pressed1 = synched_key1;
		pressed2 = synched_key2;
		pressed3 = synched_key3;

		if	(
			pressed0 && pressed1 || pressed0 && pressed2 || pressed0 && pressed3 ||
			pressed1 && pressed2 || pressed1 && pressed3 ||
			pressed2 && pressed3
		)	begin
			pressed0 = 0;
			pressed1 = 0;
			pressed2 = 0;
			pressed3 = 0;
		end
	end
	
	assign dir_next = {pressed0, pressed1, pressed2, pressed3};
	
	always_ff @(posedge clk) begin
		if (rst) dir <= 4'b0000;
		else if (dir_next != 4'b0000) dir <= dir_next;
		else dir <= dir;
	end

	//assign dir = {pressed0, pressed1, pressed2, pressed3};
	
	

	
endmodule

module user_input_tb();
	logic clk, rst, key0, key1, key2, key3;
	logic [3:0] dir;
	
	user_input dut(.*);
	
	// Clock setup
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Actual testing
	initial begin
		rst <= 1;	key0 <= 0;	key1 <= 0;	key2 <= 0;	key3 <= 0;	@(posedge clk); // reset
		rst <= 0;																	@(posedge clk);
		
		repeat(2) @(posedge clk);
			
						key0 <= 1;													repeat(3) @(posedge clk);
						key0 <= 0;	key1 <= 1;									repeat(3) @(posedge clk);
										key1 <= 0;	key2 <= 1;					repeat(3) @(posedge clk);
														key2 <= 0;	key3 <= 1;	repeat(3) @(posedge clk);
						
						key0 <= 1;	key1 <= 1;	key2 <= 1;	key3 <= 1;	repeat(3) @(posedge clk);
		$stop;	
	end
endmodule
