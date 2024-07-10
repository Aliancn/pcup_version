`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 10:05:00
// Design Name: 
// Module Name: GRE_array
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

// flush 0 : no flush 1: flush
// write_enable 0 : no write 1: write
module GRE_array #(parameter WIDTH = 256)(
input  Clk ,Rst , write_enable ,flush ,
input [0:WIDTH -1 ] in , 
output reg[0:WIDTH -1 ] out 
    );

    always @(posedge Clk ,posedge Rst) begin
        if (Rst | flush) begin
            out <= 0;
        end 
        else if (write_enable) begin
            out <= in ;
        end
    end 
endmodule
