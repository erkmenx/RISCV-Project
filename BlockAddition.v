module BlockAddition(
    input [7:0] A,
    input [7:0] B,
    input cin,
    output cout,
    output cprev,
    output [7:0] sum
    );   
genvar i;
wire [7:0] cout_inside;
assign cout = cout_inside[7];
assign cprev = cout_inside[6];
generate
    for (i=0;i<8;i=i+1)
        begin
            if(i==0)
                Full_Adder u0 (.x(A[i]),.y(B[i]),.cin(cin),.sum(sum[i]),.cout(cout_inside[i]));
            else
                Full_Adder u1 (.x(A[i]),.y(B[i]),.cin(cout_inside[i-1]),.sum(sum[i]),.cout(cout_inside[i]));
    end
endgenerate
endmodule
