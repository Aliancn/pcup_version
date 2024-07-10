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
`define NPC_PLUS4   3'b000
`define NPC_BRANCH  3'b001
`define NPC_JUMP    3'b010
`define NPC_JALR 3'b100

module Branch(
    input [31:0] IF_PC_out,
    input [31:0] MEM_PC,
    input [2:0]  MEM_NPCOp,
    input [31:0] MEM_immout,
    input [31:0] MEM_aluout,
    input MEM_Zero,
    output  IF_Flush,
    output  ID_Flush,
    output  EX_Flush,
    output reg [31:0] NPC
    );


    wire [2:0] MEM_NPCSel;
    assign MEM_NPCSel[0] = MEM_NPCOp[0] & MEM_Zero;
    assign MEM_NPCSel[1] = MEM_NPCOp[1];
    assign MEM_NPCSel[2] = MEM_NPCOp[2];

    wire [31:0] PCPLUS4;assign PCPLUS4 = IF_PC_out + 4; // pc + 4

    wire [2:0] NPCOp ;assign NPCOp = MEM_NPCSel;

    assign IF_Flush = MEM_NPCSel[0] | MEM_NPCSel[1] | MEM_NPCSel[2];
    assign ID_Flush = MEM_NPCSel[0] | MEM_NPCSel[1] | MEM_NPCSel[2];
    assign EX_Flush = MEM_NPCSel[0] | MEM_NPCSel[1] | MEM_NPCSel[2];

    always @(*) begin
        case (NPCOp)
            `NPC_PLUS4:  NPC <= PCPLUS4;
            `NPC_BRANCH: NPC <= MEM_PC+MEM_immout;
            `NPC_JUMP:   NPC <= MEM_PC+MEM_immout;
            `NPC_JALR:   NPC <= MEM_aluout;
            default:     NPC <= PCPLUS4;
        endcase

       
   end // end always
    
endmodule
