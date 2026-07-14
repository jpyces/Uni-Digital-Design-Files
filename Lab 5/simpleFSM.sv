// Simple FSM to recognize sequences of 1-1 on input w.
// out is raised when w has been true for two consecutive clock cycles.
//
// Our FSM code has four parts:
// 1. variable, net, and state declarations/definitions
// 2. Next State Logic (always_comb)
// 3. Output Logic (assign or always_comb)
// 3. Sequential Logic (always_ff)
module simpleFSM (
  input  logic clk, reset, w,
  output logic out
  );

  // State Encoding and Variables
  // An enum is a straightforward way to assign clear names to our FSM states
  // while also being able to specify the bit representation of each state.
  // ps = "present state", ns = "next state".
  enum logic [1:0] {S_0 = 2'b00, S_1 = 2'b01, S_11 = 2'b10} ps, ns;

  // FSM Next State Logic
  always_comb
    case (ps)
      S_0:  if (w) ns = S_1;   // saw first 1 on w
            else   ns = S_0;
      S_1:  if (w) ns = S_11;  // saw second 1 on w
            else   ns = S_0;
      S_11: if (w) ns = S_11;  // stay here if 1 on w
            else   ns = S_0;
      default:     ns = ps;
    endcase

  // Output Logic
  // Note: this statement could be placed above the FSM case statement, in a
  // separate always_comb block, or outside the always_comb block as an
  // assign statement because it depends only on the current value of ps.
  assign out = (ns == S_11);

  // Sequential Logic
  // Only state is FSM state.
  // Synchronous reset signal to set FSM to its first state.
  always_ff @(posedge clk)
    if (reset)
      ps <= S_0;
    else
      ps <= ns;

endmodule  // simpleFSM

// Testbench for simpleFSM
module simpleFSM_tb ();
  logic clk, reset, w;
  logic out;

  simpleFSM dut (.clk, .reset, .w, .out);

  // Set up the clock
  parameter CLOCK_PERIOD=100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
  end

  // Set up the inputs to the design. Each line is a clock cycle.
  initial begin
    // Defining ALL input signals at t = 0 will avoid red (undefined) signals
    // in your simulation.
    reset <= 1; w <= 0; @(posedge clk);
    reset <= 0; w <= 0; @(posedge clk);
                        @(posedge clk);
                        @(posedge clk);
                        @(posedge clk);
                w <= 1; @(posedge clk);
                w <= 0; @(posedge clk);
                w <= 1; @(posedge clk);
                        @(posedge clk);
                        @(posedge clk);
                        @(posedge clk);
                w <= 0; @(posedge clk);
                        @(posedge clk);
    $stop;  // pause the simulation
  end
endmodule  // simpleFSM_tb
