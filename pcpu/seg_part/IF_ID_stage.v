module IF_ID_stage(
    input wire clk,
    input wire reset,
    input wire IF_IDWrite,
    input wire IF_Flush,
    input wire [31:0] IF_inst,
    input wire [31:0] PC_out,
    output wire [31:0] ID_PC,
    output wire [31:0] ID_inst
);

    wire [255:0] IF_ID_in;
    wire [255:0] IF_ID_out;

    // 组合输入信号
    assign IF_ID_in = {IF_inst, PC_out};

    // 实例化GRE_array模块
    GRE_array U_IF_ID(
        .Clk(clk), 
        .Rst(reset), 
        .write_enable(IF_IDWrite), 
        .flush(IF_Flush), 
        .in(IF_ID_in), 
        .out(IF_ID_out)
    );

    // 分解输出信号
    assign {ID_inst, ID_PC} = IF_ID_out;

endmodule