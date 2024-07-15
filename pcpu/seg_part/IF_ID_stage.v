module IF_ID_stage(
    input wire clk,
    input wire reset,
    input wire IF_IDWrite,
    input wire IF_Flush,
    input wire [31:0] IF_inst,
    input wire [31:0] IF_PC_out,
    output [31:0] ID_PC,
    output [31:0] ID_inst
);
    wire [63:0] in ;
    reg [63:0] out;
    assign in = {IF_inst,IF_PC_out};
    assign ID_PC = out[31:0];   
    assign ID_inst = out[63:32];
    always @(posedge clk ,posedge reset) begin
        if (reset) begin
            out <= 64'b0;  
        end 
        else if (IF_Flush)begin
            out <= 64'b0;
        end
        else if (IF_IDWrite) begin
            out <= in ;
        end
    end 

endmodule