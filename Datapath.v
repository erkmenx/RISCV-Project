module Datapath(

input                   clk,
input                   rst,
input   [35:0]          Control_Word,
input   [31:0]          Data_in,
input   [31:0]          Imm,
input   [31:0]          PC,
input   [31:0]          PC_to_REG,
output  [31:0]          rs1_out,
output  [31:0]          Address_Out,
output  [31:0]          Data_Out,
output                  Z,
output                  N,
output                  V,
output                  C
    );
    

wire            SLT_Select;
wire [2:0]      Inst_Type;
wire [1:0]      Write_Strobe;
wire            Mux_D_Select;
wire [4:0]      RS2;
wire [4:0]      RS1;
wire [2:0]      func3;
wire [4:0]      RD;
wire [3:0]      F_Select;
wire            Mux_B_Select;
wire            Reg_RW;
wire            Mem_RW;

wire [31:0]     rd_dout0;
wire [31:0]     rd_dout1;
wire            condition_result;
wire [31:0]     Bus_B;
wire [31:0]     Bus_D;
wire [31:0]     FU_Result;
wire [3:0]      branch_select;

wire [31:0]     FU_or_MEM;
assign {branch_select, SLT_Select, Inst_Type, Write_Strobe, Mux_D_Select, RS2, RS1, func3, RD, F_Select, Mux_B_Select, Reg_RW, Mem_RW} = Control_Word;
// MUXB

assign Bus_B        =   Mux_B_Select    ?   Imm     :   rd_dout1;    
// MUXD
assign FU_or_MEM    =  Mux_D_Select    ?   Data_in :   FU_Result;
assign Bus_D        =  (|branch_select)    ?   PC_to_REG :   FU_or_MEM;

assign Address_Out  = FU_Result;
assign Data_Out = rd_dout1;
assign rs1_out = rd_dout0;

register_file   REG_FILE    (
                                .clk        ( clk       ),
                                .rst        ( rst       ),
                                .rd_addr0   ( RS1       ),
                                .rd_addr1   ( RS2       ),
                                .wr_addr0   ( RD        ),
                                .wr_din0    ( Bus_D     ),
                                .we_0       ( Reg_RW    ),
                                .rd_dout0   ( rd_dout0  ),
                                .rd_dout1   ( rd_dout1  )   );
                                
                                

FU              FUNC_UNIT       (
                                    .F_Select           ( F_Select          ),
                                    .A                  ( rd_dout0          ),
                                    .B                  ( Bus_B             ),
                                    .SLT_Select         ( SLT_Select        ),
                                    .Result             ( FU_Result         ),
                                    .condition_result   ( condition_result  ),
                                    .Z                  ( Z                 ),
                                    .N                  ( N                 ),
                                    .V                  ( V                 ),
                                    .C                  ( C                 )
    );

localparam BEQ_FUNC3  = 3'b000;
localparam BNE_FUNC3  = 3'b001;
localparam BLT_FUNC3  = 3'b100;
localparam BGE_FUNC3  = 3'b101;
localparam BLTU_FUNC3 = 3'b110;
localparam BGEU_FUNC3 = 3'b111;

localparam LB_FUNC3 = 3'b000;
localparam LH_FUNC3 = 3'b001;
localparam LW_FUNC3 = 3'b010;
localparam LBU_FUNC3 = 3'b100;
localparam LHU_FUNC3 = 3'b101;

localparam SB_FUNC3 = 3'b000;
localparam SH_FUNC3 = 3'b001;
localparam SW_FUNC3 = 3'b010;

localparam ADDI_FUNC3  = 3'b000;
localparam SLTI_FUNC3  = 3'b010;
localparam SLTIU_FUNC3 = 3'b011;
localparam XORI_FUNC3  = 3'b100;
localparam ORI_FUNC3   = 3'b110;
localparam ANDI_FUNC3  = 3'b111;

localparam SLLI_FUNC3 = 3'b001;
localparam SRLI_FUNC3 = 3'b101;
localparam SRAI_FUNC3 = 3'b101;

localparam SLLI_FUNC7 = 7'b0000000;
localparam SRLI_FUNC7 = 7'b0000000;
localparam SRAI_FUNC7 = 7'b0100000;



endmodule