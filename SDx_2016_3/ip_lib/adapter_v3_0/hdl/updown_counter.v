`timescale 1ns / 1ps

module updown_counter #(
    parameter RANGE=4
    )(
    input up,
    input down,
    input clk,
    input rstn,
    output full,
    output empty
    );    
    
    // function called clogb2 returns the ceil(log2(n))                     
    function integer clogb2 (input integer bit_depth);              
    begin                                                           
        for(clogb2=0; bit_depth>1; clogb2=clogb2+1)                   
            bit_depth = bit_depth >> 1;                                 
        end                                                           
    endfunction 
    
    localparam DEPTH = clogb2(RANGE);
    
    reg [DEPTH-1:0] counter;
    wire full_i;
    wire empty_i;
    
    assign full_i = (counter == RANGE);
    assign empty_i = (counter == 0);
    
    assign full = full_i;
    assign empty = empty_i;
    
    always @(posedge clk) begin
        if(~rstn) begin
            counter <= 0;
        end
        else begin
            if(up && ~down && ~full_i)
                counter <= counter + 1;
            else if(~up && down && ~empty)
                counter <= counter - 1;
        end        
    end
    
endmodule
