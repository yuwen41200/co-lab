module DataMemory (
	input clk_i,
	input [31:0] addr_i,
	input [31:0] data_i,
	input mem_read_i,
	input mem_write_i,
	output reg [31:0] data_o
);

wire [31:0] mem_debug [0:31];
reg [7:0] mem_file [0:127];
integer iterator;

assign mem_debug[0]  = {mem_file[3],   mem_file[2],   mem_file[1],   mem_file[0]};
assign mem_debug[1]  = {mem_file[7],   mem_file[6],   mem_file[5],   mem_file[4]};
assign mem_debug[2]  = {mem_file[11],  mem_file[10],  mem_file[9],   mem_file[8]};
assign mem_debug[3]  = {mem_file[15],  mem_file[14],  mem_file[13],  mem_file[12]};
assign mem_debug[4]  = {mem_file[19],  mem_file[18],  mem_file[17],  mem_file[16]};
assign mem_debug[5]  = {mem_file[23],  mem_file[22],  mem_file[21],  mem_file[20]};
assign mem_debug[6]  = {mem_file[27],  mem_file[26],  mem_file[25],  mem_file[24]};
assign mem_debug[7]  = {mem_file[31],  mem_file[30],  mem_file[29],  mem_file[28]};
assign mem_debug[8]  = {mem_file[35],  mem_file[34],  mem_file[33],  mem_file[32]};
assign mem_debug[9]  = {mem_file[39],  mem_file[38],  mem_file[37],  mem_file[36]};
assign mem_debug[10] = {mem_file[43],  mem_file[42],  mem_file[41],  mem_file[40]};
assign mem_debug[11] = {mem_file[47],  mem_file[46],  mem_file[45],  mem_file[44]};
assign mem_debug[12] = {mem_file[51],  mem_file[50],  mem_file[49],  mem_file[48]};
assign mem_debug[13] = {mem_file[55],  mem_file[54],  mem_file[53],  mem_file[52]};
assign mem_debug[14] = {mem_file[59],  mem_file[58],  mem_file[57],  mem_file[56]};
assign mem_debug[15] = {mem_file[63],  mem_file[62],  mem_file[61],  mem_file[60]};
assign mem_debug[16] = {mem_file[67],  mem_file[66],  mem_file[65],  mem_file[64]};
assign mem_debug[17] = {mem_file[71],  mem_file[70],  mem_file[69],  mem_file[68]};
assign mem_debug[18] = {mem_file[75],  mem_file[74],  mem_file[73],  mem_file[72]};
assign mem_debug[19] = {mem_file[79],  mem_file[78],  mem_file[77],  mem_file[76]};
assign mem_debug[20] = {mem_file[83],  mem_file[82],  mem_file[81],  mem_file[80]};
assign mem_debug[21] = {mem_file[87],  mem_file[86],  mem_file[85],  mem_file[84]};
assign mem_debug[22] = {mem_file[91],  mem_file[90],  mem_file[89],  mem_file[88]};
assign mem_debug[23] = {mem_file[95],  mem_file[94],  mem_file[93],  mem_file[92]};
assign mem_debug[24] = {mem_file[99],  mem_file[98],  mem_file[97],  mem_file[96]};
assign mem_debug[25] = {mem_file[103], mem_file[102], mem_file[101], mem_file[100]};
assign mem_debug[26] = {mem_file[107], mem_file[106], mem_file[105], mem_file[104]};
assign mem_debug[27] = {mem_file[111], mem_file[110], mem_file[109], mem_file[108]};
assign mem_debug[28] = {mem_file[115], mem_file[114], mem_file[113], mem_file[112]};
assign mem_debug[29] = {mem_file[119], mem_file[118], mem_file[117], mem_file[116]};
assign mem_debug[30] = {mem_file[123], mem_file[122], mem_file[121], mem_file[120]};
assign mem_debug[31] = {mem_file[127], mem_file[126], mem_file[125], mem_file[124]};

initial begin
	for (iterator = 0; iterator < 128; iterator = iterator + 1)
		mem_file[i] = 8'b0;
	// Only used in CO_P4_test_3.txt:
	// mem_file[0] = 8'b0100;
	// mem_file[4] = 8'b0101;
	// mem_file[8] = 8'b0110;
	// mem_file[12] = 8'b0111;
	// mem_file[16] = 8'b1000;
	// mem_file[20] = 8'b1001;
	// mem_file[24] = 8'b1010;
	// mem_file[28] = 8'b0010;
	// mem_file[32] = 8'b0001;
	// mem_file[36] = 8'b0011;
	// ------------------------------
end

always @(posedge clk_i) begin
	if (mem_write_i) begin
		mem_file[addr_i + 3] <= data_i[31:24];
		mem_file[addr_i + 2] <= data_i[23:16];
		mem_file[addr_i + 1] <= data_i[15:8];
		mem_file[addr_i + 0] <= data_i[7:0];
	end
end

always @(addr_i or mem_read_i) begin
	if (mem_read_i)
		data_o = {mem_file[addr_i + 3], mem_file[addr_i + 2],
		          mem_file[addr_i + 1], mem_file[addr_i + 0]};
end

endmodule
