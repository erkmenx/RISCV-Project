`timescale 1ns / 1ps
module PC(
    input           clk,
    input           rst,
    input   [31:0]  imm,
    input           condition_result,
    input   [31:0]  rs1_in,
    input   [3:0]   branch_select,
    output  [31:0]  PC_out,
    output  [31:0]  PC_to_REG
    );

wire JALR, JAL, AUIPC, BRANCH;
assign {JALR, JAL, AUIPC, BRANCH} = branch_select;
reg [31:0] PC_reg;
wire [31:0] PC_or_RS1 = JALR ? rs1_in : PC_reg;
wire [31:0] PC_plus_IMM = PC_or_RS1 + imm;
wire [31:0] PC_plus_4 = PC_reg + 4;
wire [31:0] wire1 = JAL ? PC_plus_IMM : PC_plus_4;
wire [31:0] PC_next = ((condition_result & BRANCH) | JALR) ? PC_plus_IMM : wire1; 

assign PC_to_REG = PC_plus_4;
assign PC_out = PC_reg;

always @(posedge clk or negedge rst)
    if (rst) begin
        PC_reg <= PC_next;
    end else begin // reset condition
        PC_reg <= 32'd0;
    end   
endmodule
