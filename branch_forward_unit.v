module branch_forward_unit(
    input MEM_Reg_RW,
    input [4:0] MEM_RD,
    input       EX_Reg_RW,
    input [4:0] EX_RD,
    input       ID_branch,
    input       ID_Jump,
    input [4:0] ID_RS1,
    input [4:0] ID_RS2,
    output reg  Forward_RS1,
    output reg  Forward_RS2,
    output reg  Stall,
    output reg  Flush
    );
    
    
always @(*) begin
    Forward_RS1 = 1'b0;
    Forward_RS2 = 1'b0;
    Stall       = 1'b0;
    //forwarding for RS1 input of the comparator
    if(MEM_Reg_RW && (ID_branch || ID_Jump) && MEM_RD != 5'd0 && MEM_RD == ID_RS1)
        Forward_RS1 = 1'b1;
    else
        Forward_RS1 = 1'b0;
    //forwarding for RS2 input of the comparator    
    if(MEM_Reg_RW && (ID_branch || ID_Jump) && MEM_RD != 5'd0 && MEM_RD == ID_RS2)
        Forward_RS2 = 1'b1;
    else
        Forward_RS2 = 1'b0;
    //Stalling for EX stage 
    if(EX_Reg_RW && (ID_branch || ID_Jump) && EX_RD != 5'd0 && (EX_RD == ID_RS1 || EX_RD == ID_RS2))
        Stall = 1'b1;
    else
        Stall = 1'b0;

end
    
endmodule
