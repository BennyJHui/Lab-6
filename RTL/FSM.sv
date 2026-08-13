`define Wait 4'b0000
`define Decode 4'b0001
`define Get_Rm 4'b0010
`define Load_Rn 4'b0011
`define Get_Rn 4'b0100
`define ALU_A 4'b0101
`define ALU_B 4'b0110
`define ALU_C 4'b0111
`define Load_Rd 4'b1000

module FSM(
    input s, reset, clk,
    input [1:0] op,
    input [2:0] opcode,
    output reg w, loada, loadb, loadc, loads, asel, bsel, write,
    output reg [1:0] vsel,
    output reg [2:0] nsel
);

    reg [3:0] state = `Wait;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= `Wait;
        end else begin
            case(state)
                `Wait: state <= s ? `Decode : `Wait;

                `Decode: begin
                    case({opcode, op})
                        5'b11010: state <= `Load_Rn;
                        5'b11000: state <= `Get_Rm;
                        5'b10100: state <= `Get_Rn;
                        5'b10101: state <= `Get_Rn;
                        5'b10110: state <= `Get_Rn;
                        5'b10111: state <= `Get_Rm;
                        default: state <= `Wait;
                    endcase
                end

                `Get_Rm: begin
                    case({opcode, op})
                        5'b11000: state <= `ALU_A;
                        5'b10100: state <= `ALU_B;
                        5'b10101: state <= `ALU_C;
                        5'b10110: state <= `ALU_B;
                        5'b10111: state <= `ALU_A;
                        default: state <= `Wait;
                    endcase
                end

                `Load_Rn: state <= `Wait;

                `Get_Rn: state <= `Get_Rm;

                `ALU_A: state <= `Load_Rd;

                `ALU_B: state <= `Load_Rd;

                `ALU_C: state <= `Wait;

                `Load_Rd: state <= `Wait;

                default: state <= `Wait;
            endcase
        end
    end

    always_comb begin
        w = 0;
        loada = 0;
        loadb = 0;
        loadc = 0;
        loads = 0;
        asel = 0;
        bsel = 0;
        write = 0;
        vsel = 2'b00;
        nsel = 3'b000;

        case(state)

            `Wait: begin
                w = 1;
            end

            `Decode: begin
                // nothing
            end

            `Get_Rm: begin
                nsel = 3'b100;
                loadb = 1;
            end

            `Load_Rn: begin
                vsel = 2'b10;
                nsel = 3'b001;
                write = 1;
            end

            `Get_Rn: begin
                nsel = 3'b001;
                loada = 1;
            end

            `ALU_A: begin
                asel = 1;
                bsel = 0;
                loadc = 1;
            end

            `ALU_B: begin
                asel = 0;
                bsel = 0;
                loadc = 1;
            end

            `ALU_C: begin
                asel = 0;
                bsel = 0;
                loads = 1;
            end

            `Load_Rd: begin
                vsel = 2'b00;
                nsel = 3'b010;
                write = 1;
            end

            default: begin
                w = 0;
                loada = 0;
                loadb = 0;
                loadc = 0;
                loads = 0;
                asel = 0;
                bsel = 0;
                write = 0;
                vsel = 2'b00;
                nsel = 3'b000;
            end

        endcase
    end
endmodule