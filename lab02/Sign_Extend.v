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
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
// reg     [32-1:0] data_o;

//Sign extended
assign data_o[16-1:0] = data_i[16-1:0];
assign data_o[16] = 0; // data_i[16-1];
assign data_o[17] = 0; // data_i[16-1];
assign data_o[18] = 0; // data_i[16-1];
assign data_o[19] = 0; // data_i[16-1];
assign data_o[20] = 0; // data_i[16-1];
assign data_o[21] = 0; // data_i[16-1];
assign data_o[22] = 0; // data_i[16-1];
assign data_o[23] = 0; // data_i[16-1];
assign data_o[24] = 0; // data_i[16-1];
assign data_o[25] = 0; // data_i[16-1];
assign data_o[26] = 0; // data_i[16-1];
assign data_o[27] = 0; // data_i[16-1];
assign data_o[28] = 0; // data_i[16-1];
assign data_o[29] = 0; // data_i[16-1];
assign data_o[30] = 0; // data_i[16-1];
assign data_o[31] = 0; // data_i[16-1];

          
endmodule      
     