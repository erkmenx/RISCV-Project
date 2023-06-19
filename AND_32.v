module AND_32(
    input       [31:0]      A,
    input       [31:0]      B,
    output      [31:0]      AandB

    );  
    assign AandB    =       A & B; 
endmodule
