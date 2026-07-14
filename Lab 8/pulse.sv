module pulse (input logic clk, reset, in, output logic out);

  enum logic {ZERO, ONE} ps, ns;

  assign ns = in ? ONE : ZERO;

  always_ff @(posedge clk)
    ps <= reset ? ZERO : ns;

  assign out = (ps == ZERO) & in;

endmodule  // pulse

module pulse_tb();
    logic clk, rst, in, out;
    pulse dut (.clk, .reset(rst), .in, .out);
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; in = 0;
        @(posedge clk); #1; rst = 0;

        // no pulse when in=0
        @(posedge clk); #1;

        // rising edge fires pulse
        in = 1;
        @(posedge clk); #1;

        // held high, no re-pulse
        @(posedge clk); #1;

        // falling then rising re-triggers
        in = 0;
		  
        in = 1;
        @(posedge clk); #1;

        $stop;
    end
endmodule
