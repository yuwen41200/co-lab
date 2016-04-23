//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o
    );
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [4-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [4-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter


//Main function
always @(*) begin
    RegWrite_o <= (instr_op_i == 0 || instr_op_i == 35); // R-type or Load -> nead to write result to some register
    ALU_op_o   <= (instr_op_i == 35 || instr_op_i == 43) ? 2 : // Load or Store -> add
                  (instr_op_i == 4 ? 6 : // Branch -> sub
                  (instr_op_i == 8 ? 2 : // ADDI -> add
                  (instr_op_i == 9 ? 6 : // SLTIU -> sub
                  4'b1111))); // Else -> check with funct in instruction
    ALUSrc_o   <= (instr_op_i == 35 || instr_op_i == 43); // Load or Store -> multiplexer selects address as the second ALU source
    RegDst_o   <= (instr_op_i == 0); // R-type -> multiplexer selects [15:11] as the register to write to
    Branch_o   <= (instr_op_i == 4); // Branch
end

endmodule





                    
                    