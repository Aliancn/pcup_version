// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Tue Jun 20 18:23:52 2023
// Host        : LAPTOP-E4IJ843E running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub C:/Users/user/Desktop/projects/edf_file/SCPU.v
// Design      : SCPU
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`include "ctrl_encode_def.v"
module PCPU(
    input clk,
    input reset,
    input MIO_ready,    // not used 
    input [31:0]inst_in,  // instruction
    input [31:0]Data_in,  // data in bus
    input INT,         // interrupt signal
    output mem_w,    // memory write control signal
    output [31:0]PC_out,  // pc
    output [31:0]Addr_out, // address
    output [31:0]Data_out,  // data out bus
    output [2:0]dm_ctrl,  
    output CPU_MIO  // not used
);

    // control signal
    //wire IF_Flush;
    //wire ID_Flush_hazard ;
    wire Branch ;
    wire Hazard;
    //wire PCWrite; 
    //wire IF_IDWrite; 
    

    /********************************start***********************************/
    
    /************* if  *************/  
    wire [31:0] IF_inst;    assign IF_inst = inst_in;  // cpu in
    wire [31:0] IF_NPC ; 
    wire [31:0] IF_PC_out; assign PC_out = IF_PC_out;
              
    IF U_IF (
        .clk(clk),
        .reset(reset),
        .IF_NPC(IF_NPC),
        .PCWrite(~Hazard),
        .IF_PC_out(IF_PC_out)
    );
    

    /************* if\id reg *************/  
    wire [31:0] ID_inst;
    wire [31:0] ID_PC;
    IF_ID_stage U_IF_ID(
        // signal
        .clk(clk),
        .reset(reset),
        .IF_IDWrite(~Hazard),
        .IF_Flush(Branch),
        // reg
        .IF_inst(IF_inst),.ID_inst(ID_inst),
        .IF_PC_out(IF_PC_out),.ID_PC(ID_PC)
    );

    /************* id *************/
    wire [31:0] ID_RD1,ID_RD2,ID_immout;        
    wire [4:0] ID_rs1, ID_rs2, ID_rd;        
    wire        ID_ALUSrc;      
    wire [2:0]  ID_dm_ctrl;
    wire ID_RegWrite;    // control signal to register write
    wire ID_mem_w;    // memory write control signal
    wire ID_mem_read ; // memory read control signal
    wire [4:0]  ID_ALUOp;       // ALU opertion
    wire [2:0]  ID_NPCOp;       // next PC operation
    wire [1:0]  ID_WDSel;       // write data selection
    wire [4:0]  WB_rd ;
    wire WB_RegWrite;  
    wire [31:0]WB_WD; 
    ID U_ID (
        .clk(clk),
        .reset(reset),
        .ID_inst(ID_inst),
        .WB_RegWrite(WB_RegWrite),
        .WB_rd(WB_rd),
        .WB_WD(WB_WD),
        .ID_rs1(ID_rs1),
        .ID_rs2(ID_rs2),
        .ID_rd(ID_rd),
        .ID_RD1(ID_RD1),
        .ID_RD2(ID_RD2),
        .ID_immout(ID_immout),
        .ID_dm_ctrl(ID_dm_ctrl),
        .ID_RegWrite(ID_RegWrite),
        .ID_mem_w(ID_mem_w),
        .ID_mem_read(ID_mem_read),
        .ID_ALUOp(ID_ALUOp),
        .ID_WDSel(ID_WDSel),
        .ID_NPCOp(ID_NPCOp),
        .ID_ALUSrc(ID_ALUSrc)
    );

    

    /**********  ID_EX   reg   ***/
    wire [31:0] EX_PC;
    wire [4:0]  EX_rs1;          // rs
    wire [4:0]  EX_rs2;          // rt
    wire [4:0]  EX_rd;          // rd
    wire [31:0] EX_RD1,EX_RD2;         // register data specified by rs
    wire EX_ALUSrc;      // ALU source for A
    wire [31:0] EX_immout;     // immediate output at id
    wire [2:0]EX_dm_ctrl;
    wire EX_RegWrite;    // control signal to register write
    wire EX_mem_w;    // memory write control signal
    wire [4:0]  EX_ALUOp;       // ALU opertion
    wire [1:0] EX_WDSel;       // write data selection
    wire [2:0] EX_NPCOp ;        
    wire EX_mem_read ; // memory read control signal
    ID_EX_stage U_ID_EX(
        .clk(clk),
        .reset(reset),
        .ID_Flush_branch(Branch),
        .ID_Flush_hazard(Hazard),
        .ID_PC(ID_PC),            .EX_PC(EX_PC),
        .ID_rs1(ID_rs1),          .EX_rs1(EX_rs1),
        .ID_rs2(ID_rs2),          .EX_rs2(EX_rs2),
        .ID_rd(ID_rd),            .EX_rd(EX_rd),
        .ID_RD1(ID_RD1),          .EX_RD1(EX_RD1),
        .ID_RD2(ID_RD2),          .EX_RD2(EX_RD2),
        .ID_immout(ID_immout),    .EX_immout(EX_immout),
        .ID_dm_ctrl(ID_dm_ctrl),  .EX_dm_ctrl(EX_dm_ctrl),
        .ID_RegWrite(ID_RegWrite),.EX_RegWrite(EX_RegWrite),
        .ID_mem_w(ID_mem_w),      .EX_mem_w(EX_mem_w),
        .ID_mem_read(ID_mem_read),.EX_mem_read(EX_mem_read),
        .ID_ALUOp(ID_ALUOp),      .EX_ALUOp(EX_ALUOp),
        .ID_WDSel(ID_WDSel),      .EX_WDSel(EX_WDSel),
        .ID_NPCOp(ID_NPCOp),      .EX_NPCOp(EX_NPCOp),
        .ID_ALUSrc(ID_ALUSrc),    .EX_ALUSrc(EX_ALUSrc)
    );


    /*
    *    ex
    */ 
    wire EX_Zero;
    wire [31:0] EX_aluout; // ex alu output 
    wire [31:0] ForwardAData, ForwardBData;
    wire [2:0]EX_NPCSel;
    EX U_EX(
        .EX_PC(EX_PC),
        .ForwardAData(ForwardAData),
        .ForwardBData(ForwardBData),
        .EX_ALUSrc(EX_ALUSrc),
        .EX_immout(EX_immout),
        .EX_ALUOp(EX_ALUOp),
        .EX_NPCOp(EX_NPCOp),
        .EX_aluout(EX_aluout),
        .EX_NPCSel(EX_NPCSel)
    );

    /****************ex\mem reg********************/
    wire [31:0] MEM_PC;
    wire [4:0]  MEM_rd;
    wire [4:0] MEM_rs2;
    wire [31:0] MEM_RD2;
    wire [31:0] MEM_immout;     // immediate output at id
    wire [2:0] MEM_dm_ctrl;
    wire MEM_RegWrite;    // control signal to register write
    wire MEM_mem_w;    // memory write control signal
    wire [1:0]  MEM_WDSel;       // write data selection
    wire [31:0] MEM_aluout;
    wire  MEM_Zero ; 
    wire [2:0] MEM_NPCOp ; 
    EX_MEM_stage U_EX_MEM(
        .clk(clk),
        .reset(reset),
        .EX_Flush(1'b0),
        .EX_PC(EX_PC),.MEM_PC(MEM_PC),
        .EX_rd(EX_rd), .MEM_rd(MEM_rd),
        .EX_RD2(ForwardBData), .MEM_RD2(MEM_RD2),
        .EX_immout(EX_immout), .MEM_immout(MEM_immout),
        .EX_dm_ctrl(EX_dm_ctrl), .MEM_dm_ctrl(MEM_dm_ctrl),
        .EX_RegWrite(EX_RegWrite), .MEM_RegWrite(MEM_RegWrite),
        .EX_mem_w(EX_mem_w), .MEM_mem_w(MEM_mem_w),
        .EX_aluout(EX_aluout), .MEM_aluout(MEM_aluout),
        .EX_WDSel(EX_WDSel),  .MEM_WDSel(MEM_WDSel),
        .EX_NPCOp(EX_NPCSel),  .MEM_NPCOp(MEM_NPCOp)
    );

    /**************** mem  *******************/ 
    // wire [31:0] MEM_Data_in ; assign MEM_Data_in = Data_in;  // cpu in
    assign Addr_out = MEM_aluout;
    assign dm_ctrl = MEM_dm_ctrl;
    assign Data_out = MEM_RD2;
    assign mem_w = MEM_mem_w;


    

    // mem/wb reg
    wire [31:0] WB_PC;    //wire [4:0]  WB_rs1,WB_rs2,WB_rd;         
    wire [31:0]WB_aluout;
    wire [31:0]WB_Data_in;  // data from mem
    wire [1:0] WB_WDSel;  // write to reg data select at wb
    MEM_WB_stage U_MEM_WB(
        .clk(clk),
        .reset(reset),
        .MEM_PC(MEM_PC), .WB_PC(WB_PC),
        .MEM_rd(MEM_rd), .WB_rd(WB_rd),
        .MEM_aluout(MEM_aluout), .WB_aluout(WB_aluout),
        .MEM_Data_in(Data_in), .WB_Data_in(WB_Data_in),
        .MEM_WDSel(MEM_WDSel), .WB_WDSel(WB_WDSel),
        .MEM_RegWrite(MEM_RegWrite), .WB_RegWrite(WB_RegWrite)
    );


    /*
    *    wb
    */ 
    WB U_WB(
        .WB_aluout(WB_aluout),
        .WB_Data_in(WB_Data_in),  /// **important**
        .WB_PC(WB_PC),
        .WB_WDSel(WB_WDSel),
        .WB_WD(WB_WD)  
    );
    

    Forwarding_unit U_forward(
        // input 
        .MEM_rd(MEM_rd), 
        .WB_rd(WB_rd), 
        .EX_rs1(EX_rs1), 
        .EX_rs2(EX_rs2), 
        .EX_MEM_RegWrite(MEM_RegWrite),
        .MEM_WB_RegWrite(WB_RegWrite), 
        .MEM_aluout(MEM_aluout),
        .WB_WD(WB_WD),
        .EX_RD1(EX_RD1),
        .EX_RD2(EX_RD2),
        // output 
        .ForwardAData(ForwardAData),
        .ForwardBData(ForwardBData)
    ); 
    Hazard_detection U_hazard_detection(
        // input 
        .EX_mem_read (EX_mem_read),
        .EX_rd (EX_rd),
        .ID_rs1 (ID_rs1),
        .ID_rs2 (ID_rs2),
        // output
        // .PCWrite (PCWrite),
        // .IF_IDWrite (IF_IDWrite),
        // .ID_Flush_hazard (ID_Flush_hazard)
        .Hazard(Hazard)
    );
    
    Branch U_Branch(
        .IF_PC(IF_PC_out),
        .EX_PC(EX_PC),
        .EX_NPCSel(EX_NPCSel),
        .EX_immout(EX_immout),
        .EX_aluout(EX_aluout),
        .NPC(IF_NPC),
        .Branch(Branch)
    );
    /********************************end***********************************/


endmodule
