module cyber_war #(
	parameter whichClock = 15
	)
	(
	input		logic			CLOCK_50,  // 50MHz clock
	input 	logic [3:0] KEY,
	input		logic [9:0] SW,
	output	logic [6:0] HEX0, HEX5,
	output	logic [9:0] LEDR
	);
	
	
	// Generate clock
	logic [31:0] divided_clocks;
	clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(divided_clocks));
	logic clk;
	assign clk = divided_clocks[whichClock];
	// Weird reset switch flickering
	logic reset_raw;
	logic rst;
	always_ff @(posedge CLOCK_50) begin
		reset_raw 	<= SW[9];
		rst 			<= reset_raw;
	end
	
	/*
	logic clk;
	assign clk = CLOCK_50;*/
	assign LEDR[0] = clk;  // clock debugger
	
	// intermediate signals
	logic pressed1, pressed2, endGame1, endGame2;

	// useful enum and constants
	enum logic {FALSE = 1'b0, TRUE = 1'b1} constants;
	logic playfield_rst;
	//logic win;
	
	// user input modules
	user_input input1(.pressed(pressed1),.clk(clk), .rst(rst), .in(~KEY[0]));
	//user_input input2(.pressed(pressed2),.clk(clk), .rst(rst), .in(~KEY[3]));
	presser		computer_player(.clk(clk), .rst(rst), .tune(SW[8:0]), .press(pressed2));

	// light modules
	
	// edge light modules
	normal_light_rightmost 	rightmost(.lightOn(LEDR[1]), .clk(clk), .rst(playfield_rst), .L(pressed2), .R(pressed1), .NL(LEDR[2]), .endGame(endGame1));
	normal_light_leftmost 	leftmost(.lightOn(LEDR[9]), .clk(clk), .rst(playfield_rst), .L(pressed2), .R(pressed1), .NR(LEDR[8]), .endGame(endGame2));
	
	// LED 2
	normal_light	light2(.lightOn(LEDR[2]), .clk(clk), .rst(playfield_rst), .L(pressed2), .R(pressed1), .NL(LEDR[3]), .NR(LEDR[1]));
	
	// LED 3
	normal_light	light3(.lightOn(LEDR[3]), .clk(clk), .rst(playfield_rst), .L(pressed2), .R(pressed1), .NL(LEDR[4]), .NR(LEDR[2]));
	
	// LED 4
	normal_light	light4(.lightOn(LEDR[4]), .clk(clk), .rst(playfield_rst), .L(pressed2), .R(pressed1), .NL(LEDR[5]), .NR(LEDR[3]));
	
	//
	// LED 5 - CENTER
	center_light	light5(.lightOn(LEDR[5]), .clk(clk), .rst(playfield_rst), .L(pressed2), .R(pressed1), .NL(LEDR[6]), .NR(LEDR[4]));
	//
	//
	
	// LED 6
	normal_light	light6(.lightOn(LEDR[6]), .clk(clk), .rst(playfield_rst), .L(pressed2), .R(pressed1), .NL(LEDR[7]), .NR(LEDR[5]));
	
	// LED 7
	normal_light	light7(.lightOn(LEDR[7]), .clk(clk), .rst(playfield_rst), .L(pressed2), .R(pressed1), .NL(LEDR[8]), .NR(LEDR[6]));
	
	// LED 8
	normal_light	light8(.lightOn(LEDR[8]), .clk(clk), .rst(playfield_rst), .L(pressed2), .R(pressed1), .NL(LEDR[9]), .NR(LEDR[7]));
	
	
	// victory
	//victory winner_detector(.p1win(endGame1), .p2win(endGame2), .clk(clk), .rst(rst), .display(HEX0), .win(win));
	scoreboard		scorer(.clk(clk), .rst(rst), .p1win(endGame1), .p2win(endGame2), .playfield_rst(playfield_rst), .display0(HEX0), .display1(HEX5));
	
endmodule


module cyber_war_tb();

    logic CLOCK_50;
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [6:0] HEX0, HEX5;
    logic [9:0] LEDR;

    cyber_war #(.whichClock(0)) dut(
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .SW(SW),
        .HEX0(HEX0),
        .HEX5(HEX5),
        .LEDR(LEDR)
    );

    parameter CLOCK_PERIOD = 100;
    initial begin
        CLOCK_50 = 0;
        forever #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50;
    end

    initial begin
        // Initialize
        SW <= 10'b0; KEY <= 4'b1111; repeat(10) @(posedge CLOCK_50);

        // Full reset
        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Human player pressing ===
        $display("=== Human player pressing ===");
        SW[8:0] <= 9'b000000000;
        repeat(5) begin
            KEY[0] <= 0; repeat(4) @(posedge CLOCK_50);
            KEY[0] <= 1; repeat(4) @(posedge CLOCK_50);
            $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);
        end

        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Difficulty 1: SW[0] only ===
        $display("=== Difficulty 1: SW[0] only ===");
        SW[8:0] <= 9'b000000001;
        repeat(20) @(posedge CLOCK_50);
        $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);

        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Difficulty 2: SW[1:0] ===
        $display("=== Difficulty 2: SW[1:0] ===");
        SW[8:0] <= 9'b000000011;
        repeat(20) @(posedge CLOCK_50);
        $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);

        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Difficulty 3: SW[2:0] ===
        $display("=== Difficulty 3: SW[2:0] ===");
        SW[8:0] <= 9'b000000111;
        repeat(20) @(posedge CLOCK_50);
        $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);

        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Difficulty 4: SW[3:0] ===
        $display("=== Difficulty 4: SW[3:0] ===");
        SW[8:0] <= 9'b000001111;
        repeat(20) @(posedge CLOCK_50);
        $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);

        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Difficulty 5: SW[4:0] ===
        $display("=== Difficulty 5: SW[4:0] ===");
        SW[8:0] <= 9'b000011111;
        repeat(20) @(posedge CLOCK_50);
        $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);

        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Difficulty 6: SW[5:0] ===
        $display("=== Difficulty 6: SW[5:0] ===");
        SW[8:0] <= 9'b000111111;
        repeat(20) @(posedge CLOCK_50);
        $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);

        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Difficulty 7: SW[6:0] ===
        $display("=== Difficulty 7: SW[6:0] ===");
        SW[8:0] <= 9'b001111111;
        repeat(20) @(posedge CLOCK_50);
        $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);

        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Difficulty 8: SW[7:0] ===
        $display("=== Difficulty 8: SW[7:0] ===");
        SW[8:0] <= 9'b011111111;
        repeat(20) @(posedge CLOCK_50);
        $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);

        SW[9] <= 1; repeat(10) @(posedge CLOCK_50);
        SW[9] <= 0; repeat(10) @(posedge CLOCK_50);

        // === Difficulty 9: SW[8:0] all high (hardest) ===
        $display("=== Difficulty 9: SW[8:0] max ===");
        SW[8:0] <= 9'b111111111;
        repeat(20) @(posedge CLOCK_50);
        $display("LEDR=%b HEX0=%b HEX5=%b", LEDR, HEX0, HEX5);

        $stop;
    end
endmodule


