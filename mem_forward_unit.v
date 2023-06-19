module mem_forward_unit(
    input       [4:0] MEM_RS2,
    input       [4:0] WB_RD,
    input             MEM_Mem_RW,
    output reg        Forward_MEM
    );
    
    
always @(*) begin
    
    if(WB_RD && (MEM_RS2 == WB_RD))
        Forward_MEM = 1'b1;
    else
        Forward_MEM = 1'b0;
end
    
endmodule
