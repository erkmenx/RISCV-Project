`timescale 1ns / 1ps

module Result_MUX(

    input       [1:0]       G_Select,
    input       [31:0]      sumout,
    input       [31:0]      AxorB,
    input       [31:0]      AorB,
    input       [31:0]      AandB,
    output reg  [31:0]      result
    

    );


always @(*) begin


case ( G_Select )
    
    
    
    2'b00: begin
                result  =   sumout;
            end
            
    
    2'b01: begin
                result  =   AxorB;
            end
    
    
    2'b10: begin
                result  =   AorB;
            end
    
    2'b11:  begin
                result  =   AandB;
            end
    
    
    endcase

end

        
endmodule
