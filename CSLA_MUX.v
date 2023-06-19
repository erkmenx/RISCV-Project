module CSLA_MUX(   
    input cin,
    
    input  [31:0]          sum_0,
    input                  cout_0,
    input                  cprev_0,
    
    input  [31:0]          sum_1,    
    input                  cout_1,
    input                  cprev_1,
    
    output reg              C,
    output reg              V,
    output reg [31:0]       result
    );
   
always  @(*) begin
case(cin)
        0: begin
                result  =   sum_0;
                C       =   cout_0;
                V       =   cout_0 ^ cprev_0;
            end    
        1: begin
                result  =   sum_1;
                C       =   cout_1;
                V       =   cout_1  ^ cprev_1;
            end
endcase
end   
endmodule
