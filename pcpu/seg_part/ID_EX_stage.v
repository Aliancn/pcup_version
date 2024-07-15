module ID_EX_stage(
    input wire clk,
    input wire reset,
    input wire ID_Flush_branch,
    input wire ID_Flush_hazard,
    input wire INT_detected,
    input wire INT_restore,
    input wire [31:0] ID_PC,
    input wire [4:0] ID_rs1,
    input wire [4:0] ID_rs2,
    input wire [4:0] ID_rd,
    input wire [31:0] ID_RD1,
    input wire [31:0] ID_RD2,
    input wire [31:0] ID_immout,
    input wire [2:0] ID_dm_ctrl,
    input wire ID_RegWrite,
    input wire ID_mem_w,
    input wire ID_mem_read,
    input wire [4:0] ID_ALUOp,
    input wire [1:0] ID_WDSel,
    input wire [2:0] ID_NPCOp,
    input wire ID_ALUSrc,
    output [31:0] EX_PC,
    output [4:0] EX_rs1,
    output [4:0] EX_rs2,
    output [4:0] EX_rd,
    output [31:0] EX_RD1,
    output [31:0] EX_RD2,
    output [31:0] EX_immout,
    output [2:0] EX_dm_ctrl,
    output EX_RegWrite,
    output EX_mem_w,
    output EX_mem_read,
    output [4:0] EX_ALUOp,
    output [1:0] EX_WDSel,
    output [2:0] EX_NPCOp,
    output EX_ALUSrc
);

    wire [255:0] in; 
    reg [255:0] out;
    reg [255:0] out_backup;
    assign in = {ID_ALUSrc, ID_NPCOp, ID_WDSel, ID_ALUOp, ID_mem_read, ID_mem_w, ID_RegWrite, ID_dm_ctrl, ID_immout, ID_RD2, ID_RD1, ID_rd, ID_rs2, ID_rs1, ID_PC};
    assign EX_PC = (INT_detected == 1) ? 0 :out[31:0];
    assign EX_rs1 = (INT_detected == 1) ? 0 :out[36:32];
    assign EX_rs2 = (INT_detected == 1) ? 0 :out[41:37];
    assign EX_rd = (INT_detected == 1) ? 0 :out[46:42];
    assign EX_RD1 = (INT_detected == 1) ? 0 :out[78:47];
    assign EX_RD2 = (INT_detected == 1) ? 0 :out[110:79];
    assign EX_immout = (INT_detected == 1) ? 0 :out[142:111];
    assign EX_dm_ctrl = (INT_detected == 1) ? 0 :out[145:143];
    assign EX_RegWrite = (INT_detected == 1) ? 0 :out[146];
    assign EX_mem_w = (INT_detected == 1) ? 0 :out[147];
    assign EX_mem_read = (INT_detected == 1) ? 0 :out[148];
    assign EX_ALUOp = (INT_detected == 1) ? 0 :out[153:149];
    assign EX_WDSel = (INT_detected == 1) ? 0 :out[155:154];
    assign EX_NPCOp = (INT_detected == 1) ? 0 :out[158:156];
    assign EX_ALUSrc = (INT_detected == 1) ? 0 :out[159];

    always @(posedge clk , posedge reset) begin
        if (reset) begin
            out <= 0;
            // EX_PC <= 32'h00000000;
            // EX_rs1 <= 5'b00000;
            // EX_rs2 <= 5'b00000;
            // EX_rd <= 5'b00000;
            // EX_RD1 <= 32'h00000000;
            // EX_RD2 <= 32'h00000000;
            // EX_immout <= 32'h00000000;
            // EX_dm_ctrl <= 3'b000;
            // EX_RegWrite <= 1'b0;
            // EX_mem_w <= 1'b0;
            // EX_mem_read <= 1'b0;
            // EX_ALUOp <= 5'b00000;
            // EX_WDSel <= 2'b00;
            // EX_NPCOp <= 3'b000;
            // EX_ALUSrc <= 1'b0;
        end 
        else if (ID_Flush_branch | ID_Flush_hazard) begin
            out <= 0;
            // EX_PC <= 32'h00000000;
            // EX_rs1 <= 5'b00000;
            // EX_rs2 <= 5'b00000;
            // EX_rd <= 5'b00000;
            // EX_RD1 <= 32'h00000000;
            // EX_RD2 <= 32'h00000000;
            // EX_immout <= 32'h00000000;
            // EX_dm_ctrl <= 3'b000;
            // EX_RegWrite <= 1'b0;
            // EX_mem_w <= 1'b0;
            // EX_mem_read <= 1'b0;
            // EX_ALUOp <= 5'b00000;
            // EX_WDSel <= 2'b00;
            // EX_NPCOp <= 3'b000;
            // EX_ALUSrc <= 1'b0;
        end 
        // INT 
        else if (INT_detected) begin
            out_backup <= out;
        end
        else if (INT_restore) begin
            out <= out_backup;
        end
        else  begin
            out <= in;
            // EX_PC <= ID_PC;
            // EX_rs1 <= ID_rs1;
            // EX_rs2 <= ID_rs2;
            // EX_rd <= ID_rd;
            // EX_RD1 <= ID_RD1;
            // EX_RD2 <= ID_RD2;
            // EX_immout <= ID_immout;
            // EX_dm_ctrl <= ID_dm_ctrl;
            // EX_RegWrite <= ID_RegWrite;
            // EX_mem_w <= ID_mem_w;
            // EX_mem_read <= ID_mem_read;
            // EX_ALUOp <= ID_ALUOp;
            // EX_WDSel <= ID_WDSel;
            // EX_NPCOp <= ID_NPCOp;
            // EX_ALUSrc <= ID_ALUSrc;
        end
    end 

endmodule