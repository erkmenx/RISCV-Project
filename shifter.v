module shifter(
    input [31:0] A,
    input [1:0] H_SELECT,
    input [4:0] shift_amount,
    output reg [31:0] H
    );
//h select[0] yön belirler 0 = left, 1 = right
//h_select[1] 0 = logical, 1 = arithmetic    
    
always @(*) begin
    
    case (H_SELECT)
        4'd0://logical left
            begin
                H = A << shift_amount;
            end
        4'd1://logical right
            begin
                H = A >> shift_amount;
            end
        4'd2://arithmetic left
            begin
                H = A;//aritmetic left is not on the instruction set
            end
        4'd3://arithmetic right
            begin
                H = $signed(A) >>> shift_amount;
            end
    endcase
    
end
    
    
    
endmodule
