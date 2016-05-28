module #(parameter width = 32) PipelineRegister (
	input clk_i,
	input rst_i,
	input [size-1:0] data_i,
	output reg [size-1:0] data_o
);

always @(posedge clk_i) begin
	if (~rst_i)
		data_o <= 0;
	else
		data_o <= data_i;
end

endmodule
