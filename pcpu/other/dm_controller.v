`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b010
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100


module dm_controller(
    input mem_w,  // 读写控制信号�???1表示写入�???0表示读取
    input [31:0]Addr_in,  // 地址输入
    input [31:0]Data_write,  // 写入数据
    input [2:0]dm_ctrl, // 数据类型控制信号
    input [31:0]Data_read_from_dm,  // 从数据存储器读取的数�???
    output reg[31:0]Data_read,  // 读取的数�???
    output reg[31:0]Data_write_to_dm,  // 写入数据
    output reg[3:0]wea_mem  // 字节写入的位�???
  );
  always @(*) 
  begin
    // 写操�???
          // Data_write_to_dm = Data_write; // 默认情况下，直接写入Data_write的�??
          Data_read = 32'b0;
          Data_write_to_dm = 32'b0;
          wea_mem = 4'b0000;
          case (dm_ctrl)
              `dm_word: begin
                Data_read = Data_read_from_dm;
                if (mem_w) begin
                  Data_write_to_dm = Data_write;
                  wea_mem = 4'b1111; // 写入数据
                end 
              end
              `dm_halfword: begin
                // 根据地址的最低位决定读取半字的位�???
                  if (Addr_in[1] == 1'b1) begin 
                    // high half word
                    Data_read = {{16{Data_read_from_dm[31]}}, Data_read_from_dm[31:16]}; // 高半�???
                    if (mem_w) begin
                      Data_write_to_dm = {2{Data_write[15:0]}};
                      wea_mem = 4'b1100; // 高半�???
                    end
                  end 
                  else begin 
                    // low half word
                      Data_read = {{16{Data_read_from_dm[15]}}, Data_read_from_dm[15:0]};
                      if (mem_w) begin
                        Data_write_to_dm = {2{Data_write[15:0]}};
                        wea_mem = 4'b0011; // 低半�???
                      end 
                  end 
                  // 根据地址的最低位决定写入半字的位�???
                  
              end
              `dm_halfword_unsigned: begin
                  // 根据地址的最低位决定写入半字的位�???
                  if (Addr_in[1] == 1'b1 ) begin 
                    // high
                      Data_read = {16'b0, Data_read_from_dm[31:16]};
                      if (mem_w)begin                     
                         Data_write_to_dm = {2{Data_write[15:0]}};
                         wea_mem = 4'b1100;
                      end 
                  end 
                  else begin 
                    // low 
                      Data_read = {16'b0, Data_read_from_dm[15:0]};
                      if (mem_w) begin
                        Data_write_to_dm = {2{Data_write[15:0]}};
                        wea_mem = 4'b0011;
                      end 
                  end 
              end
              `dm_byte: begin
                  // 根据地址的最�???2位决定写入字节的位置
                  case (Addr_in[1:0])
                      2'b00: begin 
                        Data_read = {{24{Data_read_from_dm[7]}}, Data_read_from_dm[7:0]};
                        
                        if (mem_w)begin
                          Data_write_to_dm = {4{Data_write[7:0]}};
                           wea_mem = 4'b0001;
                        end 
                      end 
                      2'b01: begin 
                        Data_read = {{24{Data_read_from_dm[15]}}, Data_read_from_dm[15:8]};
                        
                        if (mem_w)begin
                          Data_write_to_dm = {4{Data_write[7:0]}};
                           wea_mem = 4'b0010;
                        end 
                      end 
                      2'b10:begin 
                        Data_read = {{24{Data_read_from_dm[23]}}, Data_read_from_dm[23:16]};
                        if (mem_w) begin
                          Data_write_to_dm ={4{Data_write[7:0]}};
                          wea_mem = 4'b0100;
                        end 
                      end 
                      2'b11: begin
                        Data_read = {{24{Data_read_from_dm[31]}}, Data_read_from_dm[31:24]};
                        if (mem_w) begin
                          Data_write_to_dm = {4{Data_write[7:0]}};
                          wea_mem = 4'b1000;
                        end 
                      end 
                  endcase
              end
              `dm_byte_unsigned: begin
                  // 根据地址的最�???2位决定写入字节的位置
                  case (Addr_in[1:0])
                      2'b00: begin
                        Data_read = {24'b0, Data_read_from_dm[7:0]};
                        if (mem_w) begin
                          Data_write_to_dm = {4{Data_write[7:0]}};
                          wea_mem = 4'b0001;
                        end 
                      end 
                      2'b01: begin
                        Data_read = {24'b0, Data_read_from_dm[15:8]};
                        if (mem_w) begin
                          Data_write_to_dm = {4{Data_write[7:0]}};
                          wea_mem = 4'b0010;
                        end 
                      end 
                      2'b10: begin
                        Data_read = {24'b0, Data_read_from_dm[23:16]};
                        if (mem_w) begin
                          Data_write_to_dm ={4{Data_write[7:0]}};
                          wea_mem = 4'b0100;
                        end 
                      end 
                      2'b11: begin
                        Data_read = {24'b0, Data_read_from_dm[31:24]};
                        
                        if (mem_w) begin
                          Data_write_to_dm = {4{Data_write[7:0]}};
                          wea_mem = 4'b1000;
                        end 
                      end 
                  endcase
              end
              // default: begin
              //   Data_read = Data_read_from_dm;
              //   Data_write_to_dm = Data_write;
              //   wea_mem = 4'b0000; // 不写�???
              // end 
          endcase
  end

  
endmodule
