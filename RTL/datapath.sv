module datapath(
    input clk, write, asel, bsel, loada, loadb, loadc, loads,
    input [1:0] shift, ALUop, vsel,
    input [2:0] readnum, writenum, 
    input [7:0] PC,
    input [15:0] mdata, sximm8, sximm5,
    output reg Z_out, N_out, V_out, 
    output reg [15:0] datapath_out
);

    reg [15:0] data_A, data_B, data_C;
    wire Z, N, V;
    wire [15:0] Ain, Bin, shifter_out, ALU_out, data_in, data_out;

    regfile REGFILE(
        .data_in(data_in), 
        .writenum(writenum), 
        .write(write), 
        .readnum(readnum),
        .clk(clk),
        .data_out(data_out)
    );

    shifter U1(
        .in(data_B),
        .shift(shift),
        .sout(shifter_out)
    );

    ALU U2(
        .Ain(Ain),
        .Bin(Bin),
        .ALUop(ALUop),
        .out(ALU_out),
        .Z(Z),
        .N(N),
        .V(V)
    );

    always_ff @(posedge clk) begin
        if (loada) data_A <= data_out;
        if (loadb) data_B <= data_out;
        if (loadc) {data_C, datapath_out} <= {ALU_out, ALU_out};
        if (loads) Z_out <= Z;
        if (loads) N_out <= N;
        if (loads) V_out <= V;
    end

    assign Ain = asel ? 16'b0 : data_A;
    assign Bin = bsel ? sximm5 : shifter_out;

    assign data_in = (vsel == 2'b00) ? data_C     :
                     (vsel == 2'b01) ? {8'b0, PC} :
                     (vsel == 2'b10) ? sximm8     :
                     (vsel == 2'b11) ? mdata      :
                     16'b0;

endmodule