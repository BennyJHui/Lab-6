module regfile(data_in,writenum,write,readnum,clk,data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output [15:0] data_out;

    reg [7:0] one_hot_wr, one_hot_rd;
    reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    wire loadR0, loadR1, loadR2, loadR3, loadR4, loadR5, loadR6, loadR7;

    always_comb begin
        case(writenum)
            3'b000:  one_hot_wr = 8'b00000001;
            3'b001:  one_hot_wr = 8'b00000010;
            3'b010:  one_hot_wr = 8'b00000100;
            3'b011:  one_hot_wr = 8'b00001000;
            3'b100:  one_hot_wr = 8'b00010000;
            3'b101:  one_hot_wr = 8'b00100000;
            3'b110:  one_hot_wr = 8'b01000000;
            3'b111:  one_hot_wr = 8'b10000000;
        endcase
    end

    assign loadR0 = write & one_hot_wr[0];
    assign loadR1 = write & one_hot_wr[1];
    assign loadR2 = write & one_hot_wr[2];
    assign loadR3 = write & one_hot_wr[3];
    assign loadR4 = write & one_hot_wr[4];
    assign loadR5 = write & one_hot_wr[5];
    assign loadR6 = write & one_hot_wr[6];
    assign loadR7 = write & one_hot_wr[7];

    // Can do without else because it keeps previous value 
    // so no worry about latches, only need else for combinational logic
    always_ff @(posedge clk) begin
        if (loadR0) R0 <= data_in;
        if (loadR1) R1 <= data_in;
        if (loadR2) R2 <= data_in;
        if (loadR3) R3 <= data_in;
        if (loadR4) R4 <= data_in;
        if (loadR5) R5 <= data_in;
        if (loadR6) R6 <= data_in;
        if (loadR7) R7 <= data_in;
    end

    always_comb begin
        case(readnum)
            3'b000:  one_hot_rd = 8'b00000001;
            3'b001:  one_hot_rd = 8'b00000010;
            3'b010:  one_hot_rd = 8'b00000100;
            3'b011:  one_hot_rd = 8'b00001000;
            3'b100:  one_hot_rd = 8'b00010000;
            3'b101:  one_hot_rd = 8'b00100000;
            3'b110:  one_hot_rd = 8'b01000000;
            3'b111:  one_hot_rd = 8'b10000000;
        endcase
    end

    assign data_out = 
        one_hot_rd[0] ? R0 :
        one_hot_rd[1] ? R1 :
        one_hot_rd[2] ? R2 :
        one_hot_rd[3] ? R3 :
        one_hot_rd[4] ? R4 :
        one_hot_rd[5] ? R5 :
        one_hot_rd[6] ? R6 :
        one_hot_rd[7] ? R7 :
        16'b0;
endmodule