module shifter_tb();
    reg [15:0] in_tb;
    reg [1:0] shift_tb;
    wire [15:0] sout_tb;

    shifter DUT(in_tb, shift_tb, sout_tb);

    initial begin
        in_tb = 16'b1011_0001_1011_1101;
        shift_tb = 2'b00;
        #10;
        in_tb = 16'b1011_0001_1011_1101;
        shift_tb = 2'b01;
        #10;
        in_tb = 16'b1011_0001_1011_1101;
        shift_tb = 2'b10;
        #10;
        in_tb = 16'b1011_0001_1011_1101;
        shift_tb = 2'b11;
        #10;
    end

endmodule