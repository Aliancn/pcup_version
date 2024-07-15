module IF (
    input clk,
    input reset,
    input [31:0] IF_NPC,
    input PCWrite,
    output[31:0] IF_PC_out
);
    
    reg [31:0] pc ;
    wire [31:0] NPCPLUS4 = pc + 4;
    always @(posedge clk, posedge reset)begin
        if (reset) begin
            pc <= 32'h00000000;
        end
        else if (PCWrite)begin
            pc =  IF_NPC;
        end
    end
    assign IF_PC_out = pc;


endmodule