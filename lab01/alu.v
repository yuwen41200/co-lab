`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 02/25/2016
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		 //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

/*reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;*/


wire cin1, cin2, cin3, cin4, cin5, cin6, cin7, cin8, cin9, cin10, cin11, cin12, cin13, cin14, cin15, cin16, cin17, cin18, cin19, cin20, cin21, cin22, cin23, cin24, cin25, cin26, cin27, cin28, cin29, cin30, cin31;
wire A_invert, B_invert;
wire [1:0] operation, operation0;
wire less;
wire cin32;
wire [32-1:0] result_tmp;
wire result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12, result13, result14, result15, result16, result17, result18, result19, result20, result21, result22, result23, result24, result25, result26, result27, result28, result29, result30, result31;

assign A_invert = ALU_control == 4'b1100 || ALU_control == 4'b1101 ? 1 : 0;
assign B_invert = ALU_control == 4'b0110 || ALU_control == 4'b1100 || ALU_control == 4'b1101 || ALU_control == 4'b0111 ? 1 : 0;
assign operation = ALU_control == 4'b0000 || ALU_control == 4'b1100 ? 2'b00
	: (ALU_control == 4'b0001 || ALU_control == 4'b1101 ? 2'b01
	: (ALU_control == 4'b0010 || ALU_control == 4'b0110 ? 2'b10
	: (ALU_control == 4'b0111 ? 2'b11
	: 2'b11))); // pending changes for bonus operations
assign operation0 = ALU_control == 4'b0111 ? 2'b11 : operation;
assign cin0 = ALU_control == 4'b0110 || ALU_control == 4'b0111 ? 1 : 0;

wire msb1, msb2;

alu_top alu0(.src1(src1[0]), .src2(src2[0]), .less(less), .A_invert(A_invert), .B_invert(B_invert), .cin(cin0), .operation(operation0), .result(result0), .cout(cin1));
alu_top alu1(.src1(src1[1]), .src2(src2[1]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin1), .operation(operation), .result(result1), .cout(cin2));
alu_top alu2(.src1(src1[2]), .src2(src2[2]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin2), .operation(operation), .result(result2), .cout(cin3));
alu_top alu3(.src1(src1[3]), .src2(src2[3]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin3), .operation(operation), .result(result3), .cout(cin4));
alu_top alu4(.src1(src1[4]), .src2(src2[4]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin4), .operation(operation), .result(result4), .cout(cin5));
alu_top alu5(.src1(src1[5]), .src2(src2[5]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin5), .operation(operation), .result(result5), .cout(cin6));
alu_top alu6(.src1(src1[6]), .src2(src2[6]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin6), .operation(operation), .result(result6), .cout(cin7));
alu_top alu7(.src1(src1[7]), .src2(src2[7]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin7), .operation(operation), .result(result7), .cout(cin8));
alu_top alu8(.src1(src1[8]), .src2(src2[8]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin8), .operation(operation), .result(result8), .cout(cin9));
alu_top alu9(.src1(src1[9]), .src2(src2[9]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin9), .operation(operation), .result(result9), .cout(cin10));
alu_top alu10(.src1(src1[10]), .src2(src2[10]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin10), .operation(operation), .result(result10), .cout(cin11));
alu_top alu11(.src1(src1[11]), .src2(src2[11]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin11), .operation(operation), .result(result11), .cout(cin12));
alu_top alu12(.src1(src1[12]), .src2(src2[12]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin12), .operation(operation), .result(result12), .cout(cin13));
alu_top alu13(.src1(src1[13]), .src2(src2[13]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin13), .operation(operation), .result(result13), .cout(cin14));
alu_top alu14(.src1(src1[14]), .src2(src2[14]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin14), .operation(operation), .result(result14), .cout(cin15));
alu_top alu15(.src1(src1[15]), .src2(src2[15]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin15), .operation(operation), .result(result15), .cout(cin16));
alu_top alu16(.src1(src1[16]), .src2(src2[16]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin16), .operation(operation), .result(result16), .cout(cin17));
alu_top alu17(.src1(src1[17]), .src2(src2[17]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin17), .operation(operation), .result(result17), .cout(cin18));
alu_top alu18(.src1(src1[18]), .src2(src2[18]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin18), .operation(operation), .result(result18), .cout(cin19));
alu_top alu19(.src1(src1[19]), .src2(src2[19]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin19), .operation(operation), .result(result19), .cout(cin20));
alu_top alu20(.src1(src1[20]), .src2(src2[20]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin20), .operation(operation), .result(result20), .cout(cin21));
alu_top alu21(.src1(src1[21]), .src2(src2[21]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin21), .operation(operation), .result(result21), .cout(cin22));
alu_top alu22(.src1(src1[22]), .src2(src2[22]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin22), .operation(operation), .result(result22), .cout(cin23));
alu_top alu23(.src1(src1[23]), .src2(src2[23]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin23), .operation(operation), .result(result23), .cout(cin24));
alu_top alu24(.src1(src1[24]), .src2(src2[24]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin24), .operation(operation), .result(result24), .cout(cin25));
alu_top alu25(.src1(src1[25]), .src2(src2[25]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin25), .operation(operation), .result(result25), .cout(cin26));
alu_top alu26(.src1(src1[26]), .src2(src2[26]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin26), .operation(operation), .result(result26), .cout(cin27));
alu_top alu27(.src1(src1[27]), .src2(src2[27]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin27), .operation(operation), .result(result27), .cout(cin28));
alu_top alu28(.src1(src1[28]), .src2(src2[28]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin28), .operation(operation), .result(result28), .cout(cin29));
alu_top alu29(.src1(src1[29]), .src2(src2[29]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin29), .operation(operation), .result(result29), .cout(cin30));
alu_top alu30(.src1(src1[30]), .src2(src2[30]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin30), .operation(operation), .result(result30), .cout(cin31));
alu_top alu31(.src1(src1[31]), .src2(src2[31]), .less(0), .A_invert(A_invert), .B_invert(B_invert), .cin(cin31), .operation(operation), .result(result31), .cout(cin32));

assign result = {result31, result30, result29, result28, result27, result26, result25, result24, result23, result22, result21, result20, result19, result18, result17, result16, result15, result14, result13, result12, result11, result10, result9, result8, result7, result6, result5, result4, result3, result2, result1, result0};

assign overflow = cin32 ^ cin31;
assign cout = cin32;
assign zero = !overflow && result == 32'b0;

assign msb1 = src1[31] ^ A_invert;
assign msb2 = src2[31] ^ B_invert;
assign less = (msb1 ^ msb2 ^ cin31) | (msb1 && msb2 && !cin31); // wrong

endmodule
