module regfile_tb();

    reg [15:0] data_in_tb;
    reg [2:0] writenum_tb, readnum_tb;
    reg write_tb, clk_tb;
    wire [15:0] data_out_tb;

    regfile DUT(data_in_tb, writenum_tb, write_tb, readnum_tb, clk_tb, data_out_tb);

    initial begin
        clk_tb = 0;
        #5;
        forever begin
            clk_tb = ~clk_tb;
            #5;
        end
    end

    initial begin
        // Write "ABCD" register 3
        data_in_tb = 16'hABCD;
        writenum_tb = 3'b011;
        write_tb = 1;
        readnum_tb = 3'b011;
        #10;
        // Write "AAAA" register 2
        data_in_tb = 16'hAAAA;
        writenum_tb = 3'b010;
        write_tb = 1;
        readnum_tb = 3'b010;
        #10;
        // Write "BBBB" register 1
        data_in_tb = 16'hBBBB;
        writenum_tb = 3'b001;
        write_tb = 1;
        readnum_tb = 3'b001;
        #10;
        // Write nothing register 0
        data_in_tb = 16'hBBBB;
        writenum_tb = 3'b000;
        write_tb = 0;
        readnum_tb = 3'b011;
        #10;
    end

endmodule