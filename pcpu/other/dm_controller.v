`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b010
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100



module dm_controller(mem_w, Addr_in, Data_write, dm_ctrl, Data_read_from_dm, Data_read, Data_write_to_dm, wea_mem);
  input mem_w;
  input [31:0] Addr_in; // (?)
  input [31:0] Data_write;
  input [2:0] dm_ctrl;
  input [31:0] Data_read_from_dm;
  output reg [31:0] Data_read;
  output reg [31:0] Data_write_to_dm;
  output reg [3:0] wea_mem;

  // read from data memory
  always @(*) begin
    case(dm_ctrl)
      `dm_word: Data_read <= Data_read_from_dm;
      `dm_halfword:
        case (Addr_in[1:0])
          // sign extend
          2'b00: Data_read <= {{16{Data_read_from_dm[15]}}, Data_read_from_dm[15:0]};
          2'b10: Data_read <= {{16{Data_read_from_dm[31]}}, Data_read_from_dm[31:16]};
        endcase
      `dm_halfword_unsigned:
        case (Addr_in[1:0])
          // zero extend
          2'b00: Data_read <= {{16{1'b0}}, Data_read_from_dm[15:0]};
          2'b10: Data_read <= {{16{1'b0}}, Data_read_from_dm[31:16]};
        endcase
      `dm_byte:
        case (Addr_in[1:0])
          2'b00: Data_read <= {{24{Data_read_from_dm[7]}}, Data_read_from_dm[7:0]};
          2'b01: Data_read <= {{24{Data_read_from_dm[15]}}, Data_read_from_dm[15:8]};
          2'b10: Data_read <= {{24{Data_read_from_dm[23]}}, Data_read_from_dm[23:16]};
          2'b11: Data_read <= {{24{Data_read_from_dm[31]}}, Data_read_from_dm[31:24]};
        endcase
      `dm_byte_unsigned:
        case (Addr_in[1:0])
          2'b00: Data_read <= {{24{1'b0}}, Data_read_from_dm[7:0]};
          2'b01: Data_read <= {{24{1'b0}}, Data_read_from_dm[15:8]};
          2'b10: Data_read <= {{24{1'b0}}, Data_read_from_dm[23:16]};
          2'b11: Data_read <= {{24{1'b0}}, Data_read_from_dm[31:24]};
        endcase
    endcase   
  end

  // write to data memory
  always @(*) begin
    if (!mem_w) begin
      Data_write_to_dm <= 32'b0;
      wea_mem <= 4'b0000;
    end else begin
      case(dm_ctrl)
        `dm_word: begin
          Data_write_to_dm <= Data_write;
          wea_mem <= 4'b1111;
        end
        `dm_halfword, `dm_halfword_unsigned:
          case (Addr_in[1:0])
            2'b00: begin
              Data_write_to_dm <= {2{Data_write[15:0]}};
              wea_mem <= 4'b0011;
            end
            2'b10: begin
              Data_write_to_dm <= {2{Data_write[15:0]}};
              wea_mem <= 4'b1100;
            end
          endcase
        `dm_byte, `dm_byte_unsigned:
          case (Addr_in[1:0])
            2'b00: begin
              Data_write_to_dm <= {4{Data_write[7:0]}};
              wea_mem <= 4'b0001;
            end
            2'b01: begin
              Data_write_to_dm <= {4{Data_write[7:0]}};
              wea_mem <= 4'b0010;
            end
            2'b10: begin
              Data_write_to_dm <= {4{Data_write[7:0]}};
              wea_mem <= 4'b0100;
            end
            2'b11: begin
              Data_write_to_dm <= {4{Data_write[7:0]}};
              wea_mem <= 4'b1000;
            end
          endcase
      endcase
    end
  end
endmodule

