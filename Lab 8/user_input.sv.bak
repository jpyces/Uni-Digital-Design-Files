module user_input(
	input logic in, clk, rst, 
	output logic pressed
	);
	
	logic raw_pressed;
	
	// input synching
	logic synched_input;
	
	synch synchronizer(.clk(clk), .reset(rst), .in(in), .out(synched_input));
	
	// pulse detection
	pulse pulse_detector(.clk(clk), .reset(rst), .in(synched_input), .out(raw_pressed));
	assign pressed = raw_pressed;
	
endmodule

module user_input_tb();
	logic clk, rst, in, pressed;
	
	user_input dut(.*);
	
	// Clock setup
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Actual testing
	initial begin
		rst <= 1;	in <= 0;	@(posedge clk); // reset
		rst <= 0;				@(posedge clk); // 0 going into a
		
						in <= 1; @(posedge clk); // 1 going into a - synchronizer at work
									@(posedge clk); // 1 going into a - sychronizer at work
									@(posedge clk); // pulse detector at work - should get output
									@(posedge clk); // seeing what pulse detector does with sustained input
									@(posedge clk); // seeing what pulse detector does with sustained input
									@(posedge clk); // seeing what pulse detector does with sustained input
									@(posedge clk); // seeing what pulse detector does with sustained input
									
						in <= 0; @(posedge clk); // 0 going into a - synchronizer at work
									@(posedge clk); // 0 going into a - sychronizer at work
									@(posedge clk); // pulse detector at work - should get output
						
						// Checking contiuous behavior
						in <= 1; @(posedge clk); // 1 going into a - synchronizer at work
									@(posedge clk); // 1 going into a - sychronizer at work
									@(posedge clk); // pulse detector at work - should get output
									@(posedge clk); // seeing what pulse detector does with sustained input
									@(posedge clk); // seeing what pulse detector does with sustained input
									@(posedge clk); // seeing what pulse detector does with sustained input
									@(posedge clk); // seeing what pulse detector does with sustained input
						
		$stop;
	end
endmodule
