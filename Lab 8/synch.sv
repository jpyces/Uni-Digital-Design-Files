module synch (input logic clk, reset, in, output logic out);

  logic mid;  // output of first FF, could be named anything

  always_ff @(posedge clk)
    if (reset)
      {mid, out} <= 2'b00;
    else
      {mid, out} <= {in, mid};

endmodule  // synch

module synch_tb();
    logic clk, rst, in, out;
    synch dut (.clk, .reset(rst), .in, .out);
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; in = 0;
        @(posedge clk); #1; rst = 0;

        // in=0 stays 0
        @(posedge clk); #1;
        @(posedge clk); #1;

        // needs 2 cycles to propagate
        in = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;

        // reset clears
        rst = 1;
        @(posedge clk); #1;

        $stop;
    end
endmodule
