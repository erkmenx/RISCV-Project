module TOP(
    input           clk,
    input           rst,
    input   [31:0]  Instruction,
    input   [31:0]  mem_data_in,
    output  [31:0]  mem_data_out,
    output  [31:0]  mem_address_out,
    output  [31:0]  PC,
    output          mem_we,
    output  [1:0]   mem_Write_Strobe_out
    );

//IF STAGE WIRES
wire [31:0] IF_immediate;
wire        IF_condition_result;
wire [31:0] IF_PC_plus_4;
wire [31:0] IF_rs1_in;
wire [31:0] IF_PC;
wire [3:0]  IF_branch_select;
wire [31:0] PC_next;
//ID STAGE WIRES
wire        ID_condition_result;
wire [31:0] ID_PC_plus_4;
wire [4:0]  ID_RS1;
wire [4:0]  ID_RS2;
wire [4:0]  ID_RD;
wire        ID_Reg_RW; 
wire [31:0] ID_rd_dout0;
wire [31:0] ID_rd_dout1;
wire [31:0] ID_instruction; 
wire [35:0] ID_Control_Word;
wire [2:0]  ID_Imm_Type; 
wire [31:0] ID_immediate;
wire        ID_Mux_B_Select;
wire        ID_Mux_D_Select;
wire [3:0]  ID_branch_select;
wire [31:0] ID_FU_or_MEM;
wire [31:0] ID_FU_Result;
wire [31:0] ID_PC;
wire [31:0] ID_Data_in;
wire [31:0] ID_rd_dout1;
wire [31:0] ID_FU_or_MEM;
wire [31:0] ID_Bus_D;
wire [2:0]  ID_func3;
wire        ID_branch;
wire [31:0] ID_Comparator_RS1;
wire [31:0] ID_Comparator_RS2;
wire [31:0] ID_PC_plus_imm;
wire        ID_Jump;
wire [31:0] ID_PC_next;
//EX STAGE WIRES
wire [31:0] EX_PC_plus_4;
wire [35:0] EX_Control_Word;
wire [3:0]  EX_F_Select;
wire [31:0] EX_rd_dout0;
wire [31:0] EX_Bus_B;
wire [31:0] EX_Bus_A;
wire        EX_SLT_Select;
wire        EX_Mux_B_Select;
wire [31:0] EX_immediate;
wire [31:0] EX_rd_dout1;
wire [31:0] EX_FU_Result;
wire        EX_condition_result;
wire        EX_Z, EX_N, EX_V, EX_C;
wire [2:0]  EX_func3;
wire [31:0] EX_PC;
wire [31:0] EX_PC_to_REG; // hesaplamasýný yap
wire [31:0] EX_PC_plus_imm;
wire [3:0]  EX_branch_select;
wire [4:0]  EX_RS1;
wire [4:0]  EX_RS2;
wire [4:0]  EX_RD;
wire [31:0] EX_Forward_A;
wire [31:0] EX_Forward_B;
wire        EX_Mux_D_Select;
wire        EX_Reg_RW;
//MEM STAGE WIRES
wire [31:0] MEM_mem_data_out;
wire [31:0] MEM_mem_address_out;
wire        MEM_mem_we;
wire [31:0] MEM_PC_plus_4;
wire [31:0] MEM_rd_dout1;
wire [31:0] MEM_PC;
wire [31:0] MEM_PC_plus_imm;
wire [31:0] MEM_FU_Result;
wire [35:0] MEM_Control_Word;
wire        MEM_condition_result;
wire [3:0]  MEM_branch_select;
wire [31:0] MEM_PC_next;
wire        MEM_Mux_D_Select;
wire [31:0] MEM_Bus_D;
wire [31:0] MEM_mem_data_in;
wire [1:0]  MEM_Write_Strobe;
wire [31:0] MEM_Forward_B;
wire [4:0]  MEM_RD;
wire        MEM_load_enable;
wire        MEM_Jump;
//WB STAGE WIRES
wire [2:0]  WB_Imm_Type;
wire [31:0] WB_immediate;
wire        WB_Mux_B_Select;
wire        WB_Mux_D_Select;
wire [3:0]  WB_branch_select;
wire [31:0] WB_FU_or_MEM;
wire [31:0] WB_FU_Result;
wire [31:0] WB_PC_to_REG;
wire [31:0] WB_Data_in;
wire [31:0] WB_rd_dout1;
wire [31:0] WB_Bus_B;      
wire [31:0] WB_FU_or_MEM;
wire [31:0] WB_PC_plus_4;
wire [31:0] WB_Bus_D;
wire [31:0] WB_PC;
wire [31:0] WB_PC_plus_imm;
wire [35:0] WB_Control_Word;
wire        WB_Reg_RW;
wire [31:0] WB_Bus_din0;
wire [4:0]  WB_RD;
wire        WB_load_enable;
//------------------- IF STAGE --------------------
assign IF_immediate         = EX_immediate;
assign IF_condition_result  = ID_condition_result;
assign IF_rs1_in            = EX_rd_dout0;
assign IF_branch_select     = EX_branch_select;

reg [31:0] PC_reg;

assign IF_PC_plus_4 = PC_reg + 4;

assign PC_next = (ID_branch_select[0] && ID_condition_result || ID_Jump ) ? ID_PC_next : IF_PC_plus_4;
assign PC = PC_reg;
assign IF_PC = PC_reg;

reg [95:0] REG_IF_ID;
//IF_PC_plus_4,IF_PC[31:0],Instruction[31:0],
//-------------------------------------------------

//------------------ HAZARD DETECTION -------------

wire STALL;
hazard_detection_unit h_detect_u_i(
        .EX_Mux_B_Select    ( EX_Mux_B_Select   ),
        .EX_Mux_D_Select    ( EX_Mux_D_Select   ),
        .EX_RD              ( EX_RD             ),
        .ID_RS1             ( ID_RS1            ),
        .ID_RS2             ( ID_RS2            ),
        .stall              ( STALL             )
    );
//-------------------------------------------------

//-------------------- ID STAGE -------------------

assign ID_instruction   = REG_IF_ID[31:0];
assign ID_PC            = REG_IF_ID[63:32];
assign ID_Imm_Type      = ID_Control_Word[30:28];
assign ID_Mux_B_Select  = ID_Control_Word[2];
assign ID_Mux_D_Select  = ID_Control_Word[25];
assign ID_branch_select = ID_Control_Word[35:32];
assign ID_PC_plus_4     = REG_IF_ID[95:64];

Decoder Decoder_i 
(
            .Instruction        ( ID_instruction   ),
            .Control_Word       ( ID_Control_Word  )
);

immediate_generator imm_gen_i
(
            .instruction        ( ID_instruction   ),
            .imm_type           ( ID_Imm_Type      ),
            .immediate          ( ID_immediate     )
);

  
assign ID_FU_or_MEM = WB_Mux_D_Select      ?   WB_Data_in      :   WB_FU_Result;
assign ID_Bus_D     = WB_Bus_din0;
assign ID_RS1       = ID_Control_Word[19:15];
assign ID_RS2       = ID_Control_Word[24:20];
assign ID_RD        = WB_Control_Word[11:7];
assign ID_Reg_RW    = WB_Reg_RW;
assign ID_func3     = ID_Control_Word[14:12];

wire Comparator_Forward_RS1;
wire Comparator_Forward_RS2;
assign ID_Comparator_RS1 = Comparator_Forward_RS1 ? MEM_Bus_D : ID_rd_dout0;
assign ID_Comparator_RS2 = Comparator_Forward_RS2 ? MEM_Bus_D : ID_rd_dout1;

register_file   REG_FILE    
(
            .clk        ( clk           ),
            .rst        ( rst           ),
            .rd_addr0   ( ID_RS1        ),
            .rd_addr1   ( ID_RS2        ),
            .wr_addr0   ( ID_RD         ),
            .wr_din0    ( ID_Bus_D      ),
            .we_0       ( ID_Reg_RW     ),
            .rd_dout0   ( ID_rd_dout0   ),
            .rd_dout1   ( ID_rd_dout1   )   
);

wire ID_Stall;
comparator_unit comp_unit
(
            .RS1                ( ID_Comparator_RS1     ),
            .RS2                ( ID_Comparator_RS2     ),
            .branch             ( ID_branch_select[0]   ),
            .condition          ( ID_func3              ),
            .condition_result   ( ID_condition_result   )
);

wire ID_branch_Flush;
branch_forward_unit branch_fw_unit_i (
        .MEM_Reg_RW     ( MEM_load_enable),
        .MEM_RD         ( MEM_RD),
        .EX_Reg_RW      ( EX_Reg_RW),
        .EX_RD          ( EX_RD),
        .ID_branch      ( ID_branch_select[0]),
        .ID_Jump        ( ID_Jump),
        .ID_RS1         ( ID_RS1),
        .ID_RS2         ( ID_RS2),
        .Forward_RS1    ( Comparator_Forward_RS1),
        .Forward_RS2    ( Comparator_Forward_RS2),
        .Stall          ( ID_Stall),
        .Flush          (  )
    );
assign ID_branch_Flush = (ID_branch_select[0] && ID_condition_result) || ID_Jump;
wire [31:0] ID_PC_or_RS2;
wire ID_JALR;
assign ID_JALR = ID_branch_select[3];
assign ID_PC_or_RS2 = ID_JALR ?  ID_Comparator_RS1 : ID_PC;
assign ID_PC_plus_imm   = ID_PC_or_RS2 + ID_immediate;

assign ID_Jump = ID_branch_select[2] || ID_branch_select[3];
assign ID_PC_next = (ID_condition_result && ID_branch_select[0] || ID_Jump) ? ID_PC_plus_imm : ID_PC_plus_4;

reg [228:0] REG_ID_EX;///RAPORA YAZ 195:0den 196:0 ya çýkarýldý deðerler güncellendi 228:0 a çýkarýldý
//REG_ID_EX <= {ID_PC_plus_imm,ID_condition_result,ID_PC_plus_4, ID_PC, ID_rd_dout0, ID_rd_dout1, ID_Control_Word, ID_immediate};
//-------------------------------------------------

//------------------- Forward Unit ----------------
wire [1:0] Forward_A;
wire [1:0] Forward_B;
forward_unit forward_unit_i
(
        .MEM_RD             ( MEM_RD            ),
        .WB_RD              ( WB_RD             ),
        .EX_RS1             ( EX_RS1            ),
        .EX_RS2             ( EX_RS2            ),
        .MEM_load_enable    ( MEM_load_enable   ), 
        .WB_load_enable     ( WB_load_enable    ),
        .Forward_A          ( Forward_A         ), 
        .Forward_B          ( Forward_B         )
);
//-------------------------------------------------

//-------------------- EX STAGE -------------------

assign EX_Control_Word  = REG_ID_EX[67:32];
assign EX_rd_dout0      = REG_ID_EX[131:100];
assign EX_rd_dout1      = REG_ID_EX[99:68];
assign EX_immediate     = REG_ID_EX[31:0];
assign EX_PC            = REG_ID_EX[163:132];
assign EX_PC_plus_4     = REG_ID_EX[195:164];
assign EX_PC_plus_imm   = REG_ID_EX[228:197];

assign EX_F_Select      = EX_Control_Word[6:3]; 
assign EX_branch_select = EX_Control_Word[35:32];
assign EX_SLT_Select    = EX_Control_Word[31];  
assign EX_func3         = EX_Control_Word[14:12];
assign EX_Mux_B_Select  = EX_Control_Word[2];
assign EX_Mux_D_Select  = EX_Control_Word[25];
assign EX_Reg_RW        = EX_Control_Word[1];
assign EX_RS1           = EX_Control_Word[19:15];
assign EX_RS2           = EX_Control_Word[24:20];
assign EX_RD            = EX_Control_Word[11:7];

assign EX_Forward_B     = Forward_B[1] ? WB_Bus_D : (Forward_B[0] ? MEM_FU_Result : EX_rd_dout1);
assign EX_Bus_B         = EX_Mux_B_Select      ?   EX_immediate    : EX_Forward_B; 

assign EX_Forward_A     = Forward_A[1] ? WB_Bus_D : (Forward_A[0] ? MEM_FU_Result : EX_rd_dout0);
assign EX_Bus_A         = (EX_branch_select[1] | EX_branch_select[2]) ? EX_PC : EX_Forward_A;

assign EX_condition_result = REG_ID_EX[196];

FU  FUNC_UNIT       
(
            .F_Select           ( EX_F_Select           ),
            .A                  ( EX_Bus_A              ),
            .B                  ( EX_Bus_B              ),
            .SLT_Select         ( EX_SLT_Select         ),
            .Result             ( EX_FU_Result          ),
            .condition_result   ( EX_condition_result   ),
            .Z                  ( EX_Z                  ),
            .N                  ( EX_N                  ),
            .V                  ( EX_V                  ),
            .C                  ( EX_C                  )
);


reg [196:0] REG_EX_MEM;
//REG_EX_MEM <= {EX_PC_plus_4, EX_Forward_B, EX_PC, EX_PC_plus_imm, EX_FU_Result, EX_Control_Word, EX_condition_result};
//--------------------------------------------------


//----------------- MEM STAGE ----------------------
assign MEM_PC_plus_4        = REG_EX_MEM[196:165];
assign MEM_Forward_B        = REG_EX_MEM[164:133];
assign MEM_PC               = REG_EX_MEM[132:101];
assign MEM_PC_plus_imm      = REG_EX_MEM[100:69];
assign MEM_FU_Result        = REG_EX_MEM[68:37];
assign MEM_Control_Word     = REG_EX_MEM[36:1];
assign MEM_condition_result = REG_EX_MEM[0];
assign MEM_Mux_D_Select     = MEM_Control_Word[25];
assign MEM_branch_select    = MEM_Control_Word[35:32];
assign MEM_Write_Strobe     = MEM_Control_Word[27:26];
wire [2:0] MEM_func3;
wire [4:0] MEM_RS2;
assign MEM_RS2              = MEM_Control_Word[24:20];
assign MEM_func3            = MEM_Control_Word[14:12];
assign MEM_RD               = MEM_Control_Word[11:7];
assign MEM_load_enable      = MEM_Control_Word[1];
wire MEM_sign_select;
wire Forward_MEM;
assign MEM_sign_select      = MEM_func3[2];//MSB of func 3 is 1 when loads are unsigned
//signals to data memory
assign mem_address_out      = MEM_FU_Result;
assign mem_data_out         = Forward_MEM ? WB_Bus_din0 : MEM_Forward_B;
assign mem_we               = MEM_Control_Word[0];
assign mem_Write_Strobe_out = MEM_Write_Strobe;
load_unit l_unit_i
(
        .data_in        ( mem_data_in           ),
        .read_strobe    ( MEM_Write_Strobe      ),
        .byte_address   ( mem_address_out[1:0]  ),
        .sign_in        ( MEM_sign_select       ),
        .data_out       ( MEM_mem_data_in       )
);

mem_forward_unit m_fw_unt_i 
(
        .MEM_RS2        ( MEM_RS2       ),
        .WB_RD          ( WB_RD         ),
        .MEM_Mem_RW     ( mem_we        ),
        .Forward_MEM    ( Forward_MEM   )
);

assign MEM_Bus_D = MEM_Mux_D_Select ? MEM_mem_data_in : MEM_FU_Result;

reg [163:0] REG_MEM_WB;
//REG_MEM_WB <= {MEM_PC_plus_4, MEM_Bus_D, MEM_PC, MEM_PC_plus_imm, MEM_Control_Word};
//--------------------------------------------------

//------------------ WB STAGE-----------------------



assign WB_PC_plus_4     = REG_MEM_WB[163:132];
assign WB_Bus_D         = REG_MEM_WB[131:100];
assign WB_PC            = REG_MEM_WB[99:68];
assign WB_PC_plus_imm   = REG_MEM_WB[67:36];
assign WB_Control_Word  = REG_MEM_WB[35:0];

assign WB_Imm_Type      = WB_Control_Word[30:28]; 
assign WB_Mux_B_Select  = WB_Control_Word[2];
assign WB_Mux_D_Select  = WB_Control_Word[25];
assign WB_branch_select = WB_Control_Word[35:32];
assign WB_Reg_RW        = WB_Control_Word[1];
assign WB_RD            = WB_Control_Word[11:7];
assign WB_load_enable   = WB_Control_Word[1];

assign WB_Bus_din0 = WB_branch_select[1] ? WB_PC_plus_imm : 
                                           ((WB_branch_select[2] | WB_branch_select[3]) ? WB_PC_plus_4 : WB_Bus_D);

//--------------------------------------------------

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        PC_reg      <= 0;
        REG_IF_ID   <= 0; 
        REG_ID_EX   <= 0;
        REG_EX_MEM  <= 0;
        REG_MEM_WB  <= 0;
    end else begin
        if (STALL) begin
            PC_reg      <= PC_reg;
            REG_ID_EX   <= 0;
            REG_IF_ID   <= REG_IF_ID;
        end else if (ID_Stall) begin//stall for load use branch
            PC_reg      <= PC_reg;
            REG_IF_ID   <= REG_IF_ID;
            REG_ID_EX   <= 0;
        end else if (ID_branch_Flush) begin
            PC_reg      <= PC_next;
            REG_IF_ID   <= 0;
            REG_ID_EX   <= {ID_PC_plus_imm, ID_condition_result, ID_PC_plus_4, ID_PC, ID_rd_dout0, ID_rd_dout1, ID_Control_Word, ID_immediate};
        end else begin
            PC_reg      <= PC_next;
            REG_ID_EX   <= {ID_PC_plus_imm, ID_condition_result, ID_PC_plus_4, ID_PC, ID_rd_dout0, ID_rd_dout1, ID_Control_Word, ID_immediate}; 
            REG_IF_ID   <= {IF_PC_plus_4, IF_PC, Instruction};
        end 
        REG_EX_MEM  <= {EX_PC_plus_4, EX_Forward_B, EX_PC, EX_PC_plus_imm, EX_FU_Result, EX_Control_Word, EX_condition_result}; 
        REG_MEM_WB  <= {MEM_PC_plus_4, MEM_Bus_D, MEM_PC, MEM_PC_plus_imm, MEM_Control_Word};
    end
end
   
endmodule
