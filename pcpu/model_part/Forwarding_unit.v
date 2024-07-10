`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/05 09:15:10
// Design Name: 
// Module Name: Forwarding_unit
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
`define Forward_FromEX_MEM 2'b10
`define Forward_FromMEM_WB 2'b01

module Forwarding_unit(
    input[4:0] MEM_rd ,
    input[4:0] WB_rd ,
    input[4:0] EX_rs1 ,
    input[4:0] EX_rs2 ,
    input EX_MEM_RegWrite ,
    input MEM_WB_RegWrite ,
    input [31:0] MEM_aluout ,
    input [31:0] WB_WD ,
    input [31:0] EX_RD1 ,
    input [31:0] EX_B ,
    input EX_MEM_MemWrite ,
    input [4:0] MEM_rs2 ,
    output [31:0] ForwardAData ,
    output [31:0] ForwardBData ,
    output reg ForwardC
    );  

    reg [1:0] ForwardA = 2'b00;
    reg [1:0] ForwardB = 2'b00;

    always @(*) begin
        if(EX_MEM_RegWrite && (EX_rs1 == MEM_rd) && (MEM_rd != 0)) begin
            ForwardA = 2'b10;
        end
        else if  (MEM_WB_RegWrite 
        && (EX_rs1 == WB_rd) 
        && (WB_rd != 0) 
        && !(EX_MEM_RegWrite && (MEM_rd != 0 ) && (MEM_rd == EX_rs1) )) begin
            ForwardA = 2'b01;
        end
        else begin
            ForwardA = 2'b00;
        end

        if(EX_MEM_RegWrite && (EX_rs2 == MEM_rd) && (MEM_rd != 0)) begin
            ForwardB = 2'b10;
        end
        else if(MEM_WB_RegWrite 
        && (EX_rs2 == WB_rd) 
        && (WB_rd != 0)
        && !(EX_MEM_RegWrite && (MEM_rd != 0 ) && (MEM_rd == EX_rs2))) begin
            ForwardB = 2'b01;
        end
        else begin
            ForwardB = 2'b00;
        end

        if( MEM_WB_RegWrite
        && EX_MEM_MemWrite
        && (WB_rd != 0)
        && (WB_rd == MEM_rs2))begin   
            ForwardC = 1'b1;   
        end
        else begin
            ForwardC = 1'b0;
        end 
    end
    assign ForwardAData = (ForwardA==`Forward_FromEX_MEM) ? MEM_aluout : ((ForwardA==`Forward_FromMEM_WB) ? WB_WD : EX_RD1);
    assign ForwardBData = (ForwardB==`Forward_FromEX_MEM) ? MEM_aluout : ((ForwardB==`Forward_FromMEM_WB) ? WB_WD : EX_B);

endmodule
