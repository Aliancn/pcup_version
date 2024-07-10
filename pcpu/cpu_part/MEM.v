module MEM (
    input [31:0] MEM_aluout,
    input [2:0] MEM_dm_ctrl,
    input ForwardC,
    input [31:0] MEM_RD2,
    input [31:0] WB_WD,
    input MEM_mem_w,
    input [31:0] Data_in,
    output [31:0] Addr_out,
    output [2:0] dm_ctrl,
    output [31:0] Data_out,
    output mem_w ,
    output [31:0] MEM_Data_in
);
    assign Addr_out = MEM_aluout;   // cpu out
    assign dm_ctrl = MEM_dm_ctrl;  // cpu out 
    // assign Data_out = (ForwardC) ? WB_WD: MEM_RD2;	  // cpu out 
    assign Data_out = MEM_RD2;	  // cpu out
    assign mem_w = MEM_mem_w;	  // cpu out
    assign MEM_Data_in = Data_in;  // cpu in 
endmodule