`define INT_TIMER 32'h00001000
module IF (
    input clk,
    input reset,
    input [31:0] IF_NPC,
    input PCWrite,
    input INT_detected,
    input INT_restore,
    output[31:0] IF_PC_out
);
    
    reg [31:0] pc ;
    wire [31:0] NPCPLUS4 = pc + 4;
    reg [31:0] pc_backup;
    always @(posedge clk, posedge reset)begin
        if (reset) begin
            pc <= 32'h00000000;
        end
        // INT 
        else if (INT_detected) begin
            pc_backup = pc;
            pc = `INT_TIMER;
        end
        else if (INT_restore) begin
            pc = pc_backup;
        end
        else if (PCWrite)begin
            pc =  IF_NPC;
        end
    end
    assign IF_PC_out = pc;


endmodule