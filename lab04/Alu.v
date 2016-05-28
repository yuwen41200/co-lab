module Alu (
	input [31:0] src1_i,
	input [31:0] src2_i,
	input [3:0] ctrl_i,
	input reg [31:0] result_o,
	output zero_o,
	output less_o
);

assign zero_o = (result_o == 0);
assign less_o = (result_o[31] == 1);

always @(*) begin
	case (ctrl_i)
		0:       result_o = src1_i & src2_i;
		1:       result_o = src1_i | src2_i;
		2:       result_o = src1_i + src2_i;
		3:       result_o = src1_i * src2_i;
		6:       result_o = src1_i - src2_i;
		7:       result_o = ($signed(src1_i) < $signed(src2_i)) ? 1 : 0;
		12:      result_o = ~(src1_i | src2_i);
		14:      result_o = $signed(src2_i) >>> $signed(src1_i);
		15:      result_o = src2_i << 16;
		default: result_o = 0;
	endcase
end

endmodule
