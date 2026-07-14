module adder9bit (
	input logic [8:0] a, b,
	output logic [8:0] sum, cout
);

	 logic [9:0] carry;
	
	 assign carry[0] = 1'b0;
    
	 // Chain 9 full adders
    full_adder fa0(.a(a[0]), .b(b[0]), .cin(carry[0]), .sum(sum[0]), .cout(carry[1]));
    full_adder fa1(.a(a[1]), .b(b[1]), .cin(carry[1]), .sum(sum[1]), .cout(carry[2]));
    full_adder fa2(.a(a[2]), .b(b[2]), .cin(carry[2]), .sum(sum[2]), .cout(carry[3]));
    full_adder fa3(.a(a[3]), .b(b[3]), .cin(carry[3]), .sum(sum[3]), .cout(carry[4]));
    full_adder fa4(.a(a[4]), .b(b[4]), .cin(carry[4]), .sum(sum[4]), .cout(carry[5]));
    full_adder fa5(.a(a[5]), .b(b[5]), .cin(carry[5]), .sum(sum[5]), .cout(carry[6]));
    full_adder fa6(.a(a[6]), .b(b[6]), .cin(carry[6]), .sum(sum[6]), .cout(carry[7]));
    full_adder fa7(.a(a[7]), .b(b[7]), .cin(carry[7]), .sum(sum[7]), .cout(carry[8]));
    full_adder fa8(.a(a[8]), .b(b[8]), .cin(carry[8]), .sum(sum[8]), .cout(carry[9]));

    assign cout = carry[9];

endmodule

module adder9bit_tb();
    logic [8:0] a, b, sum;
    logic cout;

    adder9bit dut(.a(a), .b(b), .sum(sum), .cout(cout));

    initial begin
        // 1. One input is 0
        a = 9'd0;   b = 9'd42;  #10;
        $display("0 + 42 = %0d, cout=%b (expect 42, 0)", sum, cout);

        // 2. Result is 511
        a = 9'd256; b = 9'd255; #10;
        $display("256 + 255 = %0d, cout=%b (expect 511, 0)", sum, cout);

        // 3. Result is 0 (not 0+0) — unsigned overflow wraps to 0
        a = 9'd256; b = 9'd256; #10;
        $display("256 + 256 = %0d, cout=%b (expect 0, 1)", sum, cout);

        // 4. Unsigned overflow — result exceeds 9 bits
        a = 9'd500; b = 9'd100; #10;
        $display("500 + 100 = %0d, cout=%b (expect overflow, cout=1)", sum, cout);

        // 5. Positive signed overflow (pos + pos = neg)
        // 9-bit signed max positive = 255 (0_1111_1111)
        // 255 + 1 = 256 which is 1_0000_0000 = -256 in signed
        a = 9'd255; b = 9'd1;   #10;
        $display("255 + 1 = %0d (unsigned), %0d (signed) — pos+pos=neg overflow", sum, $signed(sum));

        // 6. Negative signed overflow (neg + neg = pos)
        // -256 + -1 = -257, overflows back to positive
        a = 9'b100000000; b = 9'b111111111; #10;  // -256 + -1
        $display("-256 + -1 = %0d (unsigned), %0d (signed) — neg+neg=pos overflow", sum, $signed(sum));

        $stop;
    end
endmodule
