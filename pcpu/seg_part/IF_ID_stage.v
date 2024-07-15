module IF_ID_stage(
    input wire clk,
    input wire reset,
    input wire IF_IDWrite,
    input wire IF_Flush,
    input wire INT_detected,
    input wire INT_restore,
    input wire [31:0] IF_inst,
    input wire [31:0] IF_PC_out,
    output [31:0] ID_PC,
    output [31:0] ID_inst
);
    wire [63:0] in ;
    reg [63:0]out_backup;
    reg [63:0] out;
    assign in = {IF_inst,IF_PC_out};
    assign ID_PC = (INT_detected == 1) ? 0 :out[31:0];   
    assign ID_inst = (INT_detected == 1) ? 0 :out[63:32];
    always @(posedge clk ,posedge reset) begin
        if (reset) begin
            out <= 64'b0;  
        end 
        else if (IF_Flush)begin
            out <= 64'b0;
        end
        // INT 
        else if (INT_detected) begin
            out_backup <= out;
        end
        else if (INT_restore) begin
            out <= out_backup;
        end
        else if (IF_IDWrite) begin
            out <= in ;
        end
    end 

endmodule