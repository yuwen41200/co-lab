/**
 * A Single Bit Arithmetic Logic Unit
 * by NCTU CS 0113110 Po-han Chen, 0316213 Yu-wen Pwu
 */

module alu_single (
	input        src1,        // source 1
	input        src2,        // source 2
	input        less,        // less signal
	input        src1_invert, // invert source 1
	input        src2_invert, // invert source 2
	input        cin,         // carry in
	input  [1:0] operation,   // operation input
	output       real_result, // calculated result
	output       result,      // final result
	output       cout         // carry out
);

wire a, b;

// Meaning of signal `operation`
// 00 &
// 01 |
// 10 +
// 11 SLT

assign a = src1 ^ src1_invert;
assign b = src2 ^ src2_invert;

assign real_result = ((operation == 2'b00) ? (a & b)
                   : ((operation == 2'b01) ? (a | b)
                   :  (a ^ b ^ cin)));

assign result = (operation == 2'b11) ? less : real_result;
assign cout = (a & b) | ((a ^ b) & cin);

endmodule
