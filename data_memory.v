module data_memory #
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
    input  [1:0]                    write_strobe,
    output [WIDTH-1:0]              rd_dout0
);
integer i;
//00 byte
//01 half word
//10 word
localparam STR_B  = 2'b00;
localparam STR_HW = 2'b01;
localparam STR_W  = 2'b10;




reg [7:0] memory_register [0:127][3:0];
reg [31:0] memory_register_temp[0:127];
initial begin
repeat (3) @(posedge clk);
$readmemh("C:/Users/Oguzhan/Desktop/hw8_part6_jump/hw8_part2.srcs/sources_1/new/data_memory.mem",memory_register_temp);
    for (i = 0; i < 128; i = i + 1) begin
        {memory_register[i][3], memory_register[i][2], memory_register[i][1], memory_register[i][0]} =  memory_register_temp[i];        
    end
end

assign rd_dout0 = {memory_register[rd_addr0>>2][3],
                   memory_register[rd_addr0>>2][2],
                   memory_register[rd_addr0>>2][1],
                   memory_register[rd_addr0>>2][0]};

wire [31:0] simulation_memory[0:127];
genvar k;
generate
    for (k = 0; k < 128; k = k + 1) begin
        assign simulation_memory[k] = {memory_register[k][3], memory_register[k][2], memory_register[k][1], memory_register[k][0]};
    end
endgenerate

/*
assign rd_dout0 = {memory_register[rd_addr0>>2][0],
                  memory_register[rd_addr0>>2][1],
                  memory_register[rd_addr0>>2][2],
                  memory_register[rd_addr0>>2][3]};
*/
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            {memory_register[i][0],memory_register[i][1],memory_register[i][2],memory_register[i][3]} = 32'd0;
        end
    end else begin
        if (we0) begin
            case (write_strobe) 
                STR_W: begin //can only write word when addres % 4 = 0
                    if(!(|wr_addr0[1:0])) begin
                       memory_register[wr_addr0>>2][wr_addr0[1:0]]      <= wr_din0[7:0]; 
                       memory_register[wr_addr0>>2][wr_addr0[1:0]+1]    <= wr_din0[15:8];
                       memory_register[wr_addr0>>2][wr_addr0[1:0]+2]    <= wr_din0[23:16];
                       memory_register[wr_addr0>>2][wr_addr0[1:0]+3]    <= wr_din0[31:24]; 
                    end 
                end
                STR_HW: begin //can only write half word when, address % 4 = 0, 1, 2
                    if (!(&wr_addr0[1:0])) begin
                        memory_register[wr_addr0>>2][wr_addr0[1:0]]     <= wr_din0[7:0]; 
                        memory_register[wr_addr0>>2][wr_addr0[1:0]+1]   <= wr_din0[15:8]; 
                    end   
                end
                STR_B: begin //can write byte to any address
                    memory_register[wr_addr0>>2][wr_addr0[1:0]] <= wr_din0[7:0];   
                end
                default: begin
                    memory_register[wr_addr0>>2][wr_addr0[1:0]+3] <= memory_register[wr_addr0>>2][wr_addr0[1:0]+3]; 
                    memory_register[wr_addr0>>2][wr_addr0[1:0]+2] <= memory_register[wr_addr0>>2][wr_addr0[1:0]+2];
                    memory_register[wr_addr0>>2][wr_addr0[1:0]+1] <= memory_register[wr_addr0>>2][wr_addr0[1:0]+1];
                    memory_register[wr_addr0>>2][wr_addr0[1:0]]   <= memory_register[wr_addr0>>2][wr_addr0[1:0]];
                end
            endcase
        end
    end   
end
endmodule
