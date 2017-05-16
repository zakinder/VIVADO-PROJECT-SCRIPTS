`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Xilinx Inc
// Engineer: Sam Skalicky
// 
// Create Date: 01/12/2016 01:47:51 PM
// Design Name: BRAM HDL module
// Module Name: bram
// Project Name: SDSoC Trace Framework
// Target Devices: Zynq
// Tool Versions: 2015.4
// Description: Generic BRAM module
// 
// Dependencies: None
// 
// Revision 1.0
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module internal_byte_bram #(
    parameter C_ADDR_WIDTH = 0,
    parameter C_DATA_DEPTH = 0
    ) (
    input aclk,
    input [C_ADDR_WIDTH-1:0] aaddr,
    input [7:0] adin,
    output [7:0] adout,
    input awe,
    input aen,
    input bclk,
    input [C_ADDR_WIDTH-1:0] baddr,
    input [7:0] bdin,
    output [7:0] bdout,
    input bwe,
    input ben
    );
    
    reg [7:0] aout;
    reg [7:0] bout;
    
    reg [7:0] mem [0:C_DATA_DEPTH-1];
    integer idx;
     
    initial begin
        for(idx=0; idx<C_DATA_DEPTH; idx=idx+1) begin
            mem[idx] <= 0;
        end
    end
    
   assign adout = aout;
   assign bdout = bout;
    
    //port a
    always @(posedge aclk) begin
        if(aen) begin
           aout <= mem[aaddr];
           if(awe)
             mem[aaddr] <= adin;
        end
    end
    
    //port b
    always @(posedge bclk) begin
        if(ben) begin  
           bout <= mem[baddr];
            if(bwe)
                mem[baddr] <= bdin;
        end
    end
endmodule

module byte_bram(
    input aclk,
    input [C_ADDR_WIDTH-1:0] aaddr,
    input [C_DATA_WIDTH-1:0] adin,
    output [C_DATA_WIDTH-1:0] adout,
    input [C_DATA_WIDTH/8-1:0] awe,
    input aen,
    input bclk,
    input [C_ADDR_WIDTH-1:0] baddr,
    input [C_DATA_WIDTH-1:0] bdin,
    output [C_DATA_WIDTH-1:0] bdout,
    input [C_DATA_WIDTH/8-1:0] bwe,
    input ben
    );
    
    // function called logb2 returns the floor(log2(n))                     
    function integer flogb2 (input integer bit_depth);              
    begin                                                           
        for(flogb2=0; bit_depth>1; flogb2=flogb2+1)                   
            bit_depth = bit_depth >> 1;                                 
        end                                                           
    endfunction
        
    parameter C_DATA_WIDTH = 32;
    parameter C_DATA_DEPTH = 16;
    parameter C_ADDR_WIDTH = 4;
    
    localparam NUM_BYTES = C_DATA_WIDTH/8;
    localparam ADDR_LSB = flogb2(NUM_BYTES);
    
    wire [C_ADDR_WIDTH-ADDR_LSB-1:0] address_a;
    wire [C_ADDR_WIDTH-ADDR_LSB-1:0] address_b;
    
    assign address_a = aaddr[C_ADDR_WIDTH-1:ADDR_LSB];
    assign address_b = baddr[C_ADDR_WIDTH-1:ADDR_LSB];
            
    genvar index;
    generate
        //loop and generate byte-wide BRAMs as needed for the specified data width
        for(index = 0; index < NUM_BYTES; index = index + 1) begin : BYTE_LOOP
            internal_byte_bram #(
                .C_ADDR_WIDTH(C_ADDR_WIDTH-ADDR_LSB),
                .C_DATA_DEPTH(C_DATA_DEPTH)
            ) internal_byte_bram_i (
                .aclk(aclk),
                .aaddr(address_a),
                .adin(adin[(index+1)*8-1:index*8]),
                .adout(adout[(index+1)*8-1:index*8]),
                .awe(awe[index]),
                .aen(aen),
                .bclk(bclk),
                .baddr(address_b),
                .bdin(bdin[(index+1)*8-1:index*8]),
                .bdout(bdout[(index+1)*8-1:index*8]),
                .bwe(bwe[index]),
                .ben(ben)
            );
        end
    endgenerate
    
endmodule
