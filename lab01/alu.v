/**
 * Top Module: A 32-bit Arithmetic Logic Unit
 * by NCTU CS 0113110 Po-han Chen, 0316213 Yu-wen Pwu
 */

module alu (
	input         rst_n,         // negative reset
	input  [31:0] src1,          // source 1
	input  [31:0] src2,          // source 2
	input  [3:0]  ALU_control,   // ALU control input
	input  [2:0]  bonus_control, // bonus control input
	output [31:0] result,        // result
	output        zero,          // result is 0
	output        cout,          // carry out
	output        overflow       // overflow
);

reg         less;
wire        real_less;
wire        equal;
wire        src1_invert;
wire        src2_invert;
wire        src1_31;
wire        src2_31;
wire [32:0] cin;
wire [1:0]  operation;

// Meaning of signal `ALU_control`
// And  0000    a &  b
// Or   0001    a |  b
// Add  0010    a +  b
// Sub  0110    a +  b'
// NOr  1100   ~a & ~b
// NAnd 1101   ~a | ~b
// SLT  0111 -> bonus_control

assign cin[0] = (ALU_control == 4'b0110 || ALU_control == 4'b0111) ? 1 : 0;

assign src1_invert = (ALU_control == 4'b1100 || ALU_control == 4'b1101) ? 1 : 0;
assign src2_invert = (ALU_control == 4'b0110 || ALU_control == 4'b1100 ||
                      ALU_control == 4'b1101 || ALU_control == 4'b0111) ? 1 : 0;

assign src1_31 = src1[31] ^ src1_invert;
assign src2_31 = src2[31] ^ src2_invert;

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
assign zero = (result == 32'b0);
assign cout = (ALU_control == 4'b0010 || ALU_control == 4'b0110) ? cin[32] : 0;
assign equal = (src1 == src2);
assign real_less = (src1_31 ^ src2_31 ^ cin[31]) | (src1_31 && src2_31 && !cin[31]);

always @(*) begin
	case (bonus_control)
		3'b000:  less =   real_less;
		3'b001:  less = !(real_less || equal);
		3'b010:  less =  (real_less || equal);
		3'b011:  less =  !real_less;
		3'b110:  less =   equal;
		3'b100:  less =  !equal;
		default: less =   real_less;
	endcase
end

alu_single alu_single_ins_0 (
	.src1(src1[0]),
	.src2(src2[0]),
	.less(less),
	.src1_invert(src1_invert),
	.src2_invert(src2_invert),
	.cin(cin[0]),
	.operation(operation),
	.result(result[0]),
	.cout(cin[1])
);

generate
	genvar i;
	for (i = 1; i < 32; i = i + 1) begin:alu_single_group
		alu_single alu_single_ins (
			.src1(src1[i]),
			.src2(src2[i]),
			.less(0),
			.src1_invert(src1_invert),
			.src2_invert(src2_invert),
			.cin(cin[i]),
			.operation(operation),
			.result(result[i]),
			.cout(cin[i+1])
		);
	end
endgenerate

endmodule
