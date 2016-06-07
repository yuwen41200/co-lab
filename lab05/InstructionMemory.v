module InstructionMemory (
	input [31:0] addr_i,
	output [31:0] instr_o
);

integer iterator;
reg [31:0] instr_file [0:64];

initial begin
	for (iterator = 0; iterator < 65; iterator = iterator + 1)
		instr_file[iterator] = 32'b0;
	$readmemb("/home/yuwen41200/Documents/co-lab/lab05/lab5_test_data.txt", instr_file);
end

assign instr_o = instr_file[addr_i >> 2];

endmodule
