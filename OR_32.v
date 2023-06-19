module OR_32(
    input       [31:0]      A,
    input       [31:0]      B,
    output      [31:0]      AorB
    );  
    assign AorB    =       A | B;   
endmodule
