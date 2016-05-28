module #(parameter width = 32) Mux (
	input [width-1:0] data0_i,
	input [width-1:0] data1_i,
	input select_i,
	output [width-1:0] data_o
);

assign data_o = (select_i == 1) ? data1_i : data0_i;

endmodule
