/**
 * Top Module: A 32-bit Arithmetic Logic Unit
 * by NCTU CS 0000000 Po-han Chen, 0316213 Yu-wen Pwu
 */

module alu(
	input         rst_n,         // negative reset
	input  [31:0] src1,          // source 1
	input  [31:0] src2,          // source 2
	input  [3:0]  ALU_control,   // ALU control input
	input  [2:0]  bonus_control, // bonus control input
	output [31:0] result,        // result
	output        zero,          // when the output is 0, zero must be set
	output        cout,          // carry out
	output        overflow       // overflow
);

wire [31:0] less;
wire        A_invert;
wire        B_invert;
wire [32:0] cin;
wire [1:0]  operation;
wire [31:0] real_result;

// Meaning of signal `ALU_control`
// And  0000    a &  b
// Or   0001    a |  b
// Add  0010    a +  b
// Sub  0110    a +  b'
// NOr  1100   ~a & ~b
// NAnd 1101   ~a | ~b
// SLT  0111 -> bonus_control

assign less[31:1] = 31'b0;
assign A_invert = (ALU_control == 4'b1100 || ALU_control == 4'b1101) ? 1 : 0;
assign B_invert = (ALU_control == 4'b0110 || ALU_control == 4'b1100 ||
                   ALU_control == 4'b1101 || ALU_control == 4'b0111) ? 1 : 0;
assign cin[0] = (ALU_control == 4'b0110 || ALU_control == 4'b0111) ? 1 : 0;
assign operation = ((ALU_control == 4'b0000 || ALU_control == 4'b1100) ? 2'b00 // &
                 : ((ALU_control == 4'b0001 || ALU_control == 4'b1101) ? 2'b01 // |
                 : ((ALU_control == 4'b0010 || ALU_control == 4'b0110) ? 2'b10 // +
                 :   2'b11)));                                                 // SLT

// Meaning of signal `bonus_control`
// Set Less Than   000    a + b' < 0
// Set Great Than  001    a + b' > 0
// Set Less Equal  010  !(a + b' > 0)
// Set Great Equal 011  !(a + b' < 0)
// Set Equal       110    a + b' = 0
// Set Not Equal   100  !(a + b' = 0)

assign overflow = cin[32] ^ cin[31];
assign zero = (real_result == 32'b0);
assign cout = cin[32];
assign less[0] = ((bonus_control == 3'b000 &&   real_result[31] == 1)           ? 1
               : ((bonus_control == 3'b001 &&  (real_result[31] == 0 && ~zero)) ? 1
               : ((bonus_control == 3'b010 && !(real_result[31] == 0 && ~zero)) ? 1
               : ((bonus_control == 3'b011 &&  !real_result[31] == 1)           ? 1
               : ((bonus_control == 3'b110 &&   zero)                           ? 1
               : ((bonus_control == 3'b100 &&  ~zero)                           ? 1
               :   0))))));

generate
	genvar i;
	for (i = 0; i < 32; i = i + 1) begin:alu_top_group
		alu_top alu_top_ins (
			.src1(src1[i]),
			.src2(src2[i]),
			.less(less[i]),
			.A_invert(A_invert),
			.B_invert(B_invert),
			.cin(cin[i]),
			.operation(operation),
			.real_result(real_result[i]),
			.result(result[i]),
			.cout(cin[i+1])
		);
	end
endgenerate

endmodule
