module SignExtend (
	input [15:0] data_i,
	output [31:0] data_o,
	output keep_sign
);

assign data_o[15:0] = data_i[15:0];
assign data_o[31:16] = keep_sign ? {16{data_i[15]}} : 0;

endmodule
