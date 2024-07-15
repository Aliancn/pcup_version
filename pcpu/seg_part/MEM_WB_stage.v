module MEM_WB_stage(
    input wire clk,
    input wire reset,
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
    assign in = {MEM_RegWrite,MEM_WDSel, MEM_Data_in, MEM_aluout, MEM_rd, MEM_PC};
    assign WB_PC = out[31:0];
    assign WB_rd = out[36:32];
    assign WB_aluout = out[68:37];
    assign WB_Data_in = out[100:69];
    assign WB_WDSel = out[102:101];
    assign WB_RegWrite = out[103];

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