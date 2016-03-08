`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:59:42 03/08/2016
// Design Name:   alu_top
// Module Name:   D:/co-lab/lab01/testbench_top.v
// Project Name:  lab01
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_top;

	// Inputs
	reg src1;
	reg src2;
	reg less;
	reg A_invert;
	reg B_invert;
	reg cin;
	reg [1:0] operation;

	// Outputs
	wire result;
	wire cout;
	
	integer i;

	// Instantiate the Unit Under Test (UUT)
	alu_top uut (
		.src1(src1), 
		.src2(src2), 
		.less(less), 
		.A_invert(A_invert), 
		.B_invert(B_invert), 
		.cin(cin), 
		.operation(operation), 
		.result(result), 
		.cout(cout)
	);

	initial begin
		// Initialize Inputs
		src1 = 0;
		src2 = 0;
		less = 0;
		A_invert = 0;
		B_invert = 0;
		cin = 0;
		operation = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for (i = 0; i < 8; i = i + 1) begin
			A_invert = 0;
			{cin, src1, src2} = i[2:0];
			#10;
			A_invert = 1;
			{cin, src1, src2} = i[2:0];
			#10;
		end
	end
      
endmodule

