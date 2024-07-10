module ID_EX_stage(
    input wire clk,
    input wire reset,
    input wire ID_Flush,
    input wire ID_Flush_hazard,
    input wire [31:0] ID_PC,
    input wire [4:0] ID_rs1,
    input wire [4:0] ID_rs2,
    input wire [4:0] ID_rd,
    input wire [31:0] ID_RD1,
    input wire [31:0] ID_RD2,
    input wire [31:0] ID_immout,
    input wire [2:0] ID_dm_ctrl,
    input wire ID_RegWrite,
    input wire ID_mem_w,
    input wire ID_mem_read,
    input wire [4:0] ID_ALUOp,
    input wire [1:0] ID_WDSel,
    input wire [2:0] ID_NPCOp,
    input wire ID_ALUSrc,
    output wire [31:0] EX_PC,
    output wire [4:0] EX_rs1,
    output wire [4:0] EX_rs2,
    output wire [4:0] EX_rd,
    output wire [31:0] EX_RD1,
    output wire [31:0] EX_RD2,
    output wire [31:0] EX_immout,
    output wire [2:0] EX_dm_ctrl,
    output wire EX_RegWrite,
    output wire EX_mem_w,
    output wire EX_mem_read,
    output wire [4:0] EX_ALUOp,
    output wire [1:0] EX_WDSel,
    output wire [2:0] EX_NPCOp,
    output wire EX_ALUSrc,
    output wire [31:0] EX_B
);

    wire [255:0] ID_EX_in;
    wire [255:0] ID_EX_out;

    // 组合输入信号
    assign ID_EX_in[31:0] = ID_PC;
    assign ID_EX_in[36:32] = ID_rs1;
    assign ID_EX_in[41:37] = ID_rs2;
    assign ID_EX_in[46:42] = ID_rd;
    assign ID_EX_in[78:47] = ID_RD1;
    assign ID_EX_in[110:79] = ID_RD2;
    assign ID_EX_in[142:111] = ID_immout;
    assign ID_EX_in[145:143] = ID_dm_ctrl;
    assign ID_EX_in[146] = ID_RegWrite;
    assign ID_EX_in[147] = ID_mem_w;
    assign ID_EX_in[148] = ID_mem_read;
    assign ID_EX_in[153:149] = ID_ALUOp;
    assign ID_EX_in[157:156] = ID_WDSel;
    assign ID_EX_in[160:158] = ID_NPCOp;
    assign ID_EX_in[161] = ID_ALUSrc;

    // 实例化GRE_array模块
    GRE_array U_ID_EX(
        .Clk(clk), 
        .Rst(reset), 
        .write_enable(1'b1), 
        .flush(ID_Flush), 
        .in(ID_EX_in), 
        .out(ID_EX_out)
    );

    // 分解输出信号
    assign EX_PC = ID_EX_out[31:0];
    assign EX_rs1 = ID_EX_out[36:32];
    assign EX_rs2 = ID_EX_out[41:37];
    assign EX_rd = ID_EX_out[46:42];
    assign EX_RD1 = ID_EX_out[78:47];
    assign EX_RD2 = ID_EX_out[110:79];
    assign EX_immout = ID_EX_out[142:111];
    assign EX_dm_ctrl = (ID_Flush_hazard) ? 3'b000: ID_EX_out[145:143];
    assign EX_RegWrite = (ID_Flush_hazard) ? 1'b0:ID_EX_out[146];
    assign EX_mem_w = (ID_Flush_hazard) ? 1'b0:ID_EX_out[147];
    assign EX_mem_read = ID_EX_out[148];
    assign EX_ALUOp = (ID_Flush_hazard) ? 5'b00000:ID_EX_out[153:149];
    assign EX_WDSel =(ID_Flush_hazard) ? 2'b00: ID_EX_out[157:156];
    assign EX_NPCOp = (ID_Flush_hazard) ? 3'b000:ID_EX_out[160:158];
    assign EX_ALUSrc = (ID_Flush_hazard) ? 1'b0:ID_EX_out[161];

    // 计算EX_B
    assign EX_B = (EX_ALUSrc) ? EX_immout : EX_RD2;

endmodule