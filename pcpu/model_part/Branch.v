`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/05 14:53:12
// Design Name: 
// Module Name: Flush
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
`define NPC_BRANCH  3'b001
`define NPC_JUMP    3'b010
`define NPC_JALR    3'b100
`define NPC_PC4     3'b000
module Branch(
    input [31:0] IF_PC,
    input [31:0] EX_PC,
    input [2:0]  EX_NPCSel,
    input [31:0] EX_immout,
    input [31:0] EX_aluout,
    output reg [31:0] NPC,
    output Branch
    );

    wire [31:0] NPCPLUS4; 
    assign NPCPLUS4 = IF_PC + 4;
    assign Branch = (EX_NPCSel==0) ? 1'b0 : 1'b1;
    always @(*) begin
        case (EX_NPCSel)
            `NPC_BRANCH: NPC = EX_PC+EX_immout;
            `NPC_JUMP:   NPC = EX_PC+EX_immout;
            `NPC_JALR:   NPC = EX_aluout;
            `NPC_PC4:    NPC = NPCPLUS4;
            default : NPC = NPCPLUS4;
        endcase
   end // end always
    
endmodule
