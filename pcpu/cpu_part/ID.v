module ID (
    input clk,
    input reset,
    input [31:0] ID_inst,
    input WB_RegWrite,
    input [4:0] WB_rd,
    input [31:0] WB_WD,
    output [4:0] ID_rs1,
    output [4:0] ID_rs2,
    output [4:0] ID_rd,
    output [31:0] ID_RD1,
    output [31:0] ID_RD2,
    output [31:0] ID_immout,
    output [2:0] ID_dm_ctrl,
    output ID_RegWrite,
    output ID_mem_w,
    output ID_mem_read,
    output [4:0] ID_ALUOp,
    output [1:0] ID_WDSel,
    output [2:0] ID_NPCOp,
    output ID_ALUSrc
);


    // output 
    assign ID_rs1 = ID_inst[19:15];  //  output rs1
    assign ID_rs2 = ID_inst[24:20];  // output rs2
    assign ID_rd = ID_inst[11:7]; // output rd
    wire [4:0] ID_iimm_shamt;            assign ID_iimm_shamt=ID_inst[24:20];
	wire [11:0] ID_iimm,ID_simm,ID_bimm; assign ID_iimm=ID_inst[31:20];assign ID_simm={ID_inst[31:25],ID_inst[11:7]};assign ID_bimm={ID_inst[31],ID_inst[7],ID_inst[30:25],ID_inst[11:8]};
	wire [19:0] ID_uimm,ID_jimm;         assign ID_uimm=ID_inst[31:12];assign ID_jimm={ID_inst[31],ID_inst[19:12],ID_inst[20],ID_inst[30:21]};
  
    

    wire [6:0]  ID_Op;          assign ID_Op = ID_inst[6:0];  // opcode
    wire [6:0]  ID_Funct7;      assign ID_Funct7 = ID_inst[31:25]; // funct7
    wire [2:0]  ID_Funct3;      assign ID_Funct3 = ID_inst[14:12]; // funct3
    wire [5:0] ID_EXTOp; 
    ctrl U_ctrl(
        // input 
		.Op(ID_Op), 
        .Funct7(ID_Funct7),
        .Funct3(ID_Funct3), 
        // out 
		.RegWrite(ID_RegWrite),  // todo 
        .MemWrite(ID_mem_w),     
		.EXTOp(ID_EXTOp), 
        .ALUOp(ID_ALUOp),
        .NPCOp(ID_NPCOp), 
        .ALUSrc(ID_ALUSrc),
		.DMType(ID_dm_ctrl),
        .WDSel(ID_WDSel),
        .mem_read(ID_mem_read)
	);

    RF U_RF(
		.clk(clk), 
        .rst(reset),
		.RFWr(WB_RegWrite), 
		.A1(ID_rs1), 
        .A2(ID_rs2), 
        .A3(WB_rd), 
		.WD(WB_WD), 
		.RD1(ID_RD1), 
        .RD2(ID_RD2)
	);


    EXT U_EXT(
        // iput 
		.iimm_shamt(ID_iimm_shamt), 
        .iimm(ID_iimm), 
        .simm(ID_simm), 
        .bimm(ID_bimm),
		.uimm(ID_uimm), 
        .jimm(ID_jimm),
		.EXTOp(ID_EXTOp), 
        // out 
        .immout(ID_immout)
	);
    
endmodule