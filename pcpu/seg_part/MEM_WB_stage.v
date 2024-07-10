module MEM_WB_stage(
    input wire clk,
    input wire reset,
    input wire [31:0] MEM_PC,
    input wire [4:0] MEM_rd,
    input wire [31:0] MEM_aluout,
    input wire [31:0] MEM_Data_in,
    input wire [1:0] MEM_WDSel,
    input wire MEM_RegWrite,
    output wire [31:0] WB_PC,
    output wire [4:0] WB_rd,
    output wire [31:0] WB_aluout,
    output wire [31:0] WB_Data_in,
    output wire [1:0] WB_WDSel,
    output wire WB_RegWrite
);

    wire [255:0] MEM_WB_in;
    wire [255:0] MEM_WB_out;

    // 组合输入信号
    assign MEM_WB_in = {MEM_PC, MEM_rd, MEM_aluout, MEM_Data_in, MEM_WDSel, MEM_RegWrite};

    // 实例化GRE_array模块
    GRE_array U_MEM_WB(
        .Clk(clk), 
        .Rst(reset), 
        .write_enable(1'b1), 
        .flush(1'b0), 
        .in(MEM_WB_in), 
        .out(MEM_WB_out)
    );

    // 分解输出信号
    assign {WB_PC, WB_rd, WB_aluout, WB_Data_in, WB_WDSel, WB_RegWrite} = MEM_WB_out;

endmodule