module snake #(parameter MAX_LENGTH = 256) (
    input  logic endGame, eaten, game_rst, game_tick, clk,
    input  logic [3:0] dir,

    output logic [7:0] snake_array [0:MAX_LENGTH-1],
    output logic [7:0] snake_len,
    output logic board_edge
);

    logic [3:0] head_x, head_y;
    logic [4:0] next_x_comb, next_y_comb;

    assign head_x = snake_array[0][7:4];
    assign head_y = snake_array[0][3:0];

    logic [3:0] current_dir;

	always_ff @(posedge clk) begin
		 if (game_rst)
			  current_dir <= 4'b0100;
		 else if (game_tick) begin
			  if (dir != 4'b0000) begin
					case (current_dir)
						 4'b1000: if (dir != 4'b0100) current_dir <= dir;
						 4'b0100: if (dir != 4'b1000) current_dir <= dir;
						 4'b0010: if (dir != 4'b0001) current_dir <= dir;
						 4'b0001: if (dir != 4'b0010) current_dir <= dir;
						 default: current_dir <= dir;
					endcase
			  end
		 end
	end



    always_comb begin
        next_x_comb = {1'b0, head_x};
        next_y_comb = {1'b0, head_y};

        if (!endGame) begin
            case (current_dir)

                4'b1000: next_x_comb = {1'b0, head_x} - 5'd1; // LEFT
                4'b0100: next_x_comb = {1'b0, head_x} + 5'd1; // RIGHT
                4'b0010: next_y_comb = {1'b0, head_y} + 5'd1; // UP
                4'b0001: next_y_comb = {1'b0, head_y} - 5'd1; // DOWN

                default: ;
            endcase
        end
    end

    // ------------------------------------------------
    // wall detection (correct for ALL sides)
    // ------------------------------------------------
    always_comb begin
        board_edge = next_x_comb[4] || next_y_comb[4];
    end


    always_ff @(posedge clk) begin

        if (game_rst) begin
            for (int i = 0; i < MAX_LENGTH; i++)
                snake_array[i] <= 8'h01;

            snake_array[0] <= {4'd8,4'd8};
            snake_array[1] <= {4'd7,4'd8};
            snake_array[2] <= {4'd6,4'd8};

            snake_len <= 3;
        end

        else if (game_tick && !endGame && !board_edge) begin

            for (int i = MAX_LENGTH-1; i > 0; i--) begin
                if (i < snake_len)
                    snake_array[i] <= snake_array[i-1];
            end

            snake_array[0] <= {next_x_comb[3:0], next_y_comb[3:0]};

            if (eaten)
					//snake_array[snake_len] <= snake_array[snake_len -1];
                snake_len <= snake_len + 8'd1;
        end
    end

endmodule


module snake_tb();

    // Inputs
    logic endGame;
    logic eaten;
	 logic board_edge;
    logic game_rst;
	 logic clk;
    logic game_tick;
    logic [3:0] dir;

    // Outputs
//    logic [3:0] next_x;
//    logic [3:0] next_y;
    logic [7:0] snake_array [0:255];
    logic [7:0] snake_len;

    // Instantiate DUT (Unit Under Test)
    snake dut (.*);

    parameter CLOCK_PERIOD = 100;
	 initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

    initial begin
        // Initialize Inputs
        game_tick = 0;
        game_rst = 1;
        endGame = 0;
        eaten = 0;
        dir = 4'b0100; // Face RIGHT

        // Hold reset for 2 clock cycles
        repeat(2) begin
				game_tick <= 1; @(posedge clk);
				game_tick <= 0; @(posedge clk);
		  end
        game_rst = 0;
        game_tick <= 1; @(posedge clk);
			game_tick <= 0; @(posedge clk);
			
        $display("--- Reset Released ---");
        $display("Time=%0t | Len=%0d | Head=(%0d,%0d)", $time, snake_len, snake_array[0][7:4], snake_array[0][3:0]);

        // Step 1: Move forward Right 2 times
repeat(2) begin
				game_tick <= 1; @(posedge clk);
				game_tick <= 0; @(posedge clk);
		  end        $display("Time=%0t | Moving Right | Head=(%0d,%0d) | Body1=(%0d,%0d)", 
                 $time, snake_array[0][7:4], snake_array[0][3:0], snake_array[1][7:4], snake_array[1][3:0]);

        // Step 2: Simulate eating food
		  		  eaten = 1; 
repeat(1) begin
				game_tick <= 1; @(posedge clk);
				game_tick <= 0; @(posedge clk);
		  end    
			eaten = 0;
        
repeat(1) begin
				game_tick <= 1; @(posedge clk);
				game_tick <= 0; @(posedge clk);
		  end        eaten = 0; // Clear flag
        $display("Time=%0t | Food Eaten!  | New Len=%0d | Head=(%0d,%0d)", $time, snake_len, snake_array[0][7:4], snake_array[0][3:0]);

        // Step 3: Turn UP
        dir = 4'b0010; 
repeat(1) begin
				game_tick <= 1; @(posedge clk);
				game_tick <= 0; @(posedge clk);
		  end        
		  $display("Time=%0t | Turned UP    | Head=(%0d,%0d) | Body1=(%0d,%0d)", 
                 $time, snake_array[0][7:4], snake_array[0][3:0], snake_array[1][7:4], snake_array[1][3:0]);

        $stop;
    end

endmodule


