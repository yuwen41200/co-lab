module Decoder (
	input [5:0] instr_op_i,
	output reg reg_write_o,
	output reg [3:0] alu_op_o,
	output reg alu_src_o,
	output reg reg_dest_o,
	output reg branch_o,
	output reg mem_to_reg_o,
	output reg mem_read_o,
	output reg mem_write_o,
	output reg jump_o
);

always @(*) begin
	reg_write_o = (instr_op_i == 0 || instr_op_i == 35 || instr_op_i == 8 || instr_op_i == 9 ||
	               //    ALU Instr                  LW               ADDI              SLTIU
	               instr_op_i == 15 || instr_op_i == 13 || instr_op_i == 3);
	               //           LUI                 ORI                JAL

	alu_op_o = (instr_op_i == 35 || instr_op_i == 43 ? 2 : // LW or SW -> Add
	           (instr_op_i == 1  || instr_op_i == 4 || instr_op_i == 5 || instr_op_i == 6 ? 6 :
	                                                       // Branch Instr -> Sub
	           (instr_op_i == 8  ? 2  :                    // ADDI -> Add
	           (instr_op_i == 9  ? 7  :                    // SLTIU -> Set Less Than
	           (instr_op_i == 13 ? 1  :                    // ORI -> Or
	           (instr_op_i == 15 ? 15 :                    // LUI -> Shift Left
	            15))))));                                  // Others -> Check Function Code

	alu_src_o = (instr_op_i == 35 || instr_op_i == 43 || instr_op_i == 8 || instr_op_i == 9 ||
	             //            LW                  SW               ADDI              SLTIU
	             instr_op_i == 15 || instr_op_i == 13);
	             //           LUI                 ORI

	reg_dest_o   = (instr_op_i == 0);                      // ALU Instr
	branch_o     = (instr_op_i == 1 || instr_op_i == 4 || instr_op_i == 5 || instr_op_i == 6);
	                                                       // Branch Instr
	mem_to_reg_o = (instr_op_i == 35);                     // LW
	mem_read_o   = (instr_op_i == 35);                     // LW
	mem_write_o  = (instr_op_i == 43);                     // SW
	jump_o       = (instr_op_i == 2 || instr_op_i == 3);   // J or JAL
end

endmodule
