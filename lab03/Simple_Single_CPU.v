//Subject:     CO project 3 - Single Cycle CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//--------------------------------------------------------------------------------
//Date:        
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
//Notes:
//. jal (opcode = 3)
//. RegWrite 31
//. jr ra
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
        rst_i
        );
        
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] addr_nxt;
wire [32-1:0] addr;
wire [32-1:0] addr_branch_nxt1;
wire [32-1:0] addr_branch_nxt2;
wire [32-1:0] addr_branch_nxt;
wire [32-1:0] addr_shift;
wire [32-1:0] addr_jump1;
wire [32-1:0] addr_jump2;
wire [32-1:0] addr_jump;

wire [32-1:0] inst;

wire          RegWrite;
wire [4-1:0]  ALUOp;
wire          ALUSrc;
wire          RegDst;
wire          Branch;
wire          MemToReg;
wire          MemRead;
wire          MemWrite;
wire          Jump_tmp;
wire          Jump;
wire [4-1:0]  ALUCtrl;
wire          Zero;
wire          Less;
wire          BranchSel;
wire          KeepSign;
wire          RegRead1;
wire          TakeBranch;
wire          IsJR; // Jump to register ?

wire [5-1:0]  reg_write1;
wire [5-1:0]  reg_write2;
wire [5-1:0]  reg_write;
wire [32-1:0] reg_data1_i;
wire [32-1:0] reg_data1;
wire [32-1:0] reg_data2_i;
wire [32-1:0] reg_data2;
wire [32-1:0] data_write;

wire [32-1:0] data_ext;
wire [32-1:0] res_alu;


wire [32-1:0] mem_data;
wire [32-1:0] result;


//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(addr_nxt) ,   
        .pc_out_o(addr) 
        );
    
Adder Adder1(
        .src1_i(4),     
        .src2_i(addr),     
        .sum_o(addr_branch_nxt1)    
        );
    
Instr_Memory IM(
        .addr_i(addr),  
        .instr_o(inst)    
        );
        
Decoder Decoder(
        .instr_op_i(inst[31:26]), 
        .RegWrite_o(RegWrite), 
        .ALU_op_o(ALUOp),   
        .ALUSrc_o(ALUSrc),   
        .RegDst_o(RegDst),   
        .Branch_o(Branch),
        .MemToReg_o(MemToReg),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .Jump_o(Jump_tmp)
        );
        
assign IsJR = (inst[31:26] == 0 && inst[5:0] == 8);
assign Jump = IsJR ? 1 : Jump_tmp;

MUX_2to1 #(.size(5)) Mux_Write_Reg1(
        .data0_i(inst[20:16]),
        .data1_i(inst[15:11]),
        .select_i(RegDst),
        .data_o(reg_write1)
        );

assign reg_write2 = 31;

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(reg_write1),
        .data1_i(reg_write2),
        .select_i(inst[31:26] == 3), // JAL
        .data_o(reg_write)
        );

assign data_write = inst[31:26] == 3 ? addr_branch_nxt1 : result;

Reg_File RF(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .RSaddr_i(inst[25:21]),  
        .RTaddr_i(inst[20:16]),  
        .RDaddr_i(reg_write),  
        .RDdata_i(data_write), 
        .RegWrite_i(RegWrite),
        .RSdata_o(reg_data1_i),  
        .RTdata_o(reg_data2_i)   
        );
    
ALU_Ctrl AC(
        .funct_i(inst[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl) 
        );

assign keep_sign = inst[31:26] == 9 || inst[31:26] == 13 ? 0 : 1;

Sign_Extend SE(
        .data_i(inst[15:0]),
        .data_o(data_ext),
        .keep_sign(keep_sign)
        );

assign reg_data1 = inst[31:26] == 0 && inst[5:0] == 3 ? inst[10:6] : reg_data1_i;

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(reg_data2_i),
        .data1_i(data_ext),
        .select_i(ALUSrc),
        .data_o(reg_data2)
        );
        
ALU ALU(
        .src1_i(reg_data1),
        .src2_i(reg_data2),
        .ctrl_i(ALUCtrl),
        .result_o(res_alu),
        .zero_o(Zero),
        .less_o(Less)
        );

Data_Memory Data_Memory(
        .clk_i(clk_i),
        .addr_i(res_alu),
        .data_i(reg_data2_i),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(mem_data)
       );

MUX_2to1 #(.size(32)) Mux_Result(
        .data0_i(res_alu),
        .data1_i(mem_data),
        .select_i(MemToReg),
        .data_o(result)
        );

Shift_Left_Two_32 Shifter(
        .data_i(data_ext),
        .data_o(addr_shift)
        );    
        
Adder Adder2(
        .src1_i(addr_branch_nxt1),     
        .src2_i(addr_shift),     
        .sum_o(addr_branch_nxt2)      
        );

assign TakeBranch = inst[31:26] == 4 ? Zero :             // BEQ
                   (inst[31:26] == 5 ? !Zero :            // BNE
                   (inst[31:26] == 6 ? (Less || Zero) :   // BLE
                    0));
assign BranchSel = Branch && TakeBranch;
        
MUX_2to1 #(.size(32)) Mux_Addr_Branch(
        .data0_i(addr_branch_nxt1),
        .data1_i(addr_branch_nxt2),
        .select_i(BranchSel),
        .data_o(addr_branch_nxt)
        );    

assign addr_jump1 = inst[25:0] << 2; // j, jal
assign addr_jump2 = reg_data1_i;     // jr

MUX_2to1 #(.size(32)) Mux_Jump_Addr(
        .data0_i(addr_jump1),
        .data1_i(addr_jump2),
        .select_i(inst[31:26] == 0),
        .data_o(addr_jump)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(addr_branch_nxt),
        .data1_i(addr_jump),
        .select_i(Jump),
        .data_o(addr_nxt)
        );

always @(*) begin
    $display("%b", inst);
    // $display("addr_branch_nxt1 = %d, addr_branch_nxt2 = %d, addr = %d, addr_branch_nxt = %d", addr_branch_nxt1, addr_branch_nxt2, addr, addr_branch_nxt);
    // $display("%b", RegWrite);
    // $display("%b %b", RegRead1, reg_read1);
    // $display("%d %d => %d ", reg_data1, reg_data2, res_alu);
end

endmodule
          


