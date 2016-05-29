`timescale 1ns / 1ps
`define CYCLE_TIME 10

module TestBench;

reg clk;
reg rst;
integer count;

PipelinedCpu Cpu (
	.clk_i(clk),
	.rst_i(rst)
);

always #(`CYCLE_TIME / 2) clk = ~clk;

initial begin
	clk = 0;
	rst = 0;
	count = 0;
	#(`CYCLE_TIME) rst = 1;
	#(`CYCLE_TIME * 1000) $stop;
end

always @(posedge clk) begin
	count = count + 1;
	if (count == 30) begin
		$display("\nRegister===========================================================\n");
		$display("r0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d\n",
		Cpu.Register.reg_file[0],  Cpu.Register.reg_file[1],  Cpu.Register.reg_file[2],  Cpu.Register.reg_file[3],
		Cpu.Register.reg_file[4],  Cpu.Register.reg_file[5],  Cpu.Register.reg_file[6],  Cpu.Register.reg_file[7]);
		$display("r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d, r15=%d\n",
		Cpu.Register.reg_file[8],  Cpu.Register.reg_file[9],  Cpu.Register.reg_file[10], Cpu.Register.reg_file[11],
		Cpu.Register.reg_file[12], Cpu.Register.reg_file[13], Cpu.Register.reg_file[14], Cpu.Register.reg_file[15]);
		$display("r16=%d, r17=%d, r18=%d, r19=%d, r20=%d, r21=%d, r22=%d, r23=%d\n",
		Cpu.Register.reg_file[16], Cpu.Register.reg_file[17], Cpu.Register.reg_file[18], Cpu.Register.reg_file[19],
		Cpu.Register.reg_file[20], Cpu.Register.reg_file[21], Cpu.Register.reg_file[22], Cpu.Register.reg_file[23]);
		$display("r24=%d, r25=%d, r26=%d, r27=%d, r28=%d, r29=%d, r30=%d, r31=%d\n",
		Cpu.Register.reg_file[24], Cpu.Register.reg_file[25], Cpu.Register.reg_file[26], Cpu.Register.reg_file[27],
		Cpu.Register.reg_file[28], Cpu.Register.reg_file[29], Cpu.Register.reg_file[30], Cpu.Register.reg_file[31]);

		$display("\nMemory=============================================================\n");
		$display("m0=%d, m1=%d, m2=%d, m3=%d, m4=%d, m5=%d, m6=%d, m7=%d\n",
		Cpu.DataMemory.mem_debug[0],  Cpu.DataMemory.mem_debug[1],  Cpu.DataMemory.mem_debug[2],  Cpu.DataMemory.mem_debug[3],
		Cpu.DataMemory.mem_debug[4],  Cpu.DataMemory.mem_debug[5],  Cpu.DataMemory.mem_debug[6],  Cpu.DataMemory.mem_debug[7]);
		$display("m8=%d, m9=%d, m10=%d, m11=%d, m12=%d, m13=%d, m14=%d, m15=%d\n",
		Cpu.DataMemory.mem_debug[8],  Cpu.DataMemory.mem_debug[9],  Cpu.DataMemory.mem_debug[10], Cpu.DataMemory.mem_debug[11],
		Cpu.DataMemory.mem_debug[12], Cpu.DataMemory.mem_debug[13], Cpu.DataMemory.mem_debug[14], Cpu.DataMemory.mem_debug[15]);
		$display("r16=%d, m17=%d, m18=%d, m19=%d, m20=%d, m21=%d, m22=%d, m23=%d\n",
		Cpu.DataMemory.mem_debug[16], Cpu.DataMemory.mem_debug[17], Cpu.DataMemory.mem_debug[18], Cpu.DataMemory.mem_debug[19],
		Cpu.DataMemory.mem_debug[20], Cpu.DataMemory.mem_debug[21], Cpu.DataMemory.mem_debug[22], Cpu.DataMemory.mem_debug[23]);
		$display("m24=%d, m25=%d, m26=%d, m27=%d, m28=%d, m29=%d, m30=%d, m31=%d\n",
		Cpu.DataMemory.mem_debug[24], Cpu.DataMemory.mem_debug[25], Cpu.DataMemory.mem_debug[26], Cpu.DataMemory.mem_debug[27],
		Cpu.DataMemory.mem_debug[28], Cpu.DataMemory.mem_debug[29], Cpu.DataMemory.mem_debug[30], Cpu.DataMemory.mem_debug[31]);
	end
end

endmodule
