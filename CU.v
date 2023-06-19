module CU(
    input           clk,
    input           rst,
    input   [31:0]  Instruction,
    input   [31:0]  rs1_in,
    input           Z,
    input           N,
    input           V,
    input           C,
    output  [31:0]  PC,
    output  [31:0]  PC_to_REG,
    output  [31:0]  immediate,
    output  [35:0]  Control_Word
    );
//Branch Controller to PC signals
wire            condition_result;
//Decoder to Datapath signals 
wire    [3:0]   branch_select;  
wire            SLT_Select;
wire    [1:0]   Write_Strobe;
wire            Mux_D_Select;
wire    [4:0]   RS2;
wire    [4:0]   RS1;
wire    [2:0]   func3;
wire    [4:0]   RD;
wire    [3:0]   F_Select;
wire            Mux_B_Select;
wire            Reg_RW;
wire            Mem_RW; 
//Decoder to Immediate Generator Signals
wire    [2:0]   Imm_Type;

//Parsing the control word
assign {branch_select, SLT_Select, Imm_Type, Write_Strobe, Mux_D_Select, RS2,
        RS1, func3, RD, F_Select, Mux_B_Select, Reg_RW, Mem_RW} = Control_Word;
  
    
PC PC_i 
(
           .clk                 ( clk               ),
           .rst                 ( rst               ),
           .imm                 ( immediate         ),
           .condition_result    ( condition_result  ),
           .rs1_in              ( rs1_in            ),
           .branch_select       ( branch_select     ),
           .PC_out              ( PC                ),
           .PC_to_REG           ( PC_to_REG         )
);   

//    input           clk,
//    input           rst,
//    input   [31:0]  imm,
//    input           condition_result,
//    input   [31:0]  rd_out,
//    input   [3:0]   branch_select,
//    output  [31:0]  PC_out,
//    output  [31:0]  PC_to_REG
    
branch_controller b_ctrl_i 
(
            .condition          ( func3             ),
            .Z                  ( Z                 ),
            .N                  ( N                 ),
            .V                  ( V                 ),
            .C                  ( C                 ),
            .condition_result   ( condition_result  )
);

Decoder Decoder_i 
(
            .Instruction        ( Instruction   ),
            .Control_Word       ( Control_Word  )
);
    
immediate_generator imm_gen_i
(
            .instruction        ( Instruction   ),
            .imm_type           ( Imm_Type      ),
            .immediate          ( immediate     )
);
    
endmodule
