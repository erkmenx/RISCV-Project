`timescale 1ns / 1ps
module TOP_tb;

reg           clk = 0;
reg           rst = 0;
wire  [31:0]  Instruction;
wire  [31:0]  mem_data_in;
wire  [31:0]  mem_data_out;
wire  [31:0]  mem_address_out;
wire  [31:0]  PC;
wire          mem_we;
wire  [1:0]   mem_Write_Strobe;
TOP TOP_i
(
    .clk                    ( clk               ),
    .rst                    ( rst               ),
    .Instruction            ( Instruction       ),
    .mem_data_in            ( mem_data_in       ),
    .mem_data_out           ( mem_data_out      ),
    .mem_address_out        ( mem_address_out   ),
    .PC                     ( PC                ),
    .mem_we                 ( mem_we            ),
    .mem_Write_Strobe_out   ( mem_Write_Strobe  )
);

data_memory    DMEM      
(
    .clk            ( clk                   ),
    .rst            ( rst                   ),
    .rd_addr0       ( mem_address_out       ),
    .wr_addr0       ( mem_address_out       ),
    .wr_din0        ( mem_data_out          ),
    .we0            ( mem_we                ),
    .write_strobe   ( mem_Write_Strobe      ),
    .rd_dout0       ( mem_data_in           )
);

instruction_memory #
(
.WIDTH(32),
.DEPTH(128)
) ins_mem_i
(
    .clk        ( clk           ),
    .rst        ( rst           ),
    .rd_addr0   ( PC            ),
    .wr_addr0   (               ),
    .wr_din0    (               ),
    .we0        ( 1'b0          ),
    .rd_dout0   ( Instruction   )

);

always begin
    #10;
    clk = ~clk;
end

initial begin
    rst = 0;
    #25;
    rst = 1;
end

endmodule
