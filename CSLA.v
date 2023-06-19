module CSLA(
    input   [31:0]          A,
    input   [31:0]          B,
    
    output  [31:0]          sum_0,
    output                  cout_0,
    output                  cprev_0,
    
    output  [31:0]          sum_1,    
    output                  cout_1,
    output                  cprev_1 
    );

BlockAddition   FIRST8_0    ( .A          ( A[7:0]        ),
                              .B          ( B[7:0]        ),
                              .cin        ( 0             ),
                              .cout       ( cout1_0       ),
                              .cprev      (               ),
                              .sum        ( sum_0[7:0]    )   );
                                
BlockAddition   FIRST8_1    ( .A          ( A[7:0]        ),
                              .B          ( B[7:0]        ),
                              .cin        ( 1             ),
                              .cout       ( cout1_1       ),
                              .cprev      (               ),
                              .sum        ( sum_1[7:0]    )   );
                                

BlockAddition   SECOND8_0    ( .A          ( A[15:8]       ),
                               .B          ( B[15:8]       ),
                               .cin        ( cout1_0       ),
                               .cout       ( cout2_0       ),
                               .cprev      (               ),
                               .sum        ( sum_0[15:8]   )   );
                                
BlockAddition   SECOND8_1    ( .A          ( A[15:8]       ),
                               .B          ( B[15:8]       ),
                               .cin        ( cout1_1       ),
                               .cout       ( cout2_1       ),
                               .cprev      (               ),
                               .sum        ( sum_1[15:8]   )   );
                                
BlockAddition   THIRD8_0    ( .A          ( A[23:16]      ),
                              .B          ( B[23:16]      ),
                              .cin        ( cout2_0       ),
                              .cout       ( cout3_0       ),
                              .cprev      (               ),
                              .sum        ( sum_0[23:16]  )  );
                                
BlockAddition   THIRD8_1    ( .A          ( A[23:16]      ),
                              .B          ( B[23:16]      ),
                              .cin        ( cout2_1       ),
                              .cout       ( cout3_1       ),
                              .cprev      (               ),
                              .sum        ( sum_1[23:16]  )   );
                                
BlockAddition   FOURTH8_0    ( .A          ( A[31:24]      ),
                               .B          ( B[31:24]      ),
                               .cin        ( cout3_0       ),
                               .cout       ( cout_0        ),
                               .cprev      ( cprev_0       ),
                               .sum        ( sum_0[31:24]  )   );
                                
BlockAddition   FOURTH8_1    ( .A          ( A[31:24]      ),
                               .B          ( B[31:24]      ),
                               .cin        ( cout3_1       ),
                               .cout       ( cout_1        ),
                               .cprev      ( cprev_1       ),
                               .sum        ( sum_1[31:24]  )   );

endmodule
