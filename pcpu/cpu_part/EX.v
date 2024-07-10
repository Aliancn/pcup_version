
module EX (
    input [31:0] EX_PC ,
    input [31:0]ForwardAData,
    input [31:0]ForwardBData,
    input [4:0] EX_ALUOp,

    output signed [31:0] EX_aluout,
    output EX_Zero
);
   alu U_alu(
        // input 
        .A(ForwardAData),
        .B(ForwardBData),
        .ALUOp(EX_ALUOp), 
        .PC(EX_PC),
        // output 
        .C(EX_aluout), 
        .Zero(EX_Zero)  // transfer to mem and then ctrl
    );
endmodule