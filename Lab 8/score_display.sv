module score_display (
	input logic [7:0] snake_len, 
	output logic [6:0] display0, display1, display2
);
	
	logic [7:0] score;
	assign score = (snake_len >= 8'd3) ? snake_len - 8'd3 : 8'd0;
	
	logic [3:0] hundreds, tens, ones;
	assign hundreds = score / 100;
	assign tens = (score % 100) / 10;
	assign ones = score % 10;
	
	hex_decoder d2(.data(hundreds), .display(display2));
	hex_decoder d1(.data(tens), .display(display1));
	hex_decoder d0(.data(ones), .display(display0));
	
endmodule

module score_display_tb();
    logic [7:0] snake_len;
    logic [6:0] disp0, disp1, disp2;

    score_display dut (.snake_len, .display0(disp0), .display1(disp1), .display2(disp2));

    // expected 7-seg patterns for hex_decoder (active-low segments, standard mapping)
    // adjust if your hex_decoder uses a different encoding
    localparam [6:0] SEG_0 = 7'b100_0000;
    localparam [6:0] SEG_1 = 7'b111_1001;
    localparam [6:0] SEG_2 = 7'b010_0100;

    initial begin
        // len < 3 -> score 0, all displays show 0
        snake_len = 8'd2; #1;
        assert(disp0 == SEG_0 && disp1 == SEG_0 && disp2 == SEG_0)
            else $error("TC1 FAIL: len=2 score should be 0,0,0  got %b %b %b", disp2, disp1, disp0);

        // len=3 -> score=0 (3-3=0)
        snake_len = 8'd3; #1;
        assert(disp0 == SEG_0 && disp1 == SEG_0 && disp2 == SEG_0)
            else $error("TC2 FAIL: len=3 score should be 0");

        // len=4 -> score=1
        snake_len = 8'd4; #1;
        assert(disp0 == SEG_1 && disp1 == SEG_0 && disp2 == SEG_0)
            else $error("TC3 FAIL: len=4 score should be 1  got %b %b %b", disp2, disp1, disp0);

        // len=13 -> score=10: ones=0, tens=1, hundreds=0
        snake_len = 8'd13; #1;
        assert(disp0 == SEG_0 && disp1 == SEG_1 && disp2 == SEG_0)
            else $error("TC4 FAIL: len=13 score should be 010  got %b %b %b", disp2, disp1, disp0);

        // len=103 -> score=100: ones=0, tens=0, hundreds=1
        snake_len = 8'd103; #1;
        assert(disp0 == SEG_0 && disp1 == SEG_0 && disp2 == SEG_1)
            else $error("TC5 FAIL: len=103 score should be 100  got %b %b %b", disp2, disp1, disp0);

        // len=0 -> score=0 (underflow guard)
        snake_len = 8'd0; #1;
        assert(disp0 == SEG_0 && disp1 == SEG_0 && disp2 == SEG_0)
            else $error("TC6 FAIL: len=0 score should be 0");

        $display("score_display_tb passed");
        $stop;
    end
endmodule
