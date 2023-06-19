module load_unit(
    input       [31:0] data_in,
    input       [1:0]  read_strobe,
    input       [1:0]  byte_address,
    input              sign_in, //1 unsigned, 0 signed
    output reg  [31:0] data_out
    );

//00 byte 01 hw 10 word
wire [7:0] byte [0:3];

assign {byte[3], byte[2], byte[1], byte[0]} = data_in;

always @(*) begin
    case(read_strobe)
        2'b00: begin //read byte
            if(sign_in)
                data_out = {24'd0, byte[byte_address]};
            else
                data_out = {{24{byte[byte_address][7]}}, byte[byte_address]};
        end
        2'b01: begin //read hw
            if(byte_address != 2'b11)
                if (sign_in)
                    data_out = {16'd0, byte[byte_address+1], byte[byte_address]};
                else
                    data_out = {{16{byte[byte_address+1][7]}}, byte[byte_address+1], byte[byte_address]};
            else
                data_out = 32'd0;
        end
        2'b10: begin //read word
            if(byte_address == 2'b00)
                data_out = data_in;
            else
                data_out = 32'd0;      
        end
        2'b11: begin
            data_out = 32'd0;
        end
    endcase
end
    
endmodule
