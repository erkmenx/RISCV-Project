module forward_unit(
    input [4:0] MEM_RD,
    input [4:0] WB_RD,
    input [4:0] EX_RS1,
    input [4:0] EX_RS2,
    input MEM_load_enable, 
    input WB_load_enable,
    output reg [1:0] Forward_A, Forward_B
    );
    
always @(*) begin
    
    if(MEM_load_enable && (MEM_RD != 0) && (MEM_RD == EX_RS1))
        Forward_A = 2'b01; 
    else if(WB_load_enable && (WB_RD != 0) && (WB_RD == EX_RS1))
        Forward_A = 2'b10; 
    else
        Forward_A = 2'b00;
    
    if(MEM_load_enable && (MEM_RD != 0) && (MEM_RD == EX_RS2))
        Forward_B = 2'b01; 
    else if(WB_load_enable && (WB_RD != 0) && (WB_RD == EX_RS2))
        Forward_B = 2'b10; 
    else
        Forward_B = 2'b00; 
end
    
endmodule
