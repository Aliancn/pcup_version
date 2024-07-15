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
    input wire [2:0] EX_NPCOp,
    output [31:0] MEM_PC,
    output [4:0] MEM_rd,
    output [31:0] MEM_RD2,
    output [31:0] MEM_immout,
    output [2:0] MEM_dm_ctrl,
    output MEM_RegWrite,
    output MEM_mem_w,
    output [31:0] MEM_aluout,
    output [1:0] MEM_WDSel,
    output [2:0] MEM_NPCOp
);


    wire [255:0] in ;
    reg [255:0] out ; 
    assign in = {EX_NPCOp,EX_WDSel,EX_aluout,EX_mem_w,EX_RegWrite,EX_dm_ctrl,EX_immout,EX_RD2,EX_rd,EX_PC};
    assign MEM_PC = out[31:0];
    assign MEM_rd = out[36:32];
    assign MEM_RD2 = out[68:37];
    assign MEM_immout = out[100:69];
    assign MEM_dm_ctrl = out[103:101];
    assign MEM_RegWrite = out[104];
    assign MEM_mem_w = out[105];
    assign MEM_aluout = out[137:106];
    assign MEM_WDSel = out[139:138];
    assign MEM_NPCOp = out[142:140];
    always@(posedge clk, posedge reset)begin 
        if (reset) begin
            out <= 0;
            // MEM_PC <= 32'h00000000;
            // MEM_rd <= 5'b00000;
            // MEM_RD2 <= 5'b00000;
            // MEM_immout <= 32'h00000000;
            // MEM_dm_ctrl <=  3'b000;
            // MEM_RegWrite <= 1'b0;
            // MEM_mem_w <= 1'b0;
            // MEM_aluout <= 32'h00000000;
            // MEM_WDSel <= 2'b00;
            // MEM_NPCOp <= 3'b000;
        end 
        // else if (EX_Flush)begin
            // out <= 0;
            // MEM_PC <= 32'h00000000;
            // MEM_rd <= 5'b00000;
            // MEM_RD2 <= 5'b00000;
            // MEM_immout <= 32'h00000000;
            // MEM_dm_ctrl <=  3'b000;
            // MEM_RegWrite <= 1'b0;
            // MEM_mem_w <= 1'b0;
            // MEM_aluout <= 32'h00000000;
            // MEM_WDSel <= 2'b00;
            // MEM_NPCOp <= 3'b000;
        // end 
        else begin
            out <= in;
            // MEM_PC <= EX_PC;
            // MEM_rd <= EX_rd;
            // MEM_RD2 <= EX_RD2;
            // MEM_immout <= EX_immout;
            // MEM_dm_ctrl <= EX_dm_ctrl;
            // MEM_RegWrite <= EX_RegWrite;
            // MEM_mem_w <= EX_mem_w;
            // MEM_aluout <= EX_aluout;
            // MEM_WDSel <= EX_WDSel;
            // MEM_NPCOp <= EX_NPCOp;
        end

    end 

endmodule