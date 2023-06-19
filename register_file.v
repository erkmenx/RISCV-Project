`timescale 1ns / 1ps


module register_file#(parameter WIDTH=32, parameter DEPTH=32)(

input                               clk,
input                               rst,
input   [$clog2(DEPTH)-1:0]         rd_addr0,
input   [$clog2(DEPTH)-1:0]         rd_addr1,
input   [$clog2(DEPTH)-1:0]         wr_addr0,
input   [WIDTH-1:0]                 wr_din0,
input                               we_0,
output  [WIDTH-1:0]                 rd_dout0,
output  [WIDTH-1:0]                 rd_dout1

);
 
(* dont_touch = "true" *) reg [WIDTH-1:0] Mem [0:DEPTH-1];

assign rd_dout0 = (rd_addr0 == wr_addr0 & rd_addr0 != 5'd0 & we_0) ? wr_din0 : Mem[rd_addr0];
assign rd_dout1 = (rd_addr1 == wr_addr0 & rd_addr1 != 5'd0 & we_0) ? wr_din0 : Mem[rd_addr1];
integer i;

always @(posedge clk or negedge rst)
    begin
        if(!rst)
            begin
                for(i=0;i<DEPTH;i=i+1)  Mem[i] <= 'b0;
            end
        else
            begin
                if(we_0 & (wr_addr0 != 'd0))
                    begin
                            Mem[wr_addr0]      <=      wr_din0;
                    end
            end
    end
endmodule
