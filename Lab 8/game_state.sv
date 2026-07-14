module game_state #(parameter MAX_SNAKE_LENGTH = 253) (
    input  logic clk,
    input  logic rst,
    input  logic suicide,
	 input  logic board_edge,
	 input  logic game_tick,
    input  logic [7:0] snake_len,
    output logic game_rst,
    output logic endGame,
    output logic win,
	 output logic [6:0] display5, display4, display3
);

    assign game_rst = rst;

    always_ff @(posedge clk) begin
        if (rst) begin
            endGame <= 1'b0;
            win     <= 1'b0;
        end
        else if (!endGame) begin
            if (suicide || (board_edge && game_tick)) begin
                endGame <= 1'b1;
                win     <= 1'b0;
            end
            else if (snake_len == MAX_SNAKE_LENGTH) begin
                endGame <= 1'b1;
                win     <= 1'b1;
            end
        end
    end
	 
	 always_comb begin
		if (rst) begin
			display5 = 7'b0001010;
			display4 = 7'b0010010;
			display3 = 7'b1111000;
		end
		
		else if (!rst && !win && !endGame) begin
			display5 = 7'b0001100;
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
			display4 = 7'b1101011;
			display3 = 7'b1101101;
		end
		
		else begin
			display5 = 7'b0001100;
			display4 = 7'b1000111;
			display3 = 7'b0010001;
		end
	end

endmodule

module game_state_tb();
    parameter MAX_SNAKE_LENGTH = 253;

    logic clk, rst, suicide, board_edge, game_tick;
    logic [7:0] snake_len;
    logic [6:0] display5, display4, display3;
    logic game_rst, endGame, win;

    // 7-seg patterns
    localparam [6:0] SEG_RST_D5  = 7'b0001010; // "r"
    localparam [6:0] SEG_RST_D4  = 7'b0010010; // "s"
    localparam [6:0] SEG_RST_D3  = 7'b1111000; // "t"
    localparam [6:0] SEG_RUN_D5  = 7'b0001100; // "P"
    localparam [6:0] SEG_RUN_D4  = 7'b1000111; // "L"
    localparam [6:0] SEG_RUN_D3  = 7'b0010001; // "Y"
    localparam [6:0] SEG_LOSE_D5 = 7'b1111111; // blank
    localparam [6:0] SEG_LOSE_D4 = 7'b1000111; // "L"
    localparam [6:0] SEG_LOSE_D3 = 7'b1111111; // blank
    localparam [6:0] SEG_WIN_D5  = 7'b1011011;
    localparam [6:0] SEG_WIN_D4  = 7'b1101011;
    localparam [6:0] SEG_WIN_D3  = 7'b1101101;

    game_state #(.MAX_SNAKE_LENGTH(MAX_SNAKE_LENGTH)) state_manager (.*);

    always #5 clk = ~clk;

    task tick();
        @(posedge clk);
        #1;
    endtask

    initial begin
        clk        = 0;
        rst        = 1;
        suicide    = 0;
        board_edge = 0;
        game_tick  = 0;
        snake_len  = 8'd3;

        // TC1: reset state
        tick();
        assert (game_rst && !endGame && !win) else $error("TC1 FAIL: reset state");
        assert (display5 == SEG_RST_D5 && display4 == SEG_RST_D4 && display3 == SEG_RST_D3)
            else $error("TC1 FAIL: display should show rst pattern");

        // TC2: normal running state
        rst = 0;
        tick();
        assert (!game_rst && !endGame && !win) else $error("TC2 FAIL: running state");
        assert (display5 == SEG_RUN_D5 && display4 == SEG_RUN_D4 && display3 == SEG_RUN_D3)
            else $error("TC2 FAIL: display should show play pattern");

        // TC3: board_edge WITHOUT game_tick — must NOT end game
        board_edge = 1;
        game_tick  = 0;
        tick();
        assert (!endGame) else $error("TC3 FAIL: board_edge alone should not end game");
        board_edge = 0;

        // TC4: board_edge WITH game_tick — ends game
        board_edge = 1;
        game_tick  = 1;
        tick();
        assert (endGame && !win) else $error("TC4 FAIL: board_edge+game_tick should end game");
        assert (display5 == SEG_LOSE_D5 && display4 == SEG_LOSE_D4 && display3 == SEG_LOSE_D3)
            else $error("TC4 FAIL: display should show lose pattern");
        board_edge = 0;
        game_tick  = 0;

        // TC5: endGame stays latched after board_edge drops
        tick();
        assert (endGame && !win) else $error("TC5 FAIL: endGame should stay latched");

        // TC6: reset clears game-over
        rst = 1;
        suicide = 0;
        board_edge = 0;
        tick();
        assert (game_rst && !endGame && !win) else $error("TC6 FAIL: reset should clear endGame");
        assert (display5 == SEG_RST_D5 && display4 == SEG_RST_D4 && display3 == SEG_RST_D3)
            else $error("TC6 FAIL: display should show rst pattern after reset");

        // TC7: suicide ends the game
        rst = 0;
        tick();
        suicide = 1;
        tick();
        assert (endGame && !win) else $error("TC7 FAIL: suicide should end game");
        assert (display5 == SEG_LOSE_D5 && display4 == SEG_LOSE_D4 && display3 == SEG_LOSE_D3)
            else $error("TC7 FAIL: display should show lose pattern on suicide");

        // TC8: endGame stays latched after suicide drops
        suicide = 0;
        tick();
        assert (endGame && !win) else $error("TC8 FAIL: endGame should stay latched after suicide drops");

        // TC9: win condition
        rst = 1;
        tick();
        rst = 0;
        snake_len = MAX_SNAKE_LENGTH;
        tick();
        assert (endGame && win) else $error("TC9 FAIL: max length should trigger win");
        assert (display5 == SEG_WIN_D5 && display4 == SEG_WIN_D4 && display3 == SEG_WIN_D3)
            else $error("TC9 FAIL: display should show win pattern");

        // TC10: win stays latched until reset
        snake_len = 8'd3;
        tick();
        assert (endGame && win) else $error("TC10 FAIL: win should stay latched");

        // TC11: suicide ignored while endGame is latched
        rst = 1; tick(); rst = 0; tick(); // endGame cleared
        suicide = 1; game_tick = 1;
        tick();
        assert (endGame) else $error("TC11 setup FAIL");
        // now try to re-trigger — should stay in endGame, win stays 0
        suicide = 0; game_tick = 0;
        snake_len = MAX_SNAKE_LENGTH; // win condition, but endGame already set
        tick();
        assert (endGame && !win) else $error("TC11 FAIL: win should not latch once endGame is already set");
        snake_len = 8'd3;

        $display("game_state_tb passed");
        $stop;
    end
endmodule
