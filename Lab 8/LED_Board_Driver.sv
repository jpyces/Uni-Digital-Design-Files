module LED_Board_Driver #(parameter MAX_LENGTH = 256) (
    input logic game_rst,
    input logic [3:0] apple_x, apple_y,
    input logic [7:0] snake_array [0:MAX_LENGTH-1],
    input logic [7:0] snake_len,
    output logic [15:0][15:0] RedPixels, GreenPixels
);
    logic [15:0][15:0] red_next, green_next;

    always_comb begin
        red_next   = '0;
        green_next = '0;

        red_next[apple_x][apple_y] = 1;

        for (int i = 0; i < MAX_LENGTH; i++) begin
            if (i < snake_len) begin
                green_next[snake_array[i][7:4]][snake_array[i][3:0]] = 1;
				end
        end
    end

    assign RedPixels   = red_next;
    assign GreenPixels = green_next;

endmodule

module LED_Board_Driver_tb();
    parameter MAX_LENGTH = 4;
    logic [3:0] apple_x, apple_y;
    logic [7:0] snake_array [0:MAX_LENGTH-1];
    logic [7:0] snake_len;
    logic [15:0][15:0] RedPixels, GreenPixels;
    logic game_rst;

    LED_Board_Driver #(.MAX_LENGTH(MAX_LENGTH)) dut (.*);

    initial begin
        for (int i = 0; i < MAX_LENGTH; i++) snake_array[i] = 8'hFF;
        game_rst = 0; snake_len = 0; apple_x = 4'd3; apple_y = 4'd5; #1;

        // TC1: apple pixel lit in red
        assert(RedPixels[3][5]) $display("apple lit correctly! PASS");
            else $error("TC1 FAIL: apple not lit");

        // TC2: apple not lit in green
        assert(!GreenPixels[3][5]) $display("apple not lit in green! PASS");
            else $error("TC2 FAIL: apple lit in green");

        // TC3: head segment lit in green
        snake_array[0] = 8'hAB; snake_len = 8'd1; #1;
        assert(GreenPixels[4'hA][4'hB]) $display("head lit in green! PASS");
            else $error("TC3 FAIL: head not lit");

        // TC4: sentinel (0xFF) not lit when outside snake_len
        assert(!GreenPixels[4'hF][4'hF]) $display("TC4 sentinel not lit PASS");
            else $error("TC4 FAIL: sentinel lit");

        // TC5: segment beyond snake_len not lit
        snake_array[1] = 8'h12; snake_len = 8'd1; #1;
        assert(!GreenPixels[4'h1][4'h2]) $display("TC5 - beyond snake_len NOT lit PASS");
            else $error("TC5 FAIL: out-of-bounds segment lit");

        // TC6: multiple body segments all lit
        snake_array[0] = 8'h11; snake_array[1] = 8'h22;
        snake_array[2] = 8'h33; snake_len = 8'd3; #1;
        assert(GreenPixels[1][1] && GreenPixels[2][2] && GreenPixels[3][3]) $display("TC6 - ALL BODY SEGMENTS LIT - PASS");
            else $error("TC6 FAIL: not all body segments lit");

        // TC7: apple and snake same cell — both red and green lit
        apple_x = 4'd1; apple_y = 4'd1; #1;
        assert(RedPixels[1][1] && GreenPixels[1][1]) $display("TC7 - OVERQ - PASS");
            else $error("TC7 FAIL: overlap cell not lit in both colors");

        $display("LED_Board_Driver_tb finished");
        $stop;
    end
endmodule


