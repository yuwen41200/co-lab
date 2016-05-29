module InstructionMemory (
	input [31:0] addr_i,
	output [31:0] instr_o
);

integer iterator;
reg [31:0] instr_file [0:31];

initial begin
	for (iterator = 0; iterator < 32; iterator = iterator + 1)
		instr_file[iterator] = 32'b0;
	$readmemb("/home/yuwen41200/Documents/co-lab/lab04/CO_P4_test_1.txt", instr_file);
end

assign instr_o = instr_file[addr_i >> 2];

endmodule
