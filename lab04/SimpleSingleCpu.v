/**
 * Top Module
 */

module SimpleSingleCpu (
	input clk_i,
	input rst_i
);

wire [31:0] addr_next;
wire [31:0] addr;

ProgramCounter ProgramCounter (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(addr_next),
	.pc_out_o(addr)
);

wire [31:0] addr_plus_four;

Adder AdderForProgramCounter (
	.src1_i(4),
	.src2_i(addr),
	.sum_o(addr_plus_four)
);

wire [31:0] instr;

InstructionMemory InstructionMemory (
	.addr_i(addr),
	.instr_o(instr)
);

wire reg_write;
wire [3:0] alu_op;
wire alu_src;
wire reg_dest;
wire branch;
wire mem_to_reg;
wire mem_read;
wire mem_write;
wire jump_temp;
wire instr_jr;
wire jump;

Decoder Decoder (
	.instr_op_i(instr[31:26]),
	.reg_write_o(reg_write),
	.alu_op_o(alu_op),
	.alu_src_o(alu_src),
	.reg_dest_o(reg_dest),
	.branch_o(branch),
	.mem_to_reg_o(mem_to_reg),
	.mem_read_o(mem_read),
	.mem_write_o(mem_write),
	.jump_o(jump_temp)
);

assign instr_jr = (instr[31:26] == 0 && instr[5:0] == 8); // JR
assign jump = instr_jr ? 1 : jump_temp;

wire [4:0] write_reg_temp;

Mux #(.width(5)) MuxForWriteRegTemp (
	.data0_i(instr[20:16]),
	.data1_i(instr[15:11]),
	.select_i(reg_dest),
	.data_o(write_reg_temp)
);

wire instr_jal;
wire [4:0] write_reg;

assign instr_jal = (instr[31:26] == 3); // JAL

Mux #(.width(5)) MuxForWriteReg (
	.data0_i(write_reg_temp),
	.data1_i(31),
	.select_i(instr_jal),
	.data_o(write_reg)
);

wire [31:0] result;
wire [31:0] write_data;

Mux #(.width(32)) MuxForWriteData (
	.data0_i(result),
	.data1_i(addr_plus_four),
	.select_i(instr_jal),
	.data_o(write_data)
);

wire [31:0] reg_data1_temp;
wire [31:0] reg_data2_temp;

Register Register (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.rs_addr_i(instr[25:21]),
	.rt_addr_i(instr[20:16]),
	.rd_addr_i(write_reg),
	.rd_data_i(write_data),
	.reg_write_i(reg_write),
	.rs_data_o(reg_data1_temp),
	.rt_data_o(reg_data2_temp)
);

wire [3:0] alu_ctrl;

AluControl AluControl (
	.funct_i(instr[5:0]),
	.alu_op_i(alu_op),
	.alu_ctrl_o(alu_ctrl)
);

wire keep_sign;
wire [31:0] data_ext;

assign keep_sign = (instr[31:26] != 9 && instr[31:26] != 13); // neither SLTIU nor ORI

SignExtend SignExtend (
	.data_i(instr[15:0]),
	.keep_sign_i(keep_sign),
	.data_o(data_ext)
);

wire [31:0] reg_data1;
wire [31:0] reg_data2;

assign reg_data1 = (instr[31:26] == 0 && instr[5:0] == 3) ? instr[10:6] : reg_data1_temp; // SRA

Mux #(.width(32)) MuxForRegData2 (
	.data0_i(reg_data2_temp),
	.data1_i(data_ext),
	.select_i(alu_src),
	.data_o(reg_data2)
);

wire [31:0] alu_result;
wire zero;
wire less;

Alu Alu (
	.src1_i(reg_data1),
	.src2_i(reg_data2),
	.ctrl_i(alu_ctrl),
	.result_o(alu_result),
	.zero_o(zero),
	.less_o(less)
);

wire [31:0] read_data;

DataMemory DataMemory (
	.clk_i(clk_i),
	.addr_i(alu_result),
	.data_i(reg_data2_temp),
	.mem_read_i(mem_read),
	.mem_write_i(mem_write),
	.data_o(read_data)
);

Mux #(.width(32)) MuxForResult (
	.data0_i(alu_result),
	.data1_i(read_data),
	.select_i(mem_to_reg),
	.data_o(result)
);

wire [31:0] addr_shift;

Shifter ShifterForBranchAddress (
	.data_i(data_ext),
	.data_o(addr_shift)
);

wire [31:0] addr_branch_next_temp;

Adder AdderForBranchAddress (
	.src1_i(addr_plus_four),
	.src2_i(addr_shift),
	.sum_o(addr_branch_next_temp)
);

wire take_branch;
wire branch_select;

assign take_branch = (instr[31:26] == 1 ? less :           // BLTZ
                     (instr[31:26] == 4 ? zero :           // BEQ
                     (instr[31:26] == 5 ? ~zero :          // BNE
                     (instr[31:26] == 6 ? (less || zero) : // BLE
                      0))));
assign branch_select = branch && take_branch;

wire [31:0] addr_branch_next;

Mux #(.width(32)) MuxForAddrBranchNext (
	.data0_i(addr_plus_four),
	.data1_i(addr_branch_next_temp),
	.select_i(branch_select),
	.data_o(addr_branch_next)
);

wire [31:0] addr_jump_temp;

Shifter ShifterForJumpAddress (
	.data_i({6'b0, instr[25:0]}),
	.data_o(addr_jump_temp)
);

wire [31:0] addr_jump;

Mux #(.width(32)) MuxForAddrJump (
	.data0_i(addr_jump_temp), // J or JAL
	.data1_i(reg_data1_temp), // JR
	.select_i(instr_jr),
	.data_o(addr_jump)
);

Mux #(.width(32)) MuxForAddrNext (
	.data0_i(addr_branch_next),
	.data1_i(addr_jump),
	.select_i(jump),
	.data_o(addr_next)
);

always @(*) begin
	$display("%b", instr);
end

endmodule
