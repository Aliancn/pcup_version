`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/01 11:39:57
// Design Name: 
// Module Name: top
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


module top (
    input rstn,
    input [4:0] btn_i,
    input [15:0] sw_i,
    input clk,
    output [7:0] disp_an_o,
    output [7:0] disp_seg_o,
    output [15:0] led_o
);


    // Instantiate Enter module
    wire [4:0] BTN_out;
    wire [15:0] SW_out;
    
    //U8_clk_div
    wire [31:0] clkdiv;
    wire Clk_CPU;
    
    //U7_SPIO
    wire [13:0] GPIOf0;
    wire [15:0] LED_out;
    wire [1:0] counter_set;
    wire [15:0] led;
    
    //U3_dm_controller
    wire [31:0] Data_read, Data_write_to_dm;
    wire [3:0] wea_mem;
    
    //U2_ROMD
    wire [31:0]spo;
    wire [9:0]a;
    
    //U4_RAM_B
    wire [31:0] douta;
    
    //U1_SCPU
    wire [31:0]Addr_out;
    wire CPU_MIO;
    wire [31:0]Data_out;
    wire [31:0]PC_out;
    wire [2:0]dm_ctrl;
    wire  mem_w;
    
    //U9_Counter_X
    wire counter0_OUT;
    wire counter1_OUT;
    wire counter2_OUT;
    wire [31:0] counter_out;
    
    //U4_MIO_BUS
    wire [31:0] Cpu_data4bus;
    wire GPIOe0000000_we;
    wire GPIOf0000000_we;
    wire [31:0] Peripheral_in;
    wire counter_we;
    wire [9:0] ram_addr;
    wire [31:0] ram_data_in;
    wire data_ram_we;
    
    //  U5_Muti_8CH32
    wire [7:0] point_out;
    wire [7:0] LE_out;
    wire [31:0] Disp_num;
    
    
    wire rst_i;
    wire IO_clk_i;
    wire clka0_i;
    
    assign rst_i = ~rstn;
    assign IO_clk_i = ~Clk_CPU;
    assign clka0_i = ~clk;
    
    assign a = PC_out[11:2];
    
    
    
    Enter U10_Enter (
        .clk(clk),
        .BTN(btn_i),
        .SW(sw_i),
        .BTN_out(BTN_out),
        .SW_out(SW_out)
    );
    
    Multi_8CH32 U5_Multi_8CH32 (
        .clk(IO_clk_i),
        .rst(rst_i),
        .EN(GPIOe0000000_we),
        .Switch(SW_out[7:5]),
        .point_in({clkdiv[31:0], clkdiv[31:0]}),
        .LES(~64'b0),
        .data0(Peripheral_in),
        .data1({1'b0, 1'b0, PC_out[31:2]}),
        .data2(spo),
        .data3(counter_out),
        .data4(Addr_out),
        .data5(Data_out),
        .data6(Cpu_data4bus),
        .data7(PC_out),
        .point_out(point_out),
        .LE_out(LE_out),
        .Disp_num(Disp_num)
    );


    // Instantiate clk_div module
    
    clk_div U8_clk_div (
        .clk(clk),
        .rst(rst_i),
        .SW2(SW_out[2]),
        .Clk_CPU(Clk_CPU),
        .clkdiv(clkdiv)
    );
    
    // U2_ROMD
    ROM_D U2_ROMD (
        .a(a),
        .spo(spo)
    );
 
    // Instantiate SPIO module

    SPIO U7_SPIO (
        .clk(IO_clk_i),
        .rst(rst_i),
        .EN(GPIOf0000000_we),
        .P_Data(Peripheral_in),
        .counter_set(counter_set),
        .LED_out(LED_out),
        .led(led_o),
        .GPIOf0(GPIOf0)
    );

    // Instantiate dm_controller module

    dm_controller U3_dm_controller (
        .mem_w(mem_w),
        .Addr_in(Addr_out),
        .Data_write(ram_data_in),
        .dm_ctrl(dm_ctrl),
        .Data_read_from_dm(Cpu_data4bus),
        .Data_read(Data_read),
        .Data_write_to_dm(Data_write_to_dm),
        .wea_mem(wea_mem)
    );
    
    //U9_Counter_X
    Counter_x U9_Counter_X(
        .clk(IO_clk_i),
        .clk0(clkdiv[6]),
        .clk1(clkdiv[9]),
        .clk2(clkdiv[11]),
        .counter_ch(counter_set),
        .counter_val(Peripheral_in),
        .counter_we(counter_we),
        .rst(rst_i),
        .counter_out(counter_out),
        .counter0_OUT(counter0_OUT),
        .counter1_OUT(counter1_OUT),
        .counter2_OUT(counter2_OUT)
    );
    
    //U4_RAM_B
    RAM_B U4_RAM_B(
        .addra(ram_addr),
        .clka(clka0_i),
        .dina(Data_write_to_dm),
        .wea(wea_mem),
        .douta(douta)
    );

    // Instantiate SCPU module
    
    PCPU U1_PCPU (
        .clk(Clk_CPU),
        .INT(counter0_OUT),
        .MIO_ready(CPU_MIO),
        .reset(rst_i),
        .Data_in(Data_read),
        .inst_in(spo),
        .mem_w(mem_w),
        .PC_out(PC_out),
        .Addr_out(Addr_out),
        .Data_out(Data_out),
        .CPU_MIO(CPU_MIO),
        .dm_ctrl(dm_ctrl)
    );

    // Instantiate MIO_BUS module
    MIO_BUS U4_MIO_BUS (
        .BTN(BTN_out),
        .PC(PC_out),
        .Cpu_data2bus(Data_out),
        .SW(SW_out),
        .addr_bus(Addr_out),
        .clk(IO_clk_i),
        .counter_out(32'b0),
        .counter0_out(counter0_OUT),
        .counter1_out(counter1_OUT),
        .counter2_out(counter2_OUT),
        .led_out(LED_out),
        .mem_w(mem_w),
        .ram_data_out(douta),
        .rst(rst_i),
        .Cpu_data4bus(Cpu_data4bus),
        .GPIOe0000000_we(GPIOe0000000_we),
        .GPIOf0000000_we(GPIOf0000000_we),
        .Peripheral_in(Peripheral_in),
        .counter_we(counter_we),
        .ram_addr(ram_addr),
        .ram_data_in(ram_data_in),
        .data_ram_we(data_ram_we)
    );


    // Instantiate SSeg7 module
    SSeg7 U6_SSeg7 (
        .Hexs(Disp_num),
        .LES(LE_out),
        .SW0(SW_out[0]),
        .clk(clk),
        .flash(clkdiv[10]),
        .point(point_out),
        .rst(rst_i),
        .seg_an(disp_an_o),
        .seg_sout(disp_seg_o)
    );

endmodule

