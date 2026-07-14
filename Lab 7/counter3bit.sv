module counter3bit (
	input logic clk, rst, win,
	output logic [2:0] count
);

	always_ff @(posedge clk) begin
		if (rst)
			count <= 3'b000;
		else if (win)
			count <= count + 3'd1;
	end
endmodule

module counter3bit_tb();
    logic clk, rst, win;
    logic [2:0] count;

    counter3bit dut(.clk(clk), .rst(rst), .win(win), .count(count));

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        rst <= 1; win <= 0; @(posedge clk);
        rst <= 0;           @(posedge clk);

        // Count up from 0 to 7
        repeat(8) begin
            win <= 1; @(posedge clk);
            win <= 0; @(posedge clk);
        end

        // Test reset mid-count
        win <= 1; @(posedge clk);
        win <= 0; @(posedge clk);

        rst <= 1; @(posedge clk);
        rst <= 0; @(posedge clk);

        $stop;
    end
endmodule
