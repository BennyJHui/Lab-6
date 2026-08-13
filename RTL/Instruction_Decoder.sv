module Instruction_Decoder(
    input [15:0] in_decoder,
    input [2:0] nsel, // nsel = 001 = Rn; nsel = 010 = Rd; nsel = 100 = Rm
    output [1:0] op, shift, ALUop,
    output [2:0] opcode, readnum, writenum,
    output [15:0] sximm5, sximm8
);

    wire [7:0] imm8;
    wire [4:0] imm5;
    wire [2:0] Rn, Rd, Rm;

    assign opcode = in_decoder[15:13];
    assign op = in_decoder[12:11];
    assign imm8 = in_decoder[7:0];
    assign imm5 = in_decoder[4:0];
    assign ALUop = in_decoder[12:11];
    assign shift = in_decoder[4:3];
    assign Rm = in_decoder[2:0];
    assign Rd = in_decoder[7:5];
    assign Rn = in_decoder[10:8];

    assign readnum = (nsel[2]) ? (Rm) :
                     (nsel[1]) ? (Rd) :
                     (nsel[0]) ? (Rn) :
                     0;

    assign writenum = (nsel[2]) ? (Rm) :
                      (nsel[1]) ? (Rd) :
                      (nsel[0]) ? (Rn) :
                      0;

    assign sximm8 = {{8{imm8[7]}}, imm8};
    assign sximm5 = {{11{imm5[4]}}, imm5};

endmodule