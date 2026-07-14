module game_tick_gen #(
    parameter CLK_FREQ     = 50_000_000,
    parameter TICKS_PER_SEC = 4
)(
    input  logic        clk, rst,
    input  logic [8:0]  switches,
    output logic        game_tick
);
    logic [31:0] count_max;
    logic [31:0] count;

    assign count_max = (switches > 0) ? CLK_FREQ / switches - 1 : CLK_FREQ / TICKS_PER_SEC - 1;

    always_ff @(posedge clk) begin
        if (rst) count <= 0;
        else if (count >= count_max) count <= 0;
        else count <= count + 1;
    end

    assign game_tick = (count == 0);
endmodule

module game_tick_gen_tb();
    logic clk, rst;
    logic [8:0] switches;
    logic game_tick;

    localparam CLK_FREQ = 100;
    game_tick_gen #(.CLK_FREQ(CLK_FREQ)) dut (.*);

    always #10 clk = ~clk;

    // measure cycles between two consecutive game_ticks
    task automatic measure_period(output int period);
        int t;
        @(posedge game_tick);
        t = 0;
        @(posedge game_tick);
        // count cycles elapsed — approximate via $time
        period = 0; // placeholder; use waveform or cycle counter below
    endtask

    int cycle_count;
    always_ff @(posedge clk) begin
        if (rst) cycle_count <= 0;
        else      cycle_count <= cycle_count + 1;
    end

    int t_start, t_end, period;

    initial begin
        clk = 0; rst = 1; switches = 0;
        @(posedge clk); rst = 0;

        // --- default speed: TICKS_PER_SEC=4, CLK_FREQ=100 -> period=25 cycles ---
        @(posedge game_tick); t_start = cycle_count;
        @(posedge game_tick); t_end   = cycle_count;
        period = t_end - t_start;
        assert(period == 25)
            else $error("default period=%0d expected 25", period);

        // game_tick must be a single-cycle pulse
        @(posedge game_tick);
        @(posedge clk);
        assert(game_tick == 0)
            else $error("game_tick not a single-cycle pulse");

        // --- switches=10: period = CLK_FREQ/10 = 10 cycles ---
        switches = 9'd10;
        @(posedge game_tick); t_start = cycle_count;
        @(posedge game_tick); t_end   = cycle_count;
        period = t_end - t_start;
        assert(period == 10)
            else $error("switches=10 period=%0d expected 10", period);

        // --- reset mid-run restarts counter ---
        switches = 9'd0;
        repeat(5) @(posedge clk);
        rst = 1; @(posedge clk); rst = 0;
        @(posedge game_tick); t_start = cycle_count;
        @(posedge game_tick); t_end   = cycle_count;
        period = t_end - t_start;
        assert(period == 25)
            else $error("post-reset period=%0d expected 25", period);

        $display("game_tick_gen_tb passed");
        $stop;
    end
endmodule

