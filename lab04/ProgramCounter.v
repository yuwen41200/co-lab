module ProgramCounter (
	input clk_i,
	input rst_i,
	input [31:0] pc_in_i,
	output reg [31:0] pc_out_o
);

always @(posedge clk_i) begin
	if (~rst_i)
		pc_out_o <= 0;
	else
		pc_out_o <= pc_in_i;
end

endmodule
