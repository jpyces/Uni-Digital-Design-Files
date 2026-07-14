module tug_of_war #(
	parameter whichClock = 0
	)
	(
	input		logic			CLOCK_50,  // 50MHz clock
	input 	logic [3:0] KEY,
	input		logic [9:0] SW,
	output	logic [6:0] HEX0,
	output	logic [9:0] LEDR
	);
	
	
	// Generate clock
//	logic [31:0] clock;
//	clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(clock));
	
	// Weird reset switch flickering
	logic reset_raw;
	logic rst;
	always_ff @(posedge CLOCK_50) begin
		reset_raw 	<= SW[9];
		rst 			<= reset_raw;
	end
	
	logic clk;
	assign clk = CLOCK_50;
	assign LEDR[0] = clk;  // clock debugger
	
	// intermediate signals
	logic pressed1, pressed2, endGame1, endGame2;

	// useful enum and constants
	enum logic {FALSE = 1'b0, TRUE = 1'b1} constants;
	logic win;
	
	// user input modules
	user_input input1(.pressed(pressed1),.clk(clk), .rst(rst), .in(~KEY[0]), .win(win));
	user_input input2(.pressed(pressed2),.clk(clk), .rst(rst), .in(~KEY[3]), .win(win));

	// light modules
	
	// edge light modules
	normal_light_rightmost 	rightmost(.lightOn(LEDR[1]), .clk(clk), .rst(rst), .L(pressed2), .R(pressed1), .NL(LEDR[2]), .endGame(endGame1));
	normal_light_leftmost 	leftmost(.lightOn(LEDR[9]), .clk(clk), .rst(rst), .L(pressed2), .R(pressed1), .NR(LEDR[8]), .endGame(endGame2));
	
	// LED 2
	normal_light	light2(.lightOn(LEDR[2]), .clk(clk), .rst(rst), .L(pressed2), .R(pressed1), .NL(LEDR[3]), .NR(LEDR[1]));
	
	// LED 3
	normal_light	light3(.lightOn(LEDR[3]), .clk(clk), .rst(rst), .L(pressed2), .R(pressed1), .NL(LEDR[4]), .NR(LEDR[2]));
	
	// LED 4
	normal_light	light4(.lightOn(LEDR[4]), .clk(clk), .rst(rst), .L(pressed2), .R(pressed1), .NL(LEDR[5]), .NR(LEDR[3]));
	
	//
	// LED 5 - CENTER
	center_light	light5(.lightOn(LEDR[5]), .clk(clk), .rst(rst), .L(pressed2), .R(pressed1), .NL(LEDR[6]), .NR(LEDR[4]));
	//
	//
	
	// LED 6
	normal_light	light6(.lightOn(LEDR[6]), .clk(clk), .rst(rst), .L(pressed2), .R(pressed1), .NL(LEDR[7]), .NR(LEDR[5]));
	
	// LED 7
	normal_light	light7(.lightOn(LEDR[7]), .clk(clk), .rst(rst), .L(pressed2), .R(pressed1), .NL(LEDR[8]), .NR(LEDR[6]));
	
	// LED 8
	normal_light	light8(.lightOn(LEDR[8]), .clk(clk), .rst(rst), .L(pressed2), .R(pressed1), .NL(LEDR[9]), .NR(LEDR[7]));
	
	
	// victory
	victory winner_detector(.p1win(endGame1), .p2win(endGame2), .clk(clk), .rst(rst), .display(HEX0), .win(win));
	
endmodule

module tug_of_war_tb();

	logic clk;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [6:0] HEX0;
	logic [9:0] LEDR;
	
	tug_of_war dut (
		.CLOCK_50(clk),
		.KEY(KEY),
		.SW(SW),
		.HEX0(HEX0),
		.LEDR(LEDR)
	);
	

	parameter CLOCK_PERIOD = 20;
	initial begin
		clk = 0;
		forever #(CLOCK_PERIOD/2) clk = ~clk;
	end

	initial begin
		SW[9] <= 1;	KEY[0] <= 1; KEY[3] <= 1;	repeat(10) @(posedge clk);
		SW[9]	<= 0;										repeat(10) @(posedge clk);
		
		repeat(5) begin
			KEY[0] <= 0;					repeat(4) @(posedge clk);
			KEY[0] <= 1;					repeat(4) @(posedge clk);
		end
		
		
		SW[9] <= 1;	KEY[0] <= 1; KEY[3] <= 1;	repeat(10) @(posedge clk);
		SW[9]	<= 0;										repeat(10) @(posedge clk);
		
		repeat(5) begin
			KEY[3] <= 0;					repeat(4) @(posedge clk);
			KEY[3] <= 1;					repeat(4) @(posedge clk);
		end
		
		
	$stop;
	end
endmodule

