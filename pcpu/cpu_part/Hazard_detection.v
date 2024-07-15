`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/05 15:14:30
// Design Name: 
// Module Name: Hazard_detection
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


module Hazard_detection(
    EX_mem_read , EX_rd , ID_rs1 , ID_rs2 , Hazard
    );
    input EX_mem_read;
    input [4:0] EX_rd;
    input [4:0] ID_rs1;
    input [4:0] ID_rs2;
    // output reg PCWrite;
    // output reg IF_IDWrite;
    // output reg ID_Flush_hazard ;
    output reg Hazard;
    
    always@(*)begin 
        if(EX_mem_read == 1 && ((EX_rd == ID_rs1) ||(EX_rd == ID_rs2)) && EX_rd != 0)begin
            // PCWrite = 1'b0;
            // IF_IDWrite = 1'b0;
            // ID_Flush_hazard = 1'b1;
            Hazard = 1'b1;
        end else begin
            // PCWrite = 1'b1;
            // IF_IDWrite = 1'b1;
            // ID_Flush_hazard = 1'b0;
            Hazard = 1'b0;
        end
    end 
endmodule
