
module EX (
    input [31:0] EX_PC ,
    input [31:0]ForwardAData,
    input [31:0]ForwardBData,
    input EX_ALUSrc,
    input [31:0] EX_immout,
    input [4:0] EX_ALUOp,
    input [2:0] EX_NPCOp,
    output [31:0] EX_aluout,
    output [2:0] EX_NPCSel
);
    wire EX_Zero; 
    wire [31:0] B; 
    assign B  = (EX_ALUSrc) ? EX_immout : ForwardBData;
    alu U_alu(
        // input 
        .A(ForwardAData),
        .B(B),
        .ALUOp(EX_ALUOp), 
        .PC(EX_PC),
        // output 
        .C(EX_aluout), 
        .Zero(EX_Zero) 
    );

    assign EX_NPCSel[2:1] = EX_NPCOp[2:1];
    assign EX_NPCSel[0] = EX_Zero & EX_NPCOp[0];
endmodule