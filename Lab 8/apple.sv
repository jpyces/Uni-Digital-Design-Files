module apple #(parameter MAX_LENGTH = 256)(
	input logic endGame, game_rst, eaten, clk,
	input logic [7:0] snake_array [0:MAX_LENGTH-1],
	input logic [7:0] snake_len,
	output logic [3:0] apple_x, apple_y
);
	logic has_collision;
	logic [7:0] cand_apple_coords;
	logic [7:0] lfsr_out;
	
	enum logic [1:0] {IDLE = 2'b00, SEARCHING = 2'b01} ps, ns;
	
	lfsr8bit bingbongLFSR (.clk(clk), .rst(game_rst), .Q(lfsr_out));
	
	// checking snake array for collisions during spawn
	always_comb begin
		logic found;
		found = 0;
		cand_apple_coords = lfsr_out;
		
		if (ps == SEARCHING) begin
			for (int i = 0; i < MAX_LENGTH; i++) begin
				if (i < snake_len) begin
					if (cand_apple_coords == snake_array[i]) begin
						found = 1;
					end
				end
			end
		end 
		
		has_collision = found;
	end

	// idle vs searching state management
	always_comb begin
		ns = ps;
		case (ps)
			IDLE: begin
				if (eaten) begin
					ns = SEARCHING;
				end
			end
			
			SEARCHING: begin
				if (has_collision == 0) begin
					ns = IDLE;
				end
			end
			
			default: ns = ps;
		endcase
	end
	
	// fsm handler
	always_ff @(posedge clk) begin
		if (game_rst) begin
			ps <= IDLE;
			apple_x <= 4'd5;
			apple_y <= 4'd5;
		end
		else if (!endGame) begin
			ps <= ns;
			if (ps == SEARCHING  && has_collision == 0) begin
				apple_x <= cand_apple_coords[7:4];
				apple_y <= cand_apple_coords[3:0];
			end
		end
	end
	
endmodule

module apple_tb();
    logic endGame, game_rst, eaten, clk;
    logic [7:0] snake_array [0:3];
    logic [7:0] snake_len;
    logic [3:0] apple_x, apple_y;

    apple #(.MAX_LENGTH(4)) dut (.*);

    parameter CLOCK_PERIOD = 100;
    initial begin clk <= 0; forever #(CLOCK_PERIOD/2) clk <= ~clk; end

    // check apple coords don't overlap any snake segment
    function automatic logic apple_clear();
        for (int i = 0; i < 4; i++)
            if (i < snake_len)
                if ({apple_x, apple_y} == snake_array[i]) return 0;
        return 1;
    endfunction

    initial begin
        game_rst = 1; eaten = 0; endGame = 0;
        snake_array[0] = 8'h88; snake_array[1] = 8'h78;
        snake_array[2] = 8'h68; snake_array[3] = 8'h00;
        snake_len = 8'd3;
        @(posedge clk); game_rst = 0;

        // TC1: reset state — apple at (5,5), no eaten
        repeat(2) @(posedge clk);
        assert(apple_x == 4'd5 && apple_y == 4'd5)
            else $error("TC1 FAIL: apple not at reset pos (5,5), got (%0d,%0d)", apple_x, apple_y);

        // TC2: pulse eaten -> apple should move to a non-snake position
        eaten = 1; @(posedge clk); eaten = 0;
        repeat(10) @(posedge clk); // give LFSR+FSM time to settle
        assert(apple_clear())
            else $error("TC2 FAIL: new apple overlaps snake at (%0d,%0d)", apple_x, apple_y);
        assert(!(apple_x == 4'd5 && apple_y == 4'd5))
            else $error("TC2 FAIL: apple didn't move from (5,5)");

        // TC3: endGame suppresses apple movement
        begin
            logic [3:0] ax, ay;
            ax = apple_x; ay = apple_y;
            endGame = 1;
            eaten = 1; @(posedge clk); eaten = 0;
            repeat(5) @(posedge clk);
            assert(apple_x == ax && apple_y == ay)
                else $error("TC3 FAIL: apple moved during endGame");
            endGame = 0;
        end

        // TC4: LFSR collision avoidance — pack snake to force LFSR to search
        // fill all 4 slots so almost every candidate collides
        snake_array[0] = 8'h11; snake_array[1] = 8'h22;
        snake_array[2] = 8'h33; snake_array[3] = 8'h44;
        snake_len = 8'd4;
        eaten = 1; @(posedge clk); eaten = 0;
        repeat(20) @(posedge clk);
        assert(apple_clear())
            else $error("TC4 FAIL: apple landed on snake after collision avoidance");

        $display("apple_tb passed");
        $stop;
    end
endmodule
