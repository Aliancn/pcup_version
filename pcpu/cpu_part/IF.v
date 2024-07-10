module IF (
    input clk,
    input reset,
    input [31:0] IF_NPC,
    input PCWrite,
    output reg[31:0] IF_PC_out
);
    initial
        IF_PC_out <= 32'h00000000;

    always @(posedge clk, posedge reset)begin
        if (reset) begin
            IF_PC_out <= 32'h00000000;
        end
        else if (PCWrite)begin
            IF_PC_out <= IF_NPC;
        end
    end
    


endmodule