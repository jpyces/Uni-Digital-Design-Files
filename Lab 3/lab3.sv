/* Top-level module that defines the I/Os for the DE1-SoC board
 * and the circuit behavior.
 */
module lab3 (
  // define ports
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
  output logic [9:0] LEDR,
  input  logic [3:0] KEY,
  input  logic [9:0] SW
  );

	
	Nordstrom nord(.U(SW[9]), .P(SW[8]), .C(SW[7]), .Mark(SW[0]), .Discounted(LEDR[9]), .Stolen(LEDR[0]));

  /////////////////////////////////
  // NO CHANGES NEEDED
  /////////////////////////////////

  // instantiate a mux2_1 module for you to play with

  // turns off the HEX displays (covered and used later in the course)
  assign HEX0 = '1;
  assign HEX1 = '1;
  assign HEX2 = '1;
  assign HEX3 = '1;
  assign HEX4 = '1;
  assign HEX5 = '1;

endmodule  // lab3
 