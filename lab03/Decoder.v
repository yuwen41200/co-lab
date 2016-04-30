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
    Branch_o,
    MemToReg_o,
    MemRead_o,
    MemWrite_o,
    Jump_o
    );
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [4-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         MemToReg_o;
output         MemRead_o;
output         MemWrite_o;
output         Jump_o;
 
//Internal Signals
reg    [4-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            MemToReg_o;
reg            MemRead_o;
reg            MemWrite_o;
reg            Jump_o;

//Parameter


//Main function
always @(*) begin
    RegWrite_o = (instr_op_i == 0 || instr_op_i == 35 || instr_op_i == 8 || instr_op_i == 9 || instr_op_i == 15 || instr_op_i == 13); // R-type, Load, ADDI, SLTIU, LUI, ORI -> nead to write result to some register
    ALU_op_o   = (instr_op_i == 35 || instr_op_i == 43) ? 2 : // Load or Store -> add
                 (instr_op_i == 4 ? 6 : // Branch -> sub
                 (instr_op_i == 8 ? 2 : // ADDI -> add
                 (instr_op_i == 9 ? 7 : // SLTIU -> lt
                 (instr_op_i == 13 ? 1 : // ORI -> or
                 (instr_op_i == 15 ? 15: // LUI -> Left shift immediate by 16
                 4'b1111))))); // Else -> check with funct in instruction
    ALUSrc_o   = (instr_op_i == 35 || instr_op_i == 43 || instr_op_i == 8 || instr_op_i == 9 || instr_op_i == 15 || instr_op_i == 13); // Load, Store, ADDI, SLTIU, LUI, ORI -> multiplexer selects [15:0] as the second ALU source
    RegDst_o   = (instr_op_i == 0); // R-type -> multiplexer selects [15:11] as the register to write to
    Branch_o   = (instr_op_i == 4 || instr_op_i == 5); // BEQ, BNE
    MemToReg_o = (instr_op_i == 35); // lw
    MemRead_o  = (instr_op_i == 35); // lw
    MemWrite_o = (instr_op_i == 43); // sw
    Jump_o     = (instr_op_i == 2 || instr_op_i == 3); // j, jal
    
end

endmodule





                    
                    