`timescale 1ns / 1ps
module Decoder(
    input  [31:0] Instruction,
    output [35:0] Control_Word
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

//I-Type
localparam ADDI_FUNC3  = 3'b000;
localparam SLTI_FUNC3  = 3'b010;
localparam SLTIU_FUNC3 = 3'b011;
localparam XORI_FUNC3  = 3'b100;
localparam ORI_FUNC3   = 3'b110;
localparam ANDI_FUNC3  = 3'b111;
localparam SLLI_FUNC3 = 3'b001;
localparam SRLI_FUNC3 = 3'b101;
localparam SRAI_FUNC3 = 3'b101;

//R-Type
localparam ADD_FUNC3    = 3'b000;
localparam SUB_FUNC3    = 3'b000;
localparam SLL_FUNC3    = 3'b001;
localparam SLT_FUNC3    = 3'b010;
localparam SLTU_FUNC3   = 3'b011;
localparam XOR_FUNC3    = 3'b100;
localparam SRL_FUNC3    = 3'b101;
localparam SRA_FUNC3    = 3'b101;
localparam OR_FUNC3     = 3'b110;
localparam AND_FUNC3    = 3'b111;

localparam IMM_R_TYPE   = 3'b000;
localparam IMM_I_TYPE   = 3'b001;
localparam IMM_S_TYPE   = 3'b010;
localparam IMM_B_TYPE   = 3'b011;
localparam IMM_U_TYPE   = 3'b100;
localparam IMM_J_TYPE   = 3'b101;

localparam R_TYPE_OPCODE = 7'b0110011;
localparam I_TYPE_OPCODE = 7'b0010011;
localparam STORE_OPCODE  = 7'b0100011;
localparam LOAD_OPCODE   = 7'b0000011;
localparam B_TYPE_OPCODE = 7'b1100011;
localparam JALR_OPCODE   = 7'b1100111;
localparam JAL_OPCODE    = 7'b1101111;
localparam AUIPC_OPCODE  = 7'b0010111;
localparam LUI_OPCODE    = 7'b0110111;

reg     [3:0]   branch_select;
reg             SLT_Select;
reg     [2:0]   Imm_Type;
reg     [1:0]   Write_Strobe;
reg             Mux_D_Select;
wire    [4:0]   RS2;
wire    [4:0]   RS1;
wire    [2:0]   func3;
wire    [4:0]   RD;
reg     [3:0]   F_Select;
reg             Mux_B_Select;
reg             Reg_RW;
reg             Mem_RW;
reg             LUI;
wire    [6:0]   Instruction_opcode = Instruction[6:0];
wire    [2:0]   Instruction_func3  = Instruction[14:12];

assign RS1      = LUI ? 5'd0 : Instruction[19:15];
assign RS2      = Instruction[24:20];
assign RD       = Instruction[11:7];
assign func3    = Instruction[14:12];

assign Control_Word = {branch_select, SLT_Select, Imm_Type, Write_Strobe, Mux_D_Select, RS2, RS1, func3, 
                       RD, F_Select, Mux_B_Select, Reg_RW, Mem_RW};
//BRANCH SELECT AYARLA

always @(*) begin   
    SLT_Select      = 1'b0;  
    LUI             = 1'b0;  
    branch_select   = 4'd0;
    Write_Strobe    = 2'b00; 
    Imm_Type        = IMM_I_TYPE;
    Mux_D_Select    = 1'b0;
    Mux_B_Select    = 1'b0;
    Reg_RW          = 1'b1;
    Mem_RW          = 1'b0;   
    F_Select        = 4'b0000;            
    case (Instruction_opcode)
        R_TYPE_OPCODE: begin
            Imm_Type        = IMM_R_TYPE;
            case (Instruction_func3)
                ADD_FUNC3, SUB_FUNC3: F_Select = {3'b000, Instruction[30]};
                SLL_FUNC3: F_Select = 4'b1000;
                SLT_FUNC3, SLTU_FUNC3: begin F_Select = 4'b0001; SLT_Select = 1'b1; end
                XOR_FUNC3: F_Select = 4'b0010;
                SRL_FUNC3: F_Select = 4'b1010;
                SRA_FUNC3: F_Select = 4'b1100;
                OR_FUNC3:  F_Select = 4'b0100;
                AND_FUNC3: F_Select = 4'b0110;
                default: F_Select = 4'b0000;
            endcase        
        end
        I_TYPE_OPCODE: begin
            Imm_Type        = IMM_I_TYPE;
            Mux_B_Select    = 1'b1;
            case (Instruction_func3)
                ADDI_FUNC3: F_Select = 4'b0000;
                SLTI_FUNC3, SLTIU_FUNC3: begin F_Select = 4'b0001; SLT_Select = 1'b1; end
                XORI_FUNC3: F_Select = 4'b0010;
                ORI_FUNC3:  F_Select = 4'b0100;
                ANDI_FUNC3: F_Select = 4'b0110;
                SLLI_FUNC3: F_Select = 4'b1000;
                SRLI_FUNC3: F_Select = 4'b1010;
                SRAI_FUNC3: F_Select = 4'b1100;
                default: F_Select = 4'b0000;
            endcase
        end
        STORE_OPCODE: begin
            Imm_Type        = IMM_S_TYPE;
            Mux_B_Select    = 1'b1;
            Reg_RW          = 1'b0;
            Mem_RW          = 1'b1;
            case (Instruction_func3)
                SB_FUNC3:   Write_Strobe = 2'b00;
                SH_FUNC3:   Write_Strobe = 2'b01;
                SW_FUNC3:   Write_Strobe = 2'b10;
                default:    Write_Strobe = 2'b10;
            endcase   
        end
        LOAD_OPCODE: begin
            Imm_Type        = IMM_I_TYPE;
            Mux_D_Select    = 1'b1;
            Mux_B_Select    = 1'b1;
            case (Instruction_func3)
                LB_FUNC3, LBU_FUNC3:   Write_Strobe = 2'b00;
                LH_FUNC3, LHU_FUNC3:   Write_Strobe = 2'b01;
                LW_FUNC3:              Write_Strobe = 2'b10;
                default:               Write_Strobe = 2'b01;
            endcase
        end
        B_TYPE_OPCODE: begin
            Imm_Type        = IMM_B_TYPE;
            Reg_RW          = 1'b0;
            F_Select        = 4'b0001;
            branch_select   = 4'b0001;
        end
        JALR_OPCODE: begin //
            Imm_Type        = IMM_I_TYPE;
            branch_select   = 4'b1000;
        end
        JAL_OPCODE: begin //
            Imm_Type        = IMM_J_TYPE;
            branch_select   = 4'b0100;
            Mux_B_Select    = 1'b1;
        end
        AUIPC_OPCODE: begin //
            Imm_Type        = IMM_U_TYPE;
            branch_select   = 4'b0010;
        end
        LUI_OPCODE: begin //
            Imm_Type        = IMM_U_TYPE;
            Mux_B_Select    = 1'b1;
            LUI             = 1'b1;
        end
        default: begin//eklemeleri yap
            SLT_Select      = 1'b0;  
            LUI             = 1'b0;  
            branch_select   = 4'd0;
            Write_Strobe    = 2'b00; 
            Imm_Type        = IMM_I_TYPE;
            Mux_D_Select    = 1'b0;
            Mux_B_Select    = 1'b0;
            Reg_RW          = 1'b1;
            Mem_RW          = 1'b0;   
            F_Select        = 4'b0000; 
        end
    endcase
end 
endmodule
