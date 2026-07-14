module collision_detector #(parameter MAX_LENGTH = 256) (
    input  logic endGame,
    input  logic rst,

    input  logic [7:0] snake_array [0:MAX_LENGTH-1],
    input  logic [7:0] snake_len,

    input  logic [3:0] apple_x,
    input  logic [3:0] apple_y,

    output logic eaten,
    output logic suicide
);

    logic [3:0] head_x, head_y;

    always_comb begin

        eaten   = 1'b0;
        suicide = 1'b0;

        head_x = snake_array[0][7:4];
        head_y = snake_array[0][3:0];

        if (!endGame) begin

            // ------------------------------------------------
            // FIX #6: eaten is purely combinational AND stable
            // ------------------------------------------------
            if (head_x == apple_x && head_y == apple_y)
                eaten = 1'b1;

            // ------------------------------------------------
            // FIX #7: suicide fixed (no stale behavior issue)
            // uses CURRENT state but now safe due to sync
            // ------------------------------------------------
            for (int i = 1; i < MAX_LENGTH; i++) begin
						if (i < snake_len) begin
							 if (head_x == snake_array[i][7:4] &&
								  head_y == snake_array[i][3:0])
								  suicide = 1'b1;
						end
            end
        end
    end

endmodule

module collision_detector_tb();
    parameter MAX_LENGTH = 256;

    logic clk, endGame;
    logic [7:0] snake_array [0:MAX_LENGTH-1];
    logic [7:0] snake_len;
    logic [3:0] apple_x, apple_y;
    logic eaten, suicide;

    localparam LEFT  = 4'b1000;
    localparam RIGHT = 4'b0100;
    localparam UP    = 4'b0010;
    localparam DOWN  = 4'b0001;

    // clk/rst removed: DUT is purely combinational, they do nothing
    collision_detector #(.MAX_LENGTH(MAX_LENGTH)) dut (
        .endGame    (endGame),
        .rst        (1'b0),
        .snake_array(snake_array),
        .snake_len  (snake_len),
        .apple_x    (apple_x),
        .apple_y    (apple_y),
        .eaten      (eaten),
        .suicide    (suicide)
    );

    initial begin
        endGame = 0;
        snake_len = 8'd1;
        apple_x = 4'd0;
        apple_y = 4'd0;

        // fill with sentinel (0xFF = coords (15,15))
        for (int i = 0; i < MAX_LENGTH; i++)
            snake_array[i] = 8'hFF;

        // TC1: head not on apple, no body — nothing fires-
        snake_array[0] = 8'h11;
        apple_x = 4'd5; apple_y = 4'd5;
        #1;
        assert (!eaten && !suicide) else $error("TC1 FAIL: expected no collision");

        // TC2: head lands on apple — eaten fires
        snake_array[0] = 8'h55;
        apple_x = 4'd5; apple_y = 4'd5;
        #1;
        assert (eaten && !suicide) else $error("TC2 FAIL: expected eaten only");

        // TC3: head moves off apple — eaten drops
        snake_array[0] = 8'h11;
        #1;
        assert (!eaten && !suicide) else $error("TC3 FAIL: eaten should drop");

        // TC4: head hits body segment[1] — suicide fires
        snake_array[0] = 8'h33;
        snake_array[1] = 8'h33;
        snake_len = 8'd2;
        apple_x = 4'd0; apple_y = 4'd0; // apple elsewhere
        #1;
        assert (!eaten && suicide) else $error("TC4 FAIL: expected suicide only");

        // TC5: head elsewhere, body segment at [1] — no suicide
        snake_array[0] = 8'h11;
        snake_array[1] = 8'h33;
        #1;
        assert (!eaten && !suicide) else $error("TC5 FAIL: false suicide");

        // TC6: segment[2] matches head but snake_len=2 — not counted
        snake_array[0] = 8'h12;
        snake_array[1] = 8'h34;
        snake_array[2] = 8'h12; // same as head but outside snake_len
        snake_len = 8'd2;
        #1;
        assert (!suicide) else $error("TC6 FAIL: out-of-bounds segment triggered suicide");

        // TC7: sentinel coords (0xFF = 15,15) don't trigger suicide
        //      with a short snake — the fill value should be inert
        snake_array[0] = 8'hFF; // head at (15,15)
        snake_array[1] = 8'hAB;
        snake_len = 8'd2;
        apple_x = 4'd0; apple_y = 4'd0;
        #1;
        assert (!suicide) else $error("TC7 FAIL: sentinel triggered false suicide");
        snake_array[0] = 8'h11; // restore head away from sentinel

        // TC8: snake_len=1 — no body segments, suicide impossible
        snake_array[0] = 8'h55;
        snake_array[1] = 8'h55; // would collide if counted
        snake_len = 8'd1;
        apple_x = 4'd0; apple_y = 4'd0;
        #1;
        assert (!suicide) else $error("TC8 FAIL: snake_len=1 should never suicide");

        // TC9: simultaneous eaten + suicide — both fire independently
        snake_array[0] = 8'h55; // head at (5,5)
        snake_array[1] = 8'h55; // body also at (5,5)
        snake_len = 8'd2;
        apple_x = 4'd5; apple_y = 4'd5; // apple also at (5,5)
        #1;
        assert (eaten && suicide) else $error("TC9 FAIL: expected both eaten and suicide");

        // TC10: endGame suppresses both outputs
        snake_array[0] = 8'h55;
        snake_array[1] = 8'h55;
        snake_len = 8'd2;
        apple_x = 4'd5; apple_y = 4'd5;
        endGame = 1;
        #1;
        assert (!eaten && !suicide) else $error("TC10 FAIL: endGame should suppress all");

        // TC11: endGame drops — outputs resume
        endGame = 0;
        #1;
        assert (eaten && suicide) else $error("TC11 FAIL: outputs should resume after endGame drops");

        // TC12: realistic suicide — head wraps to hit segment[2], not [1]
        snake_array[0] = 8'hAA; // head at (10,10)
        snake_array[1] = 8'hBB; // segment 1: different
        snake_array[2] = 8'hAA; // segment 2: same as head
        snake_len = 8'd3;
        apple_x = 4'd0; apple_y = 4'd0;
        #1;
        assert (!eaten && suicide) else $error("TC12 FAIL: wrap-around suicide via segment[2]");

        // TC13: snake_len=0 — nothing fires even with matching coords
        snake_array[0] = 8'h55;
        snake_array[1] = 8'h55;
        snake_len = 8'd0;
        apple_x = 4'd5; apple_y = 4'd5;
        #1;
        // eaten still fires (head vs apple is independent of snake_len)
        // suicide should not fire (no body segments counted)
        assert (!suicide) else $error("TC13 FAIL: snake_len=0 should never suicide");

        $display("collision_detector_tb passed");
        $stop;
    end
endmodule
