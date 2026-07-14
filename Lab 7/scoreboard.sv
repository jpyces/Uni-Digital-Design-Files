module scoreboard(
    input  logic clk,
    input  logic rst,
    input  logic p1win,
    input  logic p2win,
    output logic [6:0] display0,
    output logic [6:0] display1,
    output logic playfield_rst
);

    logic [2:0] score_p1, score_p2;
    logic p1win_pulse, p2win_pulse;

    // Use pulse module instead of manual one-shot logic
    pulse p1_pulse(.clk(clk), .reset(rst), .in(p1win), .out(p1win_pulse));
    pulse p2_pulse(.clk(clk), .reset(rst), .in(p2win), .out(p2win_pulse));

    counter3bit c1(.clk(clk), .rst(rst), .win(p1win_pulse), .count(score_p1));
    counter3bit c2(.clk(clk), .rst(rst), .win(p2win_pulse), .count(score_p2));

    seg7_decoder d1(.num(score_p1), .display(display0));
    seg7_decoder d2(.num(score_p2), .display(display1));

    assign playfield_rst = rst | p1win_pulse | p2win_pulse;

endmodule


module scoreboard_tb();
    logic clk, rst, p1win, p2win;
    logic [6:0] display0, display1;
    logic playfield_rst;

    scoreboard dut(
        .clk(clk), .rst(rst),
        .p1win(p1win), .p2win(p2win),
        .display0(display0), .display1(display1),
        .playfield_rst(playfield_rst)
    );

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        // Initialize
        rst <= 1; p1win <= 0; p2win <= 0; @(posedge clk);
                                           @(posedge clk);
        rst <= 0;                          @(posedge clk);
                                           @(posedge clk);

        // Player 1 wins 3 times
        repeat(3) begin
            p1win <= 1; @(posedge clk);
            p1win <= 0; @(posedge clk);
                        @(posedge clk); // let pulse settle
        end

        // Player 2 wins 2 times
        repeat(2) begin
            p2win <= 1; @(posedge clk);
            p2win <= 0; @(posedge clk);
                        @(posedge clk);
        end

        // Test playfield_rst fires on win
        p1win <= 1; @(posedge clk);
        p1win <= 0; @(posedge clk);

        // Full reset - scores should go to 0
        rst <= 1; @(posedge clk);
        rst <= 0; @(posedge clk);

        $stop;
    end
endmodule
