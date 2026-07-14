module presser(
    input  logic clk,
    input  logic rst,
    input  logic [8:0] tune,    // directly from SW[8:0]
    output logic press
);
    logic [8:0] lfsr_out;
    //logic [8:0] sum;
	logic cout;

    lfsr9bit lfsr(.clk(clk), .rst(rst), .Q(lfsr_out));

    adder9bit adder(.a(lfsr_out), .b(tune), .sum(), .cout(cout));

    assign press = cout;

endmodule
