/**
 * Top Module
 */

module PipelinedCpu (
	input clk_i,
	input rst_i
);

/**
 * IF Stage
 */

wire [31:0] addr_plus_four_if;
wire [31:0] addr_branch_next_mem;
wire pc_src_mem;
wire [31:0] addr_next_if;

Mux #(.width(32)) MuxForAddrNextIf (
	.data0_i(addr_plus_four_if),
	.data1_i(addr_branch_next_mem),
	.select_i(pc_src_mem),
	.data_o(addr_next_if)
);

wire [31:0] addr_if;

ProgramCounter ProgramCounter (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(addr_next_if),
	.pc_out_o(addr_if)
);

Adder AdderForProgramCounter (
	.src1_i(4),
	.src2_i(addr_if),
	.sum_o(addr_plus_four_if)
);

wire [31:0] instr_if;

InstructionMemory InstructionMemory (
	.addr_i(addr_if),
	.instr_o(instr_if)
);

wire [31:0] addr_plus_four_id;
wire [31:0] instr_id;

PipelineRegister #(.width(64)) StageIfId (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({addr_plus_four_if, instr_if}),
	.data_o({addr_plus_four_id, instr_id})
);

/**
 * ID Stage
 */

wire reg_write_id;
wire [3:0] alu_op_id;
wire alu_src_id;
wire reg_dest_id;
wire branch_id;
wire mem_to_reg_id;
wire mem_read_id;
wire mem_write_id;

Decoder Decoder (
	.instr_op_i(instr_id[31:26]),
	.reg_write_o(reg_write_id),
	.alu_op_o(alu_op_id),
	.alu_src_o(alu_src_id),
	.reg_dest_o(reg_dest_id),
	.branch_o(branch_id),
	.mem_to_reg_o(mem_to_reg_id),
	.mem_read_o(mem_read_id),
	.mem_write_o(mem_write_id)
);

wire [4:0] write_reg_wb;
wire [31:0] write_data_wb;
wire reg_write_wb;
wire [31:0] reg_data1_temp_id;
wire [31:0] reg_data2_temp_id;

Register Register (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.rs_addr_i(instr_id[25:21]),
	.rt_addr_i(instr_id[20:16]),
	.rd_addr_i(write_reg_wb),
	.rd_data_i(write_data_wb),
	.reg_write_i(reg_write_wb),
	.rs_data_o(reg_data1_temp_id),
	.rt_data_o(reg_data2_temp_id)
);

wire keep_sign_id;
wire [31:0] data_ext_id;

assign keep_sign_id = (instr_id[31:26] != 9 && instr_id[31:26] != 13); // neither SLTIU nor ORI

SignExtend SignExtend (
	.data_i(instr_id[15:0]),
	.keep_sign_i(keep_sign_id),
	.data_o(data_ext_id)
);

wire [31:0] addr_plus_four_ex;
wire [31:0] instr_ex;
wire reg_write_ex;
wire [3:0] alu_op_ex;
wire alu_src_ex;
wire reg_dest_ex;
wire branch_ex;
wire mem_to_reg_ex;
wire mem_read_ex;
wire mem_write_ex;
wire [31:0] reg_data1_temp_ex;
wire [31:0] reg_data2_temp_ex;
wire [31:0] data_ext_ex;

PipelineRegister #(.width(171)) StageIdEx (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({addr_plus_four_id, instr_id, reg_write_id, alu_op_id, alu_src_id, reg_dest_id,
	         branch_id, mem_to_reg_id, mem_read_id, mem_write_id, reg_data1_temp_id,
	         reg_data2_temp_id, data_ext_id}),
	.data_o({addr_plus_four_ex, instr_ex, reg_write_ex, alu_op_ex, alu_src_ex, reg_dest_ex,
	         branch_ex, mem_to_reg_ex, mem_read_ex, mem_write_ex, reg_data1_temp_ex,
	         reg_data2_temp_ex, data_ext_ex})
);

/**
 *  EX Stage
 */

Mux #(.width(5)) MuxForWriteReg (
	.data0_i(instr[20:16]),
	.data1_i(instr[15:11]),
	.select_i(reg_dest),
	.data_o(write_reg_wb)
);

wire [31:0] reg_data1;
wire [31:0] reg_data2;

assign reg_data1 = (instr[31:26] == 0 && instr[5:0] == 3) ? instr[10:6] : reg_data1_temp_id; // SRA

Mux #(.width(32)) MuxForRegData2 (
	.data0_i(reg_data2_temp_id),
	.data1_i(data_ext),
	.select_i(alu_src),
	.data_o(reg_data2)
);

wire [3:0] alu_ctrl;

AluControl AluControl (
	.funct_i(instr[5:0]),
	.alu_op_i(alu_op),
	.alu_ctrl_o(alu_ctrl)
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
	.data_i(reg_data2_temp_id),
	.mem_read_i(mem_read),
	.mem_write_i(mem_write),
	.data_o(read_data)
);

Mux #(.width(32)) MuxForWriteData (
	.data0_i(alu_result),
	.data1_i(read_data),
	.select_i(mem_to_reg),
	.data_o(write_data_wb)
);

wire [31:0] addr_shift;

Shifter ShifterForBranchAddress (
	.data_i(data_ext),
	.data_o(addr_shift)
);

wire [31:0] addr_branch_next;

Adder AdderForBranchAddress (
	.src1_i(addr_plus_four),
	.src2_i(addr_shift),
	.sum_o(addr_branch_next)
);

wire take_branch;
wire pc_src_mem;

assign take_branch = (instr[31:26] == 1 ? less :           // BLTZ
                     (instr[31:26] == 4 ? zero :           // BEQ
                     (instr[31:26] == 5 ? ~zero :          // BNE
                     (instr[31:26] == 6 ? (less || zero) : // BLE
                      0))));
assign pc_src_mem = branch && take_branch;

always @(*) begin
	$display("%b", instr);
end

endmodule
