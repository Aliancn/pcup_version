`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 00:53:44
// Design Name: 
// Module Name: EX_MEM_stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EX_MEM_stage(
    input wire clk,
    input wire reset,
    input EX_Flush,
    input wire [31:0] EX_PC,
    input wire [4:0] EX_rd,
    input wire [31:0] EX_RD2,
    input wire [31:0] EX_immout,
    input wire [2:0] EX_dm_ctrl,
    input wire EX_RegWrite,
    input wire EX_mem_w,
    input wire [31:0] EX_aluout,
    input wire [1:0] EX_WDSel,
    input wire EX_Zero,
    input wire [2:0] EX_NPCOp,
    input wire [4:0] EX_rs2,
    output wire [31:0] MEM_PC,
    output wire [4:0] MEM_rd,
    output wire [31:0] MEM_RD2,
    output wire [31:0] MEM_immout,
    output wire [2:0] MEM_dm_ctrl,
    output wire MEM_RegWrite,
    output wire MEM_mem_w,
    output wire [31:0] MEM_aluout,
    output wire [1:0] MEM_WDSel,
    output wire MEM_Zero,
    output wire [2:0] MEM_NPCOp,
    output wire [4:0] MEM_rs2
);

    wire [255:0] EX_MEM_in;
    wire [255:0] EX_MEM_out;

    // 组合输入信号
    assign EX_MEM_in = {EX_PC, EX_rd, EX_RD2, EX_immout, EX_dm_ctrl, EX_RegWrite, EX_mem_w, EX_aluout, EX_WDSel, EX_Zero, EX_NPCOp,EX_rs2};

    // 实例化GRE_array模块
    GRE_array U_EX_MEM(
        .Clk(clk), 
        .Rst(reset), 
        .write_enable(1'b1), 
        .flush(EX_Flush), 
        .in(EX_MEM_in), 
        .out(EX_MEM_out)
    );

    // 分解输出信号
    assign {MEM_PC, MEM_rd, MEM_RD2, MEM_immout, MEM_dm_ctrl, MEM_RegWrite, MEM_mem_w, MEM_aluout, MEM_WDSel, MEM_Zero, MEM_NPCOp,MEM_rs2} = EX_MEM_out;

endmodule