//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [4-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(*) begin
    if (ALUOp_i != 4'b1111)
        ALUCtrl_o = ALUOp_i;
    else begin
        case (funct_i)
            3:       ALUCtrl_o = 14; // SRA
            7:       ALUCtrl_o = 14; // SRAV
            32:      ALUCtrl_o = 2; // ADD
            34:      ALUCtrl_o = 6; // SUB
            36:      ALUCtrl_o = 0; // AND
            37:      ALUCtrl_o = 1; // OR
            42:      ALUCtrl_o = 7; // SLT
            default: ALUCtrl_o = 4'b1111;
        endcase
    end
end

endmodule     





                    
                    