module Adder_Top(

    input   [31:0]          A,
    input   [31:0]          B,
    input                   cin,
    output  [31:0]          sum,
    output                  V,
    output                  cout
    
    );
    
wire [31:0] sum_0,sum_1,B_n;
wire cout_0,cprev_0,cout_1,cprev_1;
    
assign B_n = B ^ {32{cin}};

CSLA        CSLA_1          (       .A          ( A             ),
                                    .B          ( B_n           ),
                                    .sum_0      ( sum_0         ),
                                    .cout_0     ( cout_0        ),
                                    .cprev_0    ( cprev_0       ),
                                    .sum_1      ( sum_1         ),    
                                    .cout_1     ( cout_1        ),
                                    .cprev_1    ( cprev_1       )      );
                                           
                                    
CSLA_MUX    Selection       (       .cin        ( cin           ),
                                    .sum_0      ( sum_0         ),
                                    .cout_0     ( cout_0        ),
                                    .cprev_0    ( cprev_0       ),
                                    .sum_1      ( sum_1         ),    
                                    .cout_1     ( cout_1        ),
                                    .cprev_1    ( cprev_1       ),
                                    .C          ( cout          ),
                                    .V          ( V             ),
                                    .result     ( sum           )       );
endmodule
