`define WDSel_FromALU 2'b00
`define WDSel_FromMEM 2'b01
`define WDSel_FromPC 2'b10

module WB (
    input clk,
    input [31:0]WB_aluout,
    input [31:0]WB_Data_in,
    input [31:0]WB_PC,
    input [1:0] WB_WDSel,
    output reg[31:0]WB_WD
);
    always @(*)
    begin
        case(WB_WDSel)
            `WDSel_FromALU: WB_WD=WB_aluout;
            `WDSel_FromMEM: WB_WD=WB_Data_in;
            `WDSel_FromPC: WB_WD=WB_PC+4;
        endcase
    end
endmodule