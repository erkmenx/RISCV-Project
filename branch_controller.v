module branch_controller(
    input       [2:0]   condition,
    input               Z,
    input               N,
    input               V,
    input               C,
    
    output  reg         condition_result
    );
    
localparam  BEQ     =           3'b000;
localparam  BNE     =           3'b001;
localparam  BLT     =           3'b100;
localparam  BGE     =           3'b101;
localparam  BLTU    =           3'b110;
localparam  BGEU    =           3'b111;
localparam  SLT     =           3'b010;
localparam  SLTU    =           3'b011;

always @(*) begin
    condition_result = 1'b0;
    case( condition ) 
        BEQ:        condition_result    =       Z;
        BNE:        condition_result    =       ~Z;
        BLT, SLT:   condition_result    =       N ^ V;
        BGE:        condition_result    =       ~( N ^ V );      
        BLTU, SLTU: condition_result    =       ~C;
        BGEU:       condition_result    =       C;       
    endcase
end    
endmodule
//assign PC_out = condition_result ? PC_in + imm : PC_in + 4;