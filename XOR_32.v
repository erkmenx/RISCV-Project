module XOR_32(
    input       [31:0]      A,
    input       [31:0]      B,
    output      [31:0]      AxorB

    );
    assign AxorB    =       A ^ B; 
endmodule
