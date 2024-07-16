`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 20:43:38
// Design Name: 
// Module Name: Clock
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


module Clock (
    input wire clk,
    input wire reset,
    output reg timer_interrupt
);
    reg [63:0] mtime =0 ;
    reg [63:0] mtimecmp = 8'd25;
    reg mtimeen = 1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mtime <= 0;
            timer_interrupt <= 0;
            mtimecmp <= 8'd25;
        end else begin
            mtime <= mtime + 1;
            if (mtime >= mtimecmp && mtimeen == 1) begin
                timer_interrupt <= 1;
                mtimeen <= 0; 
            end else begin
                timer_interrupt <= 0;
            end
        end
    end
endmodule

