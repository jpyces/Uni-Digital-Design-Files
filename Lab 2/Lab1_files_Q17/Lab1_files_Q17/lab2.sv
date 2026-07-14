/* Top-level module that defines the I/Os for the DE1-SoC board
 * and the circuit behavior.
 */
module lab2 (
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
  output logic [9:0] LEDR,
  input  logic [3:0] KEY,
  input  logic [9:0] SW
  );

  // Default values, turns off the HEX displays
  assign HEX0 = 7'b1111111;
  assign HEX1 = 7'b1111111;
  assign HEX2 = 7'b1111111;
  assign HEX3 = 7'b1111111;
  assign HEX4 = 7'b1111111;
  assign HEX5 = 7'b1111111;

  // Logic to check if SW3-SW0 match your bottom digit,
  // Switch signals
  logic A, B, C, D, E, F, G, H;
  
  // Intermediate Signals
  logic nA, nB, CD, nBCD, v1, v2, nF, GH, nFGH;
  
  assign A = SW[3];
  assign B = SW[2];
  assign C = SW[1];
  assign D = SW[0];
  
  not gate1(nA, A);
  not gate2(nB, B);
  nor gate3(CD, C, D);
  nand gate4(nBCD, nB, CD);
  nor lastDigCheck(v1, nA, nBCD);
  
  // and SW7-SW4 match the next.
  assign E = SW[7];
  assign F = SW[6];
  assign G = SW[5];
  assign H = SW[4];
  
  not gate5(nF, F);
  nor gate6(GH, G, H);
  nand gate7(nFGH, nF, GH);
  nor gate8(v2, E, nFGH);
  
  // Result should drive LEDR0.
  // Final AND
  and last(LEDR[0], v1, v2);
  

endmodule  // lab2

/* Testbench for the lab2 module defined above, testing
 * all combinations of inputs.
 */
module lab2_tb();
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [9:0] LEDR;
  logic [3:0] KEY;
  logic [9:0] SW;

  // instantiate device under test
  lab2 dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

  // test input sequence - try all combinations of inputs
  integer i;
  initial begin
    SW[9] = 1'b0;
    SW[8] = 1'b0;
    for(i = 0; i < 256; i++) begin
      SW[7:0] = i; #10;
    end
  end
endmodule  // lab2_tb
