module hazard_detection_unit(
    input       EX_Mux_B_Select,
    input       EX_Mux_D_Select,
    input [4:0] EX_RD,
    input [4:0] ID_RS1,
    input [4:0] ID_RS2,
    output      stall
    );
//stall for load and use
wire MEM_Read;
assign MEM_Read         = EX_Mux_B_Select & EX_Mux_D_Select;
assign stall            = MEM_Read & (EX_RD == ID_RS1 | EX_RD == ID_RS2);
    
endmodule
