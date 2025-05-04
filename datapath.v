module datapath(input wire clk,              output [31:0] ALUResult,
                input wire reset,            output Zero,
                input reg[1:0] ResultSrc,    output [31:0] PC,
                input PCSrc,                 output [31:0] WriteData,
                input ALUSrc,
                input RegWrite,
                input [1:0] ImmSrc,
                input [2:0] ALUControl,
                input [31:0] Instr,
                input [31:0] ReadData
);

    reg[31:0] PCNext, PCPlus4, PCTarget;
    reg[31:0] ImmExt;
    reg[31:0] SrcA, SrcB;
    reg[31:0] Result;


    // next PC logic
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder pcadd4(PC, 32'd4, PCPlus4);
    adder pcaddbranch(PC, ImmExt, PCTarget);
    mux2 #(32) pcmux(PCPlus4, PCTarget, PCSrc, PCNext);


    // register file logic
    regfile rf(clk, RegWrite, Instr[19:15], Instr[24:20],
    Instr[11:7], Result, SrcA, WriteData);
    extend ext(Instr[31:7], ImmSrc, ImmExt);


    // ALU logic
    mux2 #(32) alu srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
    alu(SrcA, SrcB, ALUControl, ALUResult, Zero);
    mux3 #(32) resultmux(ALUResult, ReadData, PCPlus4, ResultSrc, Result);

endmodule