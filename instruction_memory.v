module instruction_memory #
(
parameter WIDTH = 32,
parameter DEPTH = 128
)
(
    input                           clk,
    input                           rst,
    input  [$clog2(DEPTH*4)-1:0]    rd_addr0,
    input  [$clog2(DEPTH*4)-1:0]    wr_addr0,
    input  [WIDTH-1:0]              wr_din0,
    input                           we0,
    output [WIDTH-1:0]              rd_dout0

);
integer i;

reg [WIDTH-1:0] memory_register [0:DEPTH-1];

initial begin
#25;
$readmemb("C:/Users/Oguzhan/Desktop/hw8_part6_branch/hw8_part2.srcs/sources_1/imports/RISCV-CSR/test_instructions.txt",memory_register);
end

assign rd_dout0 = memory_register[rd_addr0>>2];

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for(i = 0; i < DEPTH; i = i + 1) begin
            memory_register[i] <= 'd0;
        end    
    end else begin
        if (we0) begin
            memory_register[wr_addr0>>2] <= wr_din0;
        end
    end
end

endmodule
