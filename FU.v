module FU(
    input       [3:0]       F_Select,
    input       [31:0]      A,
    input       [31:0]      B,
    input                   SLT_Select,
    input                   condition_result,
    output      [31:0]      Result,
    
    output                  Z,
    output                  N,
    output                  V,
    output                  C
    );
    
wire [31:0] ALU_Result, Shift_Result, SLT_Result;

wire [31:0] ALU_Shifter_Result;

    
// Zero Detector
assign Z = ~(|ALU_Result);
//
assign N = ALU_Result[31];
    
ALU     ALU_I     (     .G_Select   ( F_Select[2:0] ),
                        .A          ( A             ),
                        .B          ( B             ),
                        .V          ( V             ),
                        .C          ( C             ),
                        .Result     ( ALU_Result    ));
                        
                        
shifter SHIFTER_I   (     .A            ( A             ),
                          .H_SELECT     ( F_Select[2:1] ),
                          .shift_amount ( B[4:0]        ),
                          .H            ( Shift_Result  ) );
                          
                          
//comparison_unit     COMPARISON_I (  .condition          ( condition_select  ),
//                                    .C                  ( C                 ),
//                                    .V                  ( V                 ),
//                                    .Z                  ( Z                 ),
//                                    .N                  ( N                 ),
//                                    .condition_result   ( condition_result  ));                      

assign ALU_Shifter_Result   = F_Select[3] ? Shift_Result : ALU_Result ;

assign SLT_Result           = {31'd0, condition_result};

assign Result               = SLT_Select ? SLT_Result : ALU_Shifter_Result;


endmodule
