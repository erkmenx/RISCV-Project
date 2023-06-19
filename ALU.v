`timescale 1ns / 1ps

module ALU(

    input       [2:0]       G_Select,
    input       [31:0]      A,
    input       [31:0]      B,
    
    
    output                  V,
    output                  C,
    output      [31:0]      Result

    );
    


wire [31:0] sumout;
wire [31:0] AxorB;
wire [31:0] AorB;
wire [31:0] AandB;

wire addsub_cout;

// Add - Sub Module by using CSLA
Adder_Top             ADDSUB    (   .A              ( A                 ),
                                    .B              ( B                 ),
                                    .cin            ( G_Select[0]       ),          // G_select[0] = cin
                                    .sum            ( sumout            ),
                                    .cout           ( C                 ),
                                    .V              ( V                 ));
                                    


//  XOR_32
XOR_32          XOR         (   .A      ( A         ),
                                .B      ( B         ),
                                .AxorB  ( AxorB     ));



//  AND_32
AND_32          AND         (   .A      ( A         ),
                                .B      ( B         ),
                                .AandB  ( AandB     ));


//  OR_32
OR_32          OR           (   .A      ( A         ),
                                .B      ( B         ),
                                .AorB   ( AorB     ));




// RESULT_MUX

Result_MUX      RESLT       (   .G_Select   ( G_Select[2:1]     ),
                                .sumout     ( sumout            ),
                                .AxorB      ( AxorB             ),
                                .AorB       ( AorB              ),
                                .AandB      ( AandB             ),
                                .result     ( Result            ) 
                                );

endmodule
