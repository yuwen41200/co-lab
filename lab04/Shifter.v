module Shifter (
	input [31:0] data_i,
	output [31:0] data_o
);

assign data_o[1:0] = 0;
assign data_o[31:2] = data_i[29:0];

endmodule
