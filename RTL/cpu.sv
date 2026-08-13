module cpu(clk,reset,s,load,in,out,N,V,Z,w);
input clk, reset, s, load;
input [15:0] in;
output [15:0] out;
output N, V, Z, w;

    reg [15:0] in_decoder;

    // FSM
    reg loada, loadb, loadc, loads, asel, bsel, write;
    reg [1:0] op, vsel;
    reg [2:0] opcode, nsel;

    // To Datapath
    reg [1:0] shift, ALUop;
    reg [2:0] readnum, writenum;
    reg [15:0] sximm5, sximm8;

    Instruction_Decoder U0(
        .in_decoder(in_decoder),
        .nsel(nsel),
        .op(op),
        .shift(shift),
        .ALUop(ALUop),
        .opcode(opcode),
        .readnum(readnum),
        .writenum(writenum),
        .sximm5(sximm5),
        .sximm8(sximm8)
    );

    datapath DP( 
        .clk(clk),
        .write(write),
        .asel(asel),
        .bsel(bsel),
        .loada(loada),
        .loadb(loadb),
        .loadc(loadc),
        .loads(loads), 
        .shift(shift),
        .ALUop(ALUop),
        .vsel(vsel),
        .readnum(readnum),
        .writenum(writenum),
        .PC(8'b0),
        .mdata(16'b0),
        .sximm8(sximm8),
        .sximm5(sximm5),
        .Z_out(Z),
        .N_out(N),
        .V_out(V),
        .datapath_out(out)
    );

    FSM U2(
        .s(s),
        .reset(reset),
        .clk(clk),
        .op(op),
        .opcode(opcode),
        .w(w),
        .loada(loada),
        .loadb(loadb),
        .loadc(loadc),
        .loads(loads),
        .asel(asel),
        .bsel(bsel),
        .write(write),
        .vsel(vsel),
        .nsel(nsel)
    );

    always_ff @(posedge clk) begin
        if (load) in_decoder <= in;
    end

endmodule