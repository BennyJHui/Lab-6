module ALU(Ain,Bin,ALUop,out,Z,N,V);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output reg Z, N, V;
    reg sub, B_xor_A, sid, siod;
    reg [14:0] B_xor_B;
    wire C_out_A, S_B;

    Full_Adder_B U0(
        .A(Ain[14:0]), 
        .B(B_xor_B), 
        .C_in(sub),
        .S(),
        .C_out(C_out_A)
    );

    Full_Adder_A U1(
        .A(Ain[15]), 
        .B(B_xor_A), 
        .C_in(C_out_A),
        .S(S_B),
        .C_out()
    );

    always_comb begin
        sub = 0;
        case(ALUop)
            2'b00: begin 
                out = Ain + Bin;
                sub = 0;
            end
            2'b01: begin 
                out = Ain - Bin;
                sub = 1;
            end
            2'b10: out = Ain & Bin;
            2'b11: out = ~Bin;
        endcase

        if (out == 16'b0) begin
            Z = 1;
        end else begin
            Z = 0;
        end

        if (out[15]) begin
            N = 1;
        end else begin
            N = 0;
        end

        B_xor_B = {15{sub}} ^ Bin[14:0];
        B_xor_A = Bin[15] ^ sub;

        sid = Ain[15] ^ B_xor_A;
        siod = S_B ^ Ain[15];
        V = ~sid & siod;

    end
endmodule

module Full_Adder_A(
    input A, B, C_in,
    output S, C_out
);

    assign S = A ^ B ^ C_in;
    assign C_out = (A & B) | (C_in & A) | (C_in & B);

endmodule

module Full_Adder_B(
    input [14:0] A, B, 
    input C_in,
    output [14:0] S, 
    output C_out
);

    wire [14:0] p = A ^ B;
    wire [14:0] g = A & B;
    wire [15:0] c = {g | (p & c[14:0]), C_in};
    assign S = p ^ c[14:0];
    assign C_out = c[15];

endmodule