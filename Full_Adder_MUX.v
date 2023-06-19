module Full_Adder(
    input x,
    input y,
    input cin,
    output sum,
    output cout
    );
    
wire AxorB;    
assign notAxorB = !(x^y);
assign sum = !(notAxorB ^ cin);
assign cout = notAxorB ? x:cin;

endmodule
