module SignExtend (
	input [15:0] data_i,
	input keep_sign_i,
	output [31:0] data_o
);

assign data_o[15:0] = data_i[15:0];
assign data_o[31:16] = keep_sign_i ? {16{data_i[15]}} : 0;

endmodule
