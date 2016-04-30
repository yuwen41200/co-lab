//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
    src2_i,
    ctrl_i,
    result_o,
    zero_o
    );
     
//I/O ports
input [32-1:0]       src1_i;
input [32-1:0]       src2_i;
input [4-1:0]        ctrl_i;

output [32-1:0]      result_o;
output               zero_o;

//Internal signals
wire signed [32-1:0] src1_i_signed;
wire signed [32-1:0] src2_i_signed;
reg [32-1:0]         result_o;
wire                 zero_o;

assign src1_i_signed = src1_i;
assign src2_i_signed = src2_i;

assign zero_o = (result_o == 0);

//Parameter

//Main function
always @(*) begin
    case (ctrl_i)
        0: result_o = src1_i & src2_i;
        1: result_o = src1_i | src2_i;
        2: result_o = src1_i + src2_i;
        3: result_o = src1_i * src2_i;
        6: result_o = src1_i - src2_i;
        7: result_o = src1_i < src2_i ? 1 : 0;
        12: result_o = ~(src1_i | src2_i);
        14: result_o = src2_i_signed >>> src1_i_signed;
        15: result_o = src2_i << 16;
        default: result_o = 0;
    endcase
end

endmodule


