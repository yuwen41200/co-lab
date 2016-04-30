//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
    data_i,
    data_o,
    keep_sign
    );
               
//I/O ports
input   [16-1:0] data_i;
input            keep_sign;
output  [32-1:0] data_o;

//Internal Signals
// reg     [32-1:0] data_o;

//Sign extended
assign data_o[16-1:0] = data_i[16-1:0];
assign data_o[16] = keep_sign ? data_i[16-1] : 0;
assign data_o[17] = keep_sign ? data_i[16-1] : 0;
assign data_o[18] = keep_sign ? data_i[16-1] : 0;
assign data_o[19] = keep_sign ? data_i[16-1] : 0;
assign data_o[20] = keep_sign ? data_i[16-1] : 0;
assign data_o[21] = keep_sign ? data_i[16-1] : 0;
assign data_o[22] = keep_sign ? data_i[16-1] : 0;
assign data_o[23] = keep_sign ? data_i[16-1] : 0;
assign data_o[24] = keep_sign ? data_i[16-1] : 0;
assign data_o[25] = keep_sign ? data_i[16-1] : 0;
assign data_o[26] = keep_sign ? data_i[16-1] : 0;
assign data_o[27] = keep_sign ? data_i[16-1] : 0;
assign data_o[28] = keep_sign ? data_i[16-1] : 0;
assign data_o[29] = keep_sign ? data_i[16-1] : 0;
assign data_o[30] = keep_sign ? data_i[16-1] : 0;
assign data_o[31] = keep_sign ? data_i[16-1] : 0;

          
endmodule      
     