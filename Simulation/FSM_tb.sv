module FSM_tb();

reg clk, reset, s;
reg [1:0] op;
reg [2:0] opcode;

wire w, loada, loadb, loadc, loads;
wire asel, bsel, write;
wire [1:0] vsel;
wire [2:0] nsel;


FSM DUT(
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


// 10 ns clock period
always #5 clk = ~clk;


initial begin

    clk = 0;
    reset = 1;
    s = 0;
    opcode = 3'b000;
    op = 2'b00;

    // Reset FSM
    #10;
    reset = 0;
    #10;


    // =====================================================
    // TEST 1: MOV Rn, #im8
    //
    // Expected:
    // Wait -> Decode -> Load_Rn -> Wait
    //
    // Load_Rn:
    // vsel = 10
    // nsel = 001
    // write = 1
    // =====================================================

    $display("TEST 1: MOV Rn, #im8");

    opcode = 3'b110;
    op = 2'b10;
    s = 1;

    #10;
    s = 0;

    #30;


    // =====================================================
    // TEST 2: MOV Rd, Rm
    //
    // Expected:
    // Wait -> Decode -> Get_Rm -> ALU_A -> Load_Rd -> Wait
    //
    // Get_Rm:
    // nsel = 100
    // loadb = 1
    //
    // ALU_A:
    // asel = 1
    // bsel = 0
    // loadc = 1
    //
    // Load_Rd:
    // vsel = 00
    // nsel = 010
    // write = 1
    // =====================================================

    $display("TEST 2: MOV Rd, Rm");

    opcode = 3'b110;
    op = 2'b00;
    s = 1;

    #10;
    s = 0;

    #50;


    // =====================================================
    // TEST 3: ADD Rd, Rn, Rm
    //
    // Expected:
    // Wait -> Decode -> Get_Rn -> Get_Rm
    // -> ALU_B -> Load_Rd -> Wait
    //
    // Get_Rn:
    // nsel = 001
    // loada = 1
    //
    // Get_Rm:
    // nsel = 100
    // loadb = 1
    //
    // ALU_B:
    // asel = 0
    // bsel = 0
    // loadc = 1
    //
    // Load_Rd:
    // vsel = 00
    // nsel = 010
    // write = 1
    // =====================================================

    $display("TEST 3: ADD");

    opcode = 3'b101;
    op = 2'b00;
    s = 1;

    #10;
    s = 0;

    #60;


    // =====================================================
    // TEST 4: CMP Rn, Rm
    //
    // Expected:
    // Wait -> Decode -> Get_Rn -> Get_Rm
    // -> ALU_C -> Wait
    //
    // ALU_C:
    // asel = 0
    // bsel = 0
    // loads = 1
    // loadc = 0
    // =====================================================

    $display("TEST 4: CMP");

    opcode = 3'b101;
    op = 2'b01;
    s = 1;

    #10;
    s = 0;

    #50;


    // =====================================================
    // TEST 5: AND Rd, Rn, Rm
    //
    // Expected:
    // Wait -> Decode -> Get_Rn -> Get_Rm
    // -> ALU_B -> Load_Rd -> Wait
    // =====================================================

    $display("TEST 5: AND");

    opcode = 3'b101;
    op = 2'b10;
    s = 1;

    #10;
    s = 0;

    #60;


    // =====================================================
    // TEST 6: MVN Rd, Rm
    //
    // Expected:
    // Wait -> Decode -> Get_Rm -> ALU_A
    // -> Load_Rd -> Wait
    // =====================================================

    $display("TEST 6: MVN");

    opcode = 3'b101;
    op = 2'b11;
    s = 1;

    #10;
    s = 0;

    #50;


    $display("FSM TESTING COMPLETE");

    $stop;

end

endmodule