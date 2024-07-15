`define ALUOp_nop 5'b00000
`define ALUOp_lui 5'b00001
`define ALUOp_auipc 5'b00010
`define ALUOp_add 5'b00011
`define ALUOp_sub 5'b00100
`define ALUOp_bne 5'b00101
`define ALUOp_blt 5'b00110
`define ALUOp_bge 5'b00111
`define ALUOp_bltu 5'b01000
`define ALUOp_bgeu 5'b01001
`define ALUOp_slt 5'b01010
`define ALUOp_sltu 5'b01011
`define ALUOp_xor 5'b01100
`define ALUOp_or 5'b01101
`define ALUOp_and 5'b01110
`define ALUOp_sll 5'b01111
`define ALUOp_srl 5'b10000
`define ALUOp_sra 5'b10001

module alu(A, B, ALUOp, C, Zero,PC);
           
   input  signed [31:0] A, B;
   input         [4:0]  ALUOp;
	input [31:0] PC;
   output signed [31:0] C;
   output Zero;

   reg [31:0] C;
      
   always @( * ) begin
      case ( ALUOp )
         `ALUOp_nop:C=A;
         `ALUOp_lui:C=B;
         `ALUOp_auipc:C=PC+B;
         `ALUOp_add:C=A+B;
         `ALUOp_sub:C=A-B;
         `ALUOp_bne:C={31'b0,(A==B)};
         `ALUOp_blt:C={31'b0,(A>=B)};
         `ALUOp_bge:C={31'b0,(A<B)};
         `ALUOp_bltu:C={31'b0,($unsigned(A)>=$unsigned(B))};
         `ALUOp_bgeu:C={31'b0,($unsigned(A)<$unsigned(B))};
         `ALUOp_slt:C={31'b0,(A<B)};
         `ALUOp_sltu:C={31'b0,($unsigned(A)<$unsigned(B))};
         `ALUOp_xor:C=A^B;
         `ALUOp_or:C=A|B;
         `ALUOp_and:C=A&B;
         `ALUOp_sll:C=A<<B;
         `ALUOp_srl:C=A>>B;
         `ALUOp_sra:C=A>>>B;
      endcase
      //输出A，B，ALUOp，C，Zero
      //$display("A=%d, B=%d, ALUOp=%b, C=%d, Zero=%d", A, B, ALUOp, C, Zero);
   end // end always
   assign Zero = (C == 32'b0);
endmodule
    
