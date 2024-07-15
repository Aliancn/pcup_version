`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 15:38:11
// Design Name: 
// Module Name: INT_stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module INT_stage(
    input wire ext_int,         // 外部中断信号
    input wire int_finished,    // 中断处理完成信号 
    output  int_detected,    // 中断检测标志
    output  int_restore     // 中断恢复标志
);

    
    assign int_detected = ext_int;
    assign int_restore = int_finished;

endmodule
