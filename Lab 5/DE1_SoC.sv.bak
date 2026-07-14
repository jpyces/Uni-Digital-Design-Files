module DE1_SoC #(
  parameter whichClock = 25
  )
  (
  input  logic       CLOCK_50,  // 50MHz clock
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
  output logic [9:0] LEDR,
  input  logic [3:0] KEY,     // True when not pressed, False when pressed
  input  logic [9:0] SW
  );

  // Generate clk off of CLOCK_50, whichClock picks rate.
  logic [31:0] clk;
  clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(clk));

  // Hook up FSM inputs and outputs.
  logic  reset, w, out;
  assign reset = ~KEY[0];    // Reset when KEY[0] is pressed.
  assign w = ~KEY[1];

  simpleFSM fsm (.clk(clk[whichClock]), .reset, .w, .out);

  // Show signals on LEDRs so we can see what is happening.
  assign LEDR = {clk[whichClock], 1'b0, reset, 2'b0, out};

endmodule  // DE1_SoC
