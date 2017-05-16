`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Xilinx Inc
// Engineer: Sam Skalicky
// 
// Create Date: 08/19/2016 01:47:51 PM
// Design Name: AXIS FIFO HDL module
// Module Name: axis_fifo
// Project Name: SDSoC Trace Framework
// Target Devices: Zynq
// Tool Versions: 2016.3
// Description: AXIS FIFO module
// 
// Dependencies: BRAM
// 
// Revision 1.0
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axis_fifo #
  (
   parameter C_DATA_WIDTH = 32,
   parameter C_DATA_DEPTH = 16
   ) (
      input aresetn,
      input inclk,
      input [C_DATA_WIDTH-1:0] in_tdata,
      input in_tlast,  
      input in_tvalid,
      output in_tready,
      input outclk, 
      output [C_DATA_WIDTH-1:0] out_tdata,
      input out_tready,
      output out_tvalid,
      output out_tlast
      );

   wire [C_DATA_WIDTH:0] in_data;
   wire [C_DATA_WIDTH:0] out_data;
   wire full, empty;

   assign in_data = {in_tlast,in_tdata};
   assign out_tdata = out_data[C_DATA_WIDTH-1:0];
   assign out_tlast = out_data[C_DATA_WIDTH];
   
   assign in_tready = ~full;
   assign out_tvalid = ~empty;
   
   localparam REAL_WIDTH = C_DATA_WIDTH + 1;
   
    fifo #( 
        .WIDTH(REAL_WIDTH),
        .DEPTH(C_DATA_DEPTH)
    ) axis_fifo0_i (
        .wr_clk(inclk),
        .din(in_data),
        .write(in_tvalid),
        .full(full),
        .dout(out_data),
        .read(out_tready),
        .empty(empty),
        .rd_clk(outclk) 
    );
            
endmodule
