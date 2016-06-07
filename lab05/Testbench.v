`timescale 1ns / 1ps
`define CYCLE_TIME 20

module Testbench;

reg clk, rst;
integer fp1, fp2;

SimpleSingleCpu Cpu (
	.clk_i(clk),
	.rst_i(rst)
);

always #(`CYCLE_TIME / 2) clk = ~clk;

initial begin
	clk = 0;
	rst = 0;
	fp1 = $fopen("ICACHE.txt");
	fp2 = $fopen("DCACHE.txt");
	#(`CYCLE_TIME) rst = 1;
	#(`CYCLE_TIME * 1000) begin
		$fclose(fp1);
		$fclose(fp2);
		$stop;
	end
end

always @(posedge clk) begin
	if (Cpu.InstructionMemory.instr_o != 32'd0)
		$fdisplay(fp1, "%h\n", Cpu.InstructionMemory.addr_i);
	if (Cpu.DataMemory.mem_read_i || Cpu.DataMemory.mem_write_i)
		$fdisplay(fp2, "%h\n", Cpu.DataMemory.addr_i);
end

endmodule
