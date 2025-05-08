module datapath(input wire clk,              output wire[31:0] ALUResult,
                input wire reset,            output wire Zero,
                input wire[1:0] ResultSrc,   output wire[31:0] PC,
                input wire PCSrc,            output wire[31:0] WriteData,
                input wire ALUSrc,
                input wire RegWrite,
                input wire[1:0] ImmSrc,
                input wire[2:0] ALUControl,
                input wire[31:0] Instr,
                input wire[31:0] ReadData
);

    wire[31:0] PCNext, PCPlus4, PCTarget;
    wire[31:0] ImmExt;
    wire[31:0] SrcA, SrcB;
    wire[31:0] Result;


    // next PC logic
    flopr pcreg(.clk(clk), .reset(reset), .d(PCNext), .q(PC));
    adder pcadd4(.a(PC), .b(32'd4), .res(PCPlus4));
    adder pcaddbranch(.a(PC), .b(ImmExt), .res(PCTarget));
    mux2  pcmux(.s0(PCPlus4), .s1(PCTarget), .s(PCSrc), .sig(PCNext));


    // register file logic
    regfile rf(.clk(clk), .we(RegWrite), .a1(Instr[19:15]), .a2(Instr[24:20]), .a3(Instr[11:7]),
                .rd1(SrcA),
                .rd2(WriteData),
                .wd3(Result));
    extend ext(.instr(Instr[31:7]), .immsrc(ImmSrc),
               .immext(ImmExt));

    // ALU logic
    mux2 srcbmux(.s0(WriteData), .s1(ImmExt), .s(ALUSrc), .sig(SrcB));
    alu alu(.a(SrcA), .b(SrcB), .ALUop(ALUControl), .res(ALUResult), .zero(Zero));
    mux3 resultmux(.s0(ALUResult), .s1(ReadData), .s2(PCPlus4), .s(ResultSrc), .sig(Result));

endmodule