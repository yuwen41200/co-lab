module PipelineRegister #(parameter width = 32) (
	input clk_i,
	input rst_i,
	input [width-1:0] data_i,
	output reg [width-1:0] data_o
);

always @(posedge clk_i) begin
	if (~rst_i)
		data_o <= 0;
	else
		data_o <= data_i;
end

endmodule
