
  module RF(   input         clk, 
               input         rst,
               input         RFWr, 
               input  [4:0]  A1, A2, A3, 
               input  [31:0] WD, 
               output reg [31:0] RD1, RD2);

  reg [31:0] rf[31:0];
  integer i;

  initial begin
    for (i = 0; i < 32; i = i + 1)
      rf[i] <= 0;
  end

  always @(posedge clk,posedge rst)begin
    if (rst) begin    //  reset
      for (i=1; i<32; i=i+1)
        rf[i] <= 0; //  i;
    end
    
    else if(RFWr && A3 != 0) begin //不能修改0号寄存器的值
      rf[A3] = WD;
      //$display("RF[%d] <= %d", A3, WD);
    end
  end 


  always @(negedge clk)begin
      if (A1 != 0) begin
          RD1 <= (A1 == A3 )? WD: rf[A1];
      end
      else begin
          RD1 <= 0;
      end

      if (A2 != 0) begin
          RD2 <= (A2 == A3 )? WD: rf[A2];
      end
      else begin
          RD2 <= 0;
      end
  end

  // always @(negedge clk,posedge rst)begin
  //   if (rst) begin    //  reset
  //     for (i=1; i<32; i=i+1)
  //       rf[i] <= 0; //  i;
  //   end
    
  //   else if(RFWr && A3 != 0) begin //不能修改0号寄存器的值
  //     rf[A3] = WD;
  //     //$display("RF[%d] <= %d", A3, WD);
  //   end
  // end 
  // assign RD1 = (A1 != 0) ? rf[A1] : 0;
  // assign RD2 = (A2 != 0) ? rf[A2] : 0;


endmodule 
