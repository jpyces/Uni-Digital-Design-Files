module lab8 #(
    parameter MAX_LENGTH    = 64,
    parameter TICKS_PER_SEC = 4,
    parameter CLK_FREQ      = 50_000_000
)(
    input  logic        CLOCK_50,
    input  logic [9:0]  SW,
    //input  logic [3:0]  KEY,
    output logic [35:0] GPIO_1,
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,

    // NES Controller Hardware Ports
    output logic        nes_latch_out,
    output logic        nes_clock_out,
    input  logic        nes_data
);
    logic clk;
    assign clk = CLOCK_50;

    // -------------------------------------------------------------------------
    // Internal signals
    // -------------------------------------------------------------------------
    logic game_tick, game_rst, endGame, win;
    logic eaten, suicide, board_edge;
    logic [3:0] dir;
    logic [3:0] next_x, next_y, apple_x, apple_y;
    logic [7:0] snake_array [0:MAX_LENGTH-1];
    logic [7:0] snake_len;

    // -------------------------------------------------------------------------
    // NES enable divider: one strobe every 12500 cycles = 4 kHz on 50 MHz
    // -------------------------------------------------------------------------
    localparam NES_DIV = CLK_FREQ / 4000;
    logic [$clog2(NES_DIV)-1:0] nes_div_count;
    logic nes_enable;
    always_ff @(posedge clk) begin
        if (game_rst) begin
            nes_div_count <= '0;
            nes_enable    <= 1'b0;
        end else begin
            nes_enable <= 1'b0;
            if (nes_div_count == NES_DIV - 1) begin
                nes_div_count <= '0;
                nes_enable    <= 1'b1;
            end else begin
                nes_div_count <= nes_div_count + 1'b1;
            end
        end
    end

    // -------------------------------------------------------------------------
    // 2-stage CDC synchronizer for nes_data
    // -------------------------------------------------------------------------
    logic nes_data_ff0, nes_data_ff1;
    always_ff @(posedge clk) begin
        nes_data_ff0 <= nes_data;
        nes_data_ff1 <= nes_data_ff0;
    end

    // -------------------------------------------------------------------------
    // NES controller button bus
    // -------------------------------------------------------------------------
    logic [7:0] nes_buttons;
    logic nes_up, nes_down, nes_left, nes_right;
    assign nes_up    = ~nes_buttons[6];
    assign nes_down  = ~nes_buttons[7];
    assign nes_left  = ~nes_buttons[4];
    assign nes_right = ~nes_buttons[5];

    // -------------------------------------------------------------------------
    // Submodule instantiations
    // -------------------------------------------------------------------------
    logic [8:0] switches_raw, switches;
    always_ff @(posedge clk) begin
        switches_raw <= SW[8:0];
        switches     <= switches_raw;
    end

    game_tick_gen #(
        .TICKS_PER_SEC(TICKS_PER_SEC),
        .CLK_FREQ     (CLK_FREQ)
    ) ticker (
        .clk      (clk),
        .rst      (game_rst),
        .game_tick(game_tick),
        .switches (switches)
    );

    user_input ui (
        .clk (clk),
        .rst (game_rst),
        .key0(nes_left),
        .key1(nes_right),
        .key2(nes_up),
        .key3(nes_down),
        .dir (dir)
    );

    nes_controller_driver nes_driver (
        .clk          (clk),
        .rst          (game_rst),
        .nes_enable   (nes_enable),
        .nes_data_sync(nes_data_ff1),
        .latch_out    (nes_latch_out),
        .clk_out      (nes_clock_out),
        .buttons      (nes_buttons)
    );

    game_state #(.MAX_SNAKE_LENGTH(MAX_LENGTH)) gs (
        .suicide   (suicide),
        .rst       (SW[9]),
        .snake_len (snake_len),
        .game_rst  (game_rst),
        .game_tick (game_tick),
        .endGame   (endGame),
        .win       (win),
        .clk       (clk),
        .board_edge(board_edge),
		  .display3(HEX3), .display4(HEX4), .display5(HEX5)
    );

    logic eaten_latch;
    always_ff @(posedge clk) begin
        if (game_rst)       eaten_latch <= 0;
        else if (game_tick) eaten_latch <= eaten;
        else if (eaten)     eaten_latch <= 1;
    end

    snake #(.MAX_LENGTH(MAX_LENGTH)) sn (
        .endGame    (endGame),
        .board_edge (board_edge),
        .eaten      (eaten_latch),
        .game_rst   (game_rst),
        .game_tick  (game_tick),
        .clk        (clk),
        .dir        (dir),
        .snake_array(snake_array),
        .snake_len  (snake_len)
    );

    apple #(.MAX_LENGTH(MAX_LENGTH)) ap (
        .endGame    (endGame),
        .game_rst   (game_rst),
        .eaten      (eaten),
        .clk        (clk),
        .snake_array(snake_array),
        .snake_len  (snake_len),
        .apple_x    (apple_x),
        .apple_y    (apple_y)
    );

    logic endGame_reg;
    always_ff @(posedge clk) begin
        if (game_rst) endGame_reg <= 1'b0;
        else          endGame_reg <= endGame;
    end

    collision_detector #(.MAX_LENGTH(MAX_LENGTH)) cd (
        .endGame    (endGame_reg),
        .rst        (game_rst),
        .snake_array(snake_array),
        .snake_len  (snake_len),
        .apple_x    (apple_x),
        .apple_y    (apple_y),
        .eaten      (eaten),
        .suicide    (suicide)
    );

    // -------------------------------------------------------------------------
    // LED: combinational driver -> latch outputs one cycle after game_tick
    // so snake_array has fully settled from non-blocking assignments
    // -------------------------------------------------------------------------
    logic [15:0][15:0] RedPixels_comb, GreenPixels_comb;
    logic [15:0][15:0] RedPixels, GreenPixels;

    LED_Board_Driver #(.MAX_LENGTH(MAX_LENGTH)) led (
        .game_rst   (game_rst),
        .apple_x    (apple_x),
        .apple_y    (apple_y),
        .snake_array(snake_array),
        .snake_len  (snake_len),
        .RedPixels  (RedPixels_comb),
        .GreenPixels(GreenPixels_comb)
    );

    logic latch_pixels;
    always_ff @(posedge clk) begin
        latch_pixels <= game_tick;
    end

    always_ff @(posedge clk) begin
        if (game_rst) begin
            RedPixels   <= '0;
            GreenPixels <= '0;
        end else if (latch_pixels) begin
            RedPixels   <= RedPixels_comb;
            GreenPixels <= GreenPixels_comb;
        end
    end

    LEDDriver #(.FREQDIV(15)) display (
        .CLK        (clk),
        .RST        (game_rst),
        .EnableCount(1'b1),
        .RedPixels  (RedPixels),
        .GrnPixels  (GreenPixels),
        .GPIO_1     (GPIO_1)
    );

    score_display scorer (
        .snake_len(snake_len),
        .display0 (HEX0),
        .display1 (HEX1),
        .display2 (HEX2)
    );
	 
//	 state_display ga_state (
//			.rst(SW[9]),
//			.win(win),
//			.endGame(endGame),
//			.display3(HEX3), .display4(HEX4), .display5(HEX5)
//	 );

endmodule

 


module lab8_tb ();

    logic        CLOCK_50;
    logic [9:0]  SW;
    logic [35:0] GPIO_1;
    logic        nes_latch_out;
    logic        nes_clock_out;
    logic        nes_data;
    logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // baseline head position captured after reset+first tick
    logic [3:0]  head_x0, head_y0;
    logic [3:0]  x_pre_turn;
    logic [3:0]  x_before;
    int          steps_left;
    int          hit, grew, edge_count;
    int          t_start, t_end, measured;

    // -------------------------------------------------------------------------
    // Simulation parameters
    // NES_DIV = CLK_FREQ/4000 = 2. Full NES packet = 18*2 = 36 cycles.
    // Need CDC(2) + user_input sync(2) to settle before game_tick samples dir.
    // CYCLES_PER_TICK=80 gives 44 cycles of margin after the 36-cycle packet.
    // CLK_FREQ=8000, TICKS_PER_SEC=100 -> CYCLES_PER_TICK=80, NES_DIV=2.
    // -------------------------------------------------------------------------
    localparam TB_CLK_FREQ     = 8_000;
    localparam TB_TICKS_SEC    = 100;
    localparam CYCLES_PER_TICK = TB_CLK_FREQ / TB_TICKS_SEC; // 80
    localparam CLOCK_PERIOD    = 2;   // 1ps per half-cycle -> 1ps per clock cycle
	 localparam PIPELINE_LATENCY = 3;

    lab8 #(
        .MAX_LENGTH   (5),
        .TICKS_PER_SEC(TB_TICKS_SEC),
        .CLK_FREQ     (TB_CLK_FREQ)
    ) dut (
        .CLOCK_50     (CLOCK_50),
        .SW           (SW),
        .GPIO_1       (GPIO_1),
        .nes_latch_out(nes_latch_out),
        .nes_clock_out(nes_clock_out),
        .nes_data     (nes_data),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
        .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5)
    );

    initial CLOCK_50 = 0;
    always #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50;

    // =========================================================================
    // Timing helpers
    // =========================================================================

    // Wait for exactly n game_ticks then 1 extra cycle for snake_array settle.
    // Use this whenever you want to read snake_array after movement.
    task wait_ticks_settled(input int n);
        repeat(n) begin
				@(posedge dut.game_tick);
				
				@(posedge CLOCK_50); // settling of snake array
			end
    endtask

    // Wait for n game_ticks with NO extra settle — use when checking signals
    // that are valid on the tick edge itself (e.g. game_rst, snake_len after reset).
    task wait_ticks(input int n);
        repeat(n * CYCLES_PER_TICK) @(posedge CLOCK_50);
    endtask
	 
	 task wait_game_ticks(input int n);
    repeat(n) @(posedge dut.game_tick);
endtask

    // =========================================================================
    // press_nes_button
    //
    // Drives nes_data to match a real NES shift register:
    //   After latch falls, bit 0 is immediately on DATA.
    //   On each rising edge of nes_clock_out the controller shifts the next bit.
    //
    // Bit encoding (active-low):
    //   [0]=A [1]=B [2]=Sel [3]=Start [4]=Up [5]=Down [6]=Left [7]=Right
    //
    // IMPORTANT: this task drives nes_data continuously.  The 2-FF CDC sync
    // inside the DUT adds 2 cycles before nes_data_sync is stable, and
    // user_input adds another 2-cycle sync before dir is valid.
    // NES_DIV=2 -> enable fires every 2 cycles. Full packet = 18*2 = 36 cycles,
    // fits inside one game_tick (80 cycles) with 44 cycles margin.
    // =========================================================================
    task automatic press_nes_button(input logic [7:0] button_packet);
        // Wait for latch assert then release (state 0->1 in nes_controller_driver)
        @(posedge nes_latch_out);
        @(negedge nes_latch_out);

        // Hold 4 cycles (>= 2 for CDC sync) before presenting bit 0.
        // The DUT samples nes_data_sync at state 2, which fires on the
        // nes_enable pulse after latch falls.
        repeat(4) @(posedge CLOCK_50);
        nes_data = button_packet[0];

        // Bits 1-7: shift out on each rising edge of nes_clock_out.
        // Hold 4 cycles after each edge so the CDC sync has time to settle
        // before the DUT samples at the following even state.
        for (int i = 1; i < 8; i++) begin
            @(posedge nes_clock_out);
            repeat(4) @(posedge CLOCK_50);
            nes_data = button_packet[i];
        end

        // Release line to idle after last bit
        @(negedge nes_clock_out);
        nes_data = 1'b1;
    endtask
//	 
//	 task automatic press_nes_button_hold(input logic [7:0] button_packet,
//                                     input logic [3:0] expected_dir);
//    @(posedge nes_latch_out);
//    @(negedge nes_latch_out);
//
//    repeat(4) @(posedge CLOCK_50);
//    nes_data = button_packet[0];
//
//    for (int i = 1; i < 8; i++) begin
//        @(posedge nes_clock_out);
//        repeat(4) @(posedge CLOCK_50);
//        nes_data = button_packet[i];
//    end
//
//    repeat(20) @(posedge CLOCK_50); // hold past CDC + dir logic + tick window
//
//    wait (dut.dir == expected_dir);
//endtask


    // =========================================================================
    // do_reset — assert SW[9] for 20 cycles, deassert, wait for game to settle
    // =========================================================================
    // hold reset for several cycles, then wait for the first game_tick after
    // release so snake_array is fully initialised before any sampling.
    task do_reset();
        SW[9] = 1;
        repeat(20) @(posedge CLOCK_50);
        SW[9] = 0;
        @(posedge dut.game_tick);   // let tick_gen re-arm and one tick fire
        repeat(2) @(posedge CLOCK_50); // settle snake_array non-blocking assigns
    endtask
	 
	 logic [7:0] test_id;
	 
	 // Helps make finidng tests easier
	 task automatic mark_test(
    input int id,
    input string name
	 );
			begin
				 test_id = id;
				 $display("[TB_MARKER] TEST %0d (%s) START @ %0t ps",
							 id, name, $time);
			end
	  endtask
	  
	  task automatic wait_for_dir(input logic [3:0] expected, input int timeout_cycles = 50);
    bit seen;
    seen = 0;

    for (int i = 0; i < timeout_cycles; i++) begin
        @(posedge CLOCK_50);
        $display("[TB] t=%0t dir=%b expected=%b", $time, dut.dir, expected);
        if (dut.dir == expected) begin
            seen = 1;
            break;
        end
    end

    if (!seen)
        $fatal(1, "Timeout waiting for dir=%b, final dir=%b", expected, dut.dir);
endtask

//always @(posedge dut.game_tick) begin
//    $display("[TICK] t=%0t dir=%b head=(%0d,%0d)",
//             $time, dut.dir,
//             dut.snake_array[0][7:4],
//             dut.snake_array[0][3:0]);
//end




    // =========================================================================
    // Test sequence
    // =========================================================================
    initial begin
		  $timeformat(-12,0," ps",10);

		  test_id  = 0;
		  SW       = 10'b0;
		  nes_data = 1'b1;
		  
        SW       = 10'b0;
        nes_data = 1'b1;

        // -----------------------------------------------------------------
        // RESET
        // do_reset() waits for the first post-release game_tick, so head has
        // already moved one step RIGHT from (8,8) to (9,8). Capture that as
        // the baseline; assert len=3 and y=8 (hasn't moved vertically).
        // -----------------------------------------------------------------
        mark_test(0, "RESET");
        do_reset();
        head_x0 = dut.snake_array[0][7:4];
        head_y0 = dut.snake_array[0][3:0];
        $display("[TB] After reset+1tick: len=%0d head=(%0d,%0d)",
            dut.snake_len, head_x0, head_y0);
        assert(dut.snake_len == 8'd3)
            else $error("[TB] RESET FAIL: snake_len=%0d expected 3", dut.snake_len);
        assert(head_y0 == 4'd8)
            else $error("[TB] RESET FAIL: head Y=%0d expected 8", head_y0);
/*
        // -----------------------------------------------------------------
        // TEST 1: Move RIGHT (default direction after reset)
        // head_x0 captured after reset+1tick. After 2 more ticks X += 2.
        // -----------------------------------------------------------------
        //$display("\n[TB] ===== TEST 1: Default RIGHT movement =====");
		  mark_test(1, "Default RIGHT movement");
        wait_ticks_settled(2);
        $display("[TB] After 2 ticks: head=(%0d,%0d) len=%0d",
            dut.snake_array[0][7:4],
            dut.snake_array[0][3:0],
            dut.snake_len);
        assert(dut.snake_array[0][7:4] == head_x0 + 4'd2 &&
               dut.snake_array[0][3:0] == 4'd8)
            else $error("[TB] TEST 1 FAIL: head=(%0d,%0d) expected (%0d,8)",
                dut.snake_array[0][7:4], dut.snake_array[0][3:0], head_x0+2);
        assert(dut.snake_len == 8'd3)
            else $error("[TB] TEST 1 FAIL: len=%0d expected 3", dut.snake_len);
        $display("[TB] TEST 1 PASS");

        // -----------------------------------------------------------------
        // TEST 2: Turn UP via NES D-pad
        // Packet: all 1s except bit 4 (Up, active-low) = 8'b1110_1111
        // X should freeze; Y should increase from baseline 8.
        // fork: press_nes_button syncs to next latch pulse and completes
        // within 36 cycles; wait_ticks_settled(2) gives 160 cycles total
        // so direction is guaranteed registered before the 2nd tick fires.
        // -----------------------------------------------------------------
        //$display("\n[TB] ===== TEST 2: Turn UP via NES =====");
		  mark_test(2, "Turn UP via NES");
        begin
            x_pre_turn = dut.snake_array[0][7:4];
            fork
                press_nes_button(8'b1110_1111); // Up pressed
                wait_ticks_settled(2);
            join
            $display("[TB] After turn UP + 2 ticks: head=(%0d,%0d)",
                dut.snake_array[0][7:4],
                dut.snake_array[0][3:0]);
            assert(dut.snake_array[0][7:4] == x_pre_turn)
                else $error("[TB] TEST 2 FAIL: X moved to %0d, expected %0d (no X change after UP)",
                    dut.snake_array[0][7:4], x_pre_turn);
            assert(dut.snake_array[0][3:0] > 4'd8)
                else $error("[TB] TEST 2 FAIL: Y=%0d expected >8 (moved UP)",
                    dut.snake_array[0][3:0]);
            $display("[TB] TEST 2 PASS");
        end
*/

        // -----------------------------------------------------------------
        // TEST 1: Wall collision (board_edge)
        // From current position, keep going UP until we hit the wall.
        // Board is 16x16 so y=15 is the last valid row; next_y_comb will
        // overflow the 5-bit extended value triggering board_edge.
        // board_edge is combinational so it's valid the same cycle as
        // the tick that would cause overflow.
        // We allow up to 8 ticks to reach the wall.
        // -----------------------------------------------------------------
        //$display("\n[TB] ===== TEST 3: Wall collision (board_edge) =====");
		  mark_test(1, "Wall collision");
        begin
            hit = 0;
            for (int t = 0; t < 8; t++) begin
                wait_ticks_settled(1);
                if (dut.board_edge || dut.endGame) begin
                    hit = 1;
                    $display("[TB] TEST 1: board_edge=%0b endGame=%0b after %0d extra ticks",
                        dut.board_edge, dut.endGame, t+1);
                    break;
                end
            end
            assert(hit)
                else $error("[TB] TEST 1 FAIL: never hit wall in 8 ticks");
            $display("[TB] TEST 1 PASS");
        end

        // -----------------------------------------------------------------
        // TEST 2: Mid-game reset clears state
        // -----------------------------------------------------------------
		  mark_test(2, "Mid-game reset");
        SW[9] = 1;
        repeat(3) @(posedge CLOCK_50);
        assert(dut.game_rst == 1'b1)
            else $error("[TB] TEST 2a FAIL: game_rst not asserted");
        SW[9] = 0;
        repeat(3) @(posedge CLOCK_50);
        assert(dut.snake_len == 8'd3)
            else $error("[TB] TEST 2b FAIL: snake_len=%0d expected 3", dut.snake_len);
        assert(dut.snake_array[0][3:0] == 4'd8)
            else $error("[TB] TEST 2c FAIL: head Y=%0d expected 8 after reset",
                dut.snake_array[0][3:0]);
        $display("[TB] TEST 2 PASS");

        // -----------------------------------------------------------------
        // TEST 3: Apple eating and snake growth
        // Apple resets to (5,5). After do_reset head is at (head_x0,8).
        // head_x0=9 after first tick. Need to reach (5,5):
        //   Turn DOWN, tick 3 times -> y = 8-3 = 5.
        //   Turn LEFT, tick (head_x0 - 5) times -> x = 5.
        // Then check snake_len increases.
        // -----------------------------------------------------------------
        //$display("\n[TB] ===== TEST 5: Apple eating and growth =====");
//        mark_test(5, "Apple eating and growth");
//
//		  do_reset();
//		  
//		  begin
//		  
//		  end
//		  
//        begin
//            steps_left = int'(dut.snake_array[0][7:4]) - 5; // x_now - 5
//
//            // Turn DOWN
//            press_nes_button(8'b1101_1111); // DOWN
//				wait_ticks_settled(3);
//            
//				wait_ticks_settled(2); // move down 3 -> y=5
//            $display("[TB] After DOWN: head=(%0d,%0d)",
//                dut.snake_array[0][7:4], dut.snake_array[0][3:0]);
//
//            // Turn LEFT
//            press_nes_button(8'b1011_1111); // LEFT
//				//repeat(10)@(posedge CLOCK_50);
//
//				wait_ticks_settled(steps_left + 2);
//            wait_ticks_settled(steps_left); // move left to x=5
//            $display("[TB] After LEFT: head=(%0d,%0d) apple=(%0d,%0d) len=%0d",
//                dut.snake_array[0][7:4], dut.snake_array[0][3:0],
//                dut.apple_x, dut.apple_y, dut.snake_len);
//
//            // Poll up to 5 ticks for growth (apple FSM needs a cycle to update)
//            begin
//                grew = 0;
//                for (int t = 0; t < 5; t++) begin
//                    wait_ticks_settled(1);
//                    if (dut.snake_len > 8'd3) begin
//                        grew = 1;
//                        $display("[TB] TEST 5: snake grew to len=%0d", dut.snake_len);
//                        break;
//                    end
//                end
//                if (!grew)
//                    $display("[TB] TEST 5 NOTE: growth not observed — check apple coords vs path");
//                else
//                    $display("[TB] TEST 5 PASS");
//            end
//        end

		mark_test(3, "Apple eating and growth");
		do_reset();

		// 1) Align to a clean tick boundary (finish the last RIGHT move)
    @(posedge dut.game_tick);
    @(posedge CLOCK_50);

    // 2) Turn DOWN between ticks
    press_nes_button(8'b1101_1111);  // DOWN packet (whatever you used before)
    wait_for_dir(4'b0001, 100);      // wait until dir == DOWN

    // 3) Now count exactly 2 ticks
    wait_ticks_settled(2);
	 
		$display("[TB] After DOWN: head=(%0d,%0d) dir=%b",
			 dut.snake_array[0][7:4], dut.snake_array[0][3:0], dut.dir);
			 
			 
		// LEFT
		press_nes_button(8'b1111_1011);
		wait_for_dir(4'b1000, 100);
		//wait_ticks_settled(steps_left);
		wait_ticks_settled(7);
		
		
		$display("[TB] After LEFT: head=(%0d,%0d) apple=(%0d,%0d) len=%0d dir=%b",
			 dut.snake_array[0][7:4], dut.snake_array[0][3:0],
			 dut.apple_x, dut.apple_y, dut.snake_len, dut.dir);
			 
			 // Turn UP: 1 tick — head lands on a body segment
		press_nes_button(8'b1110_1111);    // UP packet (bit for up low)
		wait_for_dir(4'b0010, 100);        // dir = UP
		wait_ticks_settled(1);             // move 1 step up into body // 1 tick
		$display("[TB] After UP: head=(%0d,%0d) apple=(%0d,%0d) len=%0d dir=%b",
			 dut.snake_array[0][7:4], dut.snake_array[0][3:0],
			 dut.apple_x, dut.apple_y, dut.snake_len, dut.dir);
			 
		// RIGHT
		press_nes_button(8'b1111_0111);
		wait_for_dir(4'b0100, 100);
		//wait_ticks_settled(steps_left);
		wait_ticks_settled(7);


        // -----------------------------------------------------------------
        // TEST 4: nes_enable divider sanity
        // NES_DIV = CLK_FREQ/4000 = 8000/4000 = 2
        // Expect exactly 128 enable pulses in 256 cycles (one per 2 cycles)
        // -----------------------------------------------------------------
        //$display("\n[TB] ===== TEST 7: nes_enable divider =====");
        mark_test(4, "NES enable divider");

		  do_reset();
        begin
            edge_count = 0;
            repeat(256) begin
                @(posedge CLOCK_50);
                if (dut.nes_enable) edge_count++;
            end
            $display("[TB] TEST 4: %0d enable pulses in 256 cycles (expected 128)", edge_count);
            assert(edge_count == 128)
                else $error("[TB] TEST 4 FAIL: %0d pulses, expected 128", edge_count);
            $display("[TB] TEST 4 PASS");
        end

		 // -----------------------------------------------------------------
		// TEST 5: 180-degree direction reversal blocked
		// Snake facing RIGHT; send LEFT — current_dir must not change.
		// -----------------------------------------------------------------
		mark_test(5, "180-degree reversal blocked");
		do_reset();

		// Let one RIGHT tick happen so we are in a steady state
		wait_ticks_settled(1);
		x_before = dut.snake_array[0][7:4];

		// Sanity: we are moving RIGHT (dir code should be the one your snake_module uses)
		$display("[TB] TEST 5: before LEFT, dir=%b head_x=%0d",
					dut.dir, x_before);

		// Send LEFT packet (the same one you used in Test 5)
		press_nes_button(8'b1111_1011);      // your LEFT packet
		//wait_for_dir(1000, 100); 
		// ^^^ IMPORTANT: if your snake_module blocks 180° reversals internally,
		// dir may *stay* RIGHT, not become LEFT. In that case, don’t wait for LEFT;
		// just let the packet go through and then count ticks.

		// Count 2 more ticks and see if X kept increasing
		wait_ticks_settled(2);

		$display("[TB] TEST 5: x_before=%0d x_after=%0d dir=%b",
					x_before, dut.snake_array[0][7:4], dut.dir);
		assert(dut.snake_array[0][7:4] > x_before)
			 else $error("[TB] TEST 5 FAIL: snake reversed or stopped (X did not increase)");
		$display("[TB] TEST 5 PASS");


        // -----------------------------------------------------------------
        // TEST 6: Switch-controlled tick speed
        // Default period = CLK_FREQ/TICKS_PER_SEC = 8000/100 = 80 cycles.
        // SW=80 -> period = 8000/80  = 100 cycles
        // SW=40 -> period = 8000/40  = 200 cycles
        // SW=0  -> back to default   = 80 cycles
        // $time is in ps; CLOCK_PERIOD=2 so 1 cycle = 2ps.
        // -----------------------------------------------------------------
        //$display("\n[TB] ===== TEST 9: Switch tick speed =====");
        mark_test(6, "Switch tick speed");
		  do_reset();
        begin
            // SW=80: expect 100 cycles = 200ps per tick
            SW[8:0] = 9'd80;
            @(posedge dut.game_tick); t_start = $time;
            @(posedge dut.game_tick); t_end   = $time;
            measured = (t_end - t_start) / CLOCK_PERIOD; // convert ps -> cycles
            $display("[TB] TEST 6a: SW=80 period=%0d cycles (expected 100)", measured);
            assert(measured == 100)
                else $error("[TB] TEST 6a FAIL: period=%0d expected 100", measured);

            // SW=40: expect 200 cycles = 400ps per tick
            SW[8:0] = 9'd40;
            @(posedge dut.game_tick); t_start = $time;
            @(posedge dut.game_tick); t_end   = $time;
            measured = (t_end - t_start) / CLOCK_PERIOD;
            $display("[TB] TEST 6b: SW=40 period=%0d cycles (expected 200)", measured);
            assert(measured == 200)
                else $error("[TB] TEST 6b FAIL: period=%0d expected 200", measured);

            // SW=0: back to default 80 cycles = 160ps
            SW[8:0] = 9'd0;
            @(posedge dut.game_tick); t_start = $time;
            @(posedge dut.game_tick); t_end   = $time;
            measured = (t_end - t_start) / CLOCK_PERIOD;
            $display("[TB] TEST 6c: SW=0 period=%0d cycles (expected 80)", measured);
            assert(measured == 80)
                else $error("[TB] TEST 6c FAIL: period=%0d expected 80", measured);

            $display("[TB] TEST 6 PASS");
        end
		$stop;
    end

endmodule
