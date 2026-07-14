module lfsr9bit(
	input logic clk, rst,
	output logic [8:0] Q
);

	always_ff @(posedge clk) begin
		if (rst)
			Q <= 9'b000000000;
		else begin
			Q[8] <= Q[7];
			Q[7] <= Q[6];
			Q[6] <= Q[5];
			Q[5] <= Q[4];
			Q[4] <= Q[3];
			Q[3] <= Q[2];
			Q[2] <= Q[1];
			Q[1] <= Q[0];
			Q[0] <= ~(Q[8] ^ Q[4]);
			
		end
			
	end
	
endmodule

module lfsr9bit_tb();
    logic clk, rst;
    logic [8:0] Q;
	 int cycle_count;

    lfsr9bit dut(.clk(clk), .rst(rst), .Q(Q));

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
			cycle_count = 0;
        // Reset
        rst <= 1; @(posedge clk);
                  @(posedge clk);
        rst <= 0; @(posedge clk);

        /* Run for 511 cycles (2^9 - 1), checking for state repeat
        repeat(511) begin
            @(posedge clk);
            $display("Q = %b", Q);
            if (Q == 9'b000000000) begin
                $display("Cycle repeated at count: max-length sequence confirmed");
                $stop;
            end
        end*/
		  
		  for (int i = 0; i < 511; i++) begin
				@(posedge clk);
				cycle_count = i+1;
				$display("Cycle %0d: Q = %b", cycle_count, Q);
				
				if (Q == 9'b000000000) begin
					$display("State repreated at cycle %0d", cycle_count);
					$stop;
				end
		 
		  end

        // If we get here without stopping, something is wrong
        $display("ERROR: state did not repeat after 511 cycles");
        $stop;
    end

endmodule

