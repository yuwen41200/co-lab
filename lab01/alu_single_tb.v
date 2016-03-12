`timescale 1ns / 1ps

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

// Iterators
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
