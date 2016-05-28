module AluControl (
	input [5:0] funct_i,
	input [3:0] alu_op_i,
	output reg [3:0] alu_ctrl_o
);

always @(*) begin
	if (alu_op_i != 15)
		alu_ctrl_o = alu_op_i;
	else begin
		case (funct_i)
			3:       alu_ctrl_o = 14; // SRA
			7:       alu_ctrl_o = 14; // SRAV
			24:      alu_ctrl_o = 3;  // MUL
			32:      alu_ctrl_o = 2;  // ADD
			34:      alu_ctrl_o = 6;  // SUB
			36:      alu_ctrl_o = 0;  // AND
			37:      alu_ctrl_o = 1;  // OR
			42:      alu_ctrl_o = 7;  // SLT
			default: alu_ctrl_o = 15; // LUI
		endcase
	end
end

endmodule
