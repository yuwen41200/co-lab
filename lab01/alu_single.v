/**
 * A Single Bit Arithmetic Logic Unit
 * by NCTU CS 0000000 Po-han Chen, 0316213 Yu-wen Pwu
 */

module alu_single (
	input        src1,
	input        src2,
	input        less,
	input        src1_invert,
	input        src2_invert,
	input        cin,
	input  [1:0] operation,
	output       real_result,
	output       result,
	output       cout
);

wire A, B;

assign A = src1 ^ src1_invert;
assign B = src2 ^ src2_invert;

assign result = operation == 2'b00 ? (A & B)
	: (operation == 2'b01 ? (A | B)
	: (operation == 2'b10 ? (A ^ B ^ cin)
	: less));

assign cout = (A & B) | ((A ^ B) & cin);

always@( * )
begin

end

endmodule
