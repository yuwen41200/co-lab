module Register (
	input clk_i,
	input rst_i,
	input [4:0] rs_addr_i,
	input [4:0] rt_addr_i,
	input [4:0] rd_addr_i,
	input [31:0] rd_data_i,
	input reg_write_i,
	output [31:0] rs_data_o,
	output [31:0] rt_data_o
);

signed reg [31:0] reg_file [0:31];

assign rs_data_o = reg_file[rs_addr_i];
assign rt_data_o = reg_file[rt_addr_i];

always @(posedge clk_i) begin
	if (~rst_i) begin
		reg_file[0]  <= 0; reg_file[1]  <= 0;   reg_file[2]  <= 0; reg_file[3]  <= 0;
		reg_file[4]  <= 0; reg_file[5]  <= 0;   reg_file[6]  <= 0; reg_file[7]  <= 0;
		reg_file[8]  <= 0; reg_file[9]  <= 0;   reg_file[10] <= 0; reg_file[11] <= 0;
		reg_file[12] <= 0; reg_file[13] <= 0;   reg_file[14] <= 0; reg_file[15] <= 0;
		reg_file[16] <= 0; reg_file[17] <= 0;   reg_file[18] <= 0; reg_file[19] <= 0;
		reg_file[20] <= 0; reg_file[21] <= 0;   reg_file[22] <= 0; reg_file[23] <= 0;
		reg_file[24] <= 0; reg_file[25] <= 0;   reg_file[26] <= 0; reg_file[27] <= 0;
		reg_file[28] <= 0; reg_file[29] <= 124; reg_file[30] <= 0; reg_file[31] <= 0;
		// Register 29 is Stack Pointer. Initiate it to the top.
	end
	else begin
		if (reg_write_i)
			reg_file[rd_addr_i] <= rd_data_i;
		else
			reg_file[rd_addr_i] <= reg_file[rd_addr_i];
	end
end

endmodule
