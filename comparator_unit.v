module comparator_unit(
    input [31:0] RS1,
    input [31:0] RS2,
    input        branch,
    input [2:0]  condition,
    output reg   condition_result
    );
    
localparam  BEQ     =           3'b000;
localparam  BNE     =           3'b001;
localparam  BLT     =           3'b100;
localparam  BGE     =           3'b101;
localparam  BLTU    =           3'b110;
localparam  BGEU    =           3'b111;
localparam  SLT     =           3'b010;
localparam  SLTU    =           3'b011;

wire EQ  = (RS1 == RS2);
wire NEQ = (RS1 != RS2);
wire LT  = $signed(RS1) < $signed(RS2);
wire LTU = $unsigned(RS1) < $unsigned(RS2);
wire GE  = $signed(RS1) >= $signed(RS2);
wire GEU = $unsigned(RS1) >= $unsigned(RS2);
always @(*) begin
    condition_result = 1'b0;
    case( condition ) 
        BEQ:        condition_result    = EQ;
        BNE:        condition_result    = NEQ;
        BLT, SLT:   condition_result    = LT;
        BGE:        condition_result    = GE;
        BLTU, SLTU: condition_result    = LTU;
        BGEU:       condition_result    = GEU;
    endcase
end    
endmodule
    

