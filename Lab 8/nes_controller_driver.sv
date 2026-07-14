module nes_controller_driver (
    input  logic       clk,
    input  logic       rst,
    input  logic       nes_enable,        // one-cycle strobe from divider in top-level
    input  logic       nes_data_sync,     // already 2-FF CDC sync'd data line
    output logic       latch_out,         // NES latch pin
    output logic       clk_out,           // NES clock pin
    output logic [7:0] buttons            // stable decoded button bus
);

    logic [4:0] state_reg;
    logic [7:0] shift_reg;
    logic [7:0] buttons_reg;

    assign buttons = buttons_reg;

    always_ff @(posedge clk) begin
        if (rst) begin
            state_reg   <= 5'd0;
            shift_reg   <= 8'hFF;
            buttons_reg <= 8'hFF;
            latch_out   <= 1'b0;
            clk_out     <= 1'b0;
        end else if (nes_enable) begin
            case (state_reg)

                // Latch pulse
                5'd0: begin
                    latch_out <= 1'b1;
                    clk_out   <= 1'b0;
                    state_reg <= 5'd1;
                end

                5'd1: begin
                    latch_out <= 1'b0;
                    clk_out   <= 1'b0;
                    state_reg <= 5'd2;
                end

                // Bit 0: A
                5'd2: begin
                    shift_reg[0] <= nes_data_sync;
                    clk_out      <= 1'b0;
                    state_reg    <= 5'd3;
                end

                // Bit 1: B
                5'd3: begin
                    clk_out   <= 1'b1;
                    state_reg <= 5'd4;
                end

                5'd4: begin
                    shift_reg[1] <= nes_data_sync;
                    clk_out      <= 1'b0;
                    state_reg    <= 5'd5;
                end

                // Bit 2: Select
                5'd5: begin
                    clk_out   <= 1'b1;
                    state_reg <= 5'd6;
                end

                5'd6: begin
                    shift_reg[2] <= nes_data_sync;
                    clk_out      <= 1'b0;
                    state_reg    <= 5'd7;
                end

                // Bit 3: Start
                5'd7: begin
                    clk_out   <= 1'b1;
                    state_reg <= 5'd8;
                end

                5'd8: begin
                    shift_reg[3] <= nes_data_sync;
                    clk_out      <= 1'b0;
                    state_reg    <= 5'd9;
                end

                // Bit 4: Up
                5'd9: begin
                    clk_out   <= 1'b1;
                    state_reg <= 5'd10;
                end

                5'd10: begin
                    shift_reg[4] <= nes_data_sync;
                    clk_out      <= 1'b0;
                    state_reg    <= 5'd11;
                end

                // Bit 5: Down
                5'd11: begin
                    clk_out   <= 1'b1;
                    state_reg <= 5'd12;
                end

                5'd12: begin
                    shift_reg[5] <= nes_data_sync;
                    clk_out      <= 1'b0;
                    state_reg    <= 5'd13;
                end

                // Bit 6: Left
                5'd13: begin
                    clk_out   <= 1'b1;
                    state_reg <= 5'd14;
                end

                5'd14: begin
                    shift_reg[6] <= nes_data_sync;
                    clk_out      <= 1'b0;
                    state_reg    <= 5'd15;
                end

                // Bit 7: Right
                5'd15: begin
                    clk_out   <= 1'b1;
                    state_reg <= 5'd16;
                end

                5'd16: begin
                    shift_reg[7] <= nes_data_sync;
                    clk_out      <= 1'b0;
                    state_reg    <= 5'd17;
                end

                // Commit stable packet
                5'd17: begin
                    buttons_reg <= shift_reg;
                    clk_out     <= 1'b0;
                    state_reg   <= 5'd18;
                end

                // Idle gap until next poll
                default: begin
                    clk_out   <= 1'b0;
                    state_reg <= (state_reg == 5'd31) ? 5'd0 : state_reg + 5'd1;
                end

            endcase
        end
    end

endmodule

module nes_controller_driver_tb;

    logic       clk;
    logic       rst;
    logic       nes_enable;
    logic       nes_data_sync;
    logic       latch_out;
    logic       clk_out;
    logic [7:0] buttons;

    nes_controller_driver dut (
        .clk          (clk),
        .rst          (rst),
        .nes_enable   (nes_enable),
        .nes_data_sync(nes_data_sync),
        .latch_out    (latch_out),
        .clk_out      (clk_out),
        .buttons      (buttons)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic tick_enable;
        begin
            @(negedge clk);
            nes_enable = 1'b1;
            @(negedge clk);
            nes_enable = 1'b0;
        end
    endtask

    task automatic idle_to_next_poll;
        begin
            // After commit, DUT is in state 18.
            // States 18 through 31 are idle, then it wraps to 0.
            repeat (14) tick_enable();
        end
    endtask

    task automatic send_packet(input logic [7:0] pkt);
        int i;
        begin
            // State 0: latch high
            tick_enable();
            assert(latch_out === 1'b1);

            // State 1: latch low
            tick_enable();
            assert(latch_out === 1'b0);

            // State 2: sample bit 0 / A
            nes_data_sync = pkt[0];
            tick_enable();

            // States 3-16: clock then sample bits 1-7
            for (i = 1; i < 8; i++) begin
                tick_enable();              // raise clk_out, controller advances
                assert(clk_out === 1'b1);

                nes_data_sync = pkt[i];
                tick_enable();              // sample current bit
                assert(clk_out === 1'b0);
            end

            // State 17: commit shift_reg into buttons_reg
            tick_enable();
        end
    endtask

    task automatic check_packet(input logic [7:0] pkt);
        begin
            send_packet(pkt);
            assert(buttons === pkt)
                else $fatal(1, "buttons=%b expected=%b", buttons, pkt);
            idle_to_next_poll();
        end
    endtask

    initial begin
        rst           = 1'b1;
        nes_enable    = 1'b0;
        nes_data_sync = 1'b1;

        repeat (4) @(negedge clk);
        rst = 1'b0;

        assert(buttons === 8'hFF);

        // Normal cases
        check_packet(8'b1111_1111); // no buttons pressed
        check_packet(8'b1111_1110); // A pressed
        check_packet(8'b0111_1111); // Right pressed
        check_packet(8'b1110_1110); // A + Up pressed

        // Edge-ish cases
        check_packet(8'b0000_0000); // all buttons pressed
        check_packet(8'b1010_0101); // mixed pattern
        check_packet(8'b0101_1010); // opposite mixed pattern

        $stop;
    end

endmodule
