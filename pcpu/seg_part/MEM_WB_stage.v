module MEM_WB_stage(
    input wire clk,
    input wire reset,
    input wire INT_detected,
    input wire INT_restore,
    input wire [31:0] MEM_PC,
    input wire [4:0] MEM_rd,
    input wire [31:0] MEM_aluout,
    input wire [31:0] MEM_Data_in,
    input wire [1:0] MEM_WDSel,
    input wire MEM_RegWrite,
    output [31:0] WB_PC,
    output [4:0] WB_rd,
    output [31:0] WB_aluout,
    output [31:0] WB_Data_in,
    output [1:0] WB_WDSel,
    output WB_RegWrite
);

    wire [255:0] in ;
    reg [255:0] out ;
    reg [255:0] out_backup;
    assign in = {MEM_RegWrite,MEM_WDSel, MEM_Data_in, MEM_aluout, MEM_rd, MEM_PC};
    assign WB_PC = (INT_detected == 1) ? 0 :out[31:0];
    assign WB_rd = (INT_detected == 1) ? 0 :out[36:32];
    assign WB_aluout = (INT_detected == 1) ? 0 :out[68:37];
    assign WB_Data_in = (INT_detected == 1) ? 0 :out[100:69];
    assign WB_WDSel = (INT_detected == 1) ? 0 :out[102:101];
    assign WB_RegWrite = (INT_detected == 1) ? 0 :out[103];

    always@(posedge clk, posedge reset)begin 
        if (reset) begin
            out <= 0;
            // WB_PC <= 32'h00000000;
            // WB_rd <= 5'b00000;
            // WB_aluout <= 32'h00000000;
            // WB_Data_in <= 32'h00000000;
            // WB_WDSel <= 2'b00;
            // WB_RegWrite <= 1'b0;
        end
        // INT 
        else if (INT_detected) begin
            out_backup <= out;
        end
        else if (INT_restore) begin
            out <= out_backup;
        end
        else begin
            out <= in;
            // WB_PC <= MEM_PC;
            // WB_rd <= MEM_rd;
            // WB_aluout <= MEM_aluout;
            // WB_Data_in <= MEM_Data_in;
            // WB_WDSel <= MEM_WDSel;
            // WB_RegWrite <= MEM_RegWrite;
        end
    end
endmodule