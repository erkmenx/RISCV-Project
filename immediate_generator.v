module immediate_generator(
    input       [31:0]  instruction,
    input       [2:0]   imm_type,
    output  reg [31:0]  immediate
    );

localparam IMM_I_TYPE   = 3'b001;
localparam IMM_S_TYPE   = 3'b010;
localparam IMM_B_TYPE   = 3'b011;
localparam IMM_U_TYPE   = 3'b100;
localparam IMM_J_TYPE   = 3'b101;

always @(*) begin
    case (imm_type) 
        IMM_I_TYPE: immediate   = {{21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20]};
        IMM_S_TYPE: immediate   = {{21{instruction[31]}}, instruction[30:25], instruction[11:8], instruction[7]};
        IMM_B_TYPE: immediate   = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        IMM_U_TYPE: immediate   = {instruction[31], instruction[30:20], instruction[19:12], 12'd0};
        IMM_J_TYPE: immediate   = {instruction[31], instruction[19:12], instruction[20], instruction[30:25], instruction[24:21], 1'b0};
    endcase
end
endmodule
