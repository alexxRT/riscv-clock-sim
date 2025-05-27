`include "stageRegisters/decode.v"
`include "stageRegisters/execute.v"
`include "stageRegisters/memory.v"
`include "stageRegisters/writeback.v"

module datapath(input wire clk,              output wire[31:0] ALUResultM,
                input wire reset,            output wire PCSrcE,
                input wire[1:0] ResultSrcD,   output wire[31:0] PC,
                input wire ALUSrcD,          output wire[31:0] PCPlus4M,
                input wire RegWriteW,        output wire RegWriteM,
                input wire MemWriteD,        output wire[1:0] ResultSrcE,
                input wire RegWriteD,        output wire[4:0] RdM,
                input wire JumpD,            output wire[4:0] Rs1E,
                input wire BranchD,          output wire[4:0] Rs2E,
                input wire[1:0] ImmSrcD,      output wire[4:0] RdE,
                input wire[2:0] ALUControlD,   output wire[31:0] WriteDataM,
                input wire[31:0] InstrF,
                input wire[1:0] ForwardAE,      output wire[1:0] ResultSrcM,
                input wire[1:0] ForwardBE,      output wire MemWriteM,
                input wire StallD,              output wire[31:0] InstrD,
                input wire FlushD,
                input wire FlushE,
                input wire StallF,
                input wire[31:0] ResultW,
                input wire[4:0] RdW
);

    wire[31:0] PCNext;
    wire[31:0] PCPlus4;
    wire[31:0] PCTargetE;
    wire[31:0] ImmExtD;

    // next PC logic
    assign PCSrcE = BranchE & ZeroE | JumpE;
    flopenr pcreg(.clk(clk), .en(~StallF), .reset(reset), .d(PCNext), .q(PC));
    adder pcadd4(.a(PC), .b(32'd4), .res(PCPlus4));
    adder pcaddbranch(.a(PCE), .b(ImmExtE), .res(PCTargetE));
    mux2  pcmux(.s0(PCPlus4), .s1(PCTargetE), .s(PCSrcE), .sig(PCNext));

    // instr on decode
    wire[31:0] PCD;
    wire[31:0] PCPlus4D;

    // decode stage register
    rdec rdec(.clk(clk),            .InstrD(InstrD),
                .InstrF(InstrF),    .PCD(PCD),
                .PCF(PC),           .PCPlus4D(PCPlus4D),
                .PCPlus4F(PCPlus4),
                .en(~StallD),
                .flush(FlushD),
                .reset(reset)
    );

    wire[31:0] rd1D;
    wire[31:0] rd2D;

    // register file logic
    regfile rf(.clk(clk),           .rd1(rd1D),
               .we(RegWriteW),      .rd2(rd2D),
               .a1(InstrD[19:15]),
               .a2(InstrD[24:20]),
               .a3(RdW),
               .wd3(ResultW),
               .reset(reset)
             );


    extend ext(.instr(InstrD[31:7]), .immsrc(ImmSrcD),
               .immext(ImmExtD));

    wire RegWriteE;
    wire MemWriteE;
    wire JumpE;
    wire BranchE;
    wire[2:0] ALUControlE;
    wire ALUSrcE;
    wire[31:0] rd1E;
    wire[31:0] rd2E;
    wire[31:0] PCE;
    wire[31:0] PCPlus4E;
    wire[31:0] ImmExtE;

    // execute stage register
    rexe rexe(.clk(clk),                 .RegWriteE(RegWriteE),
              .RegWriteD(RegWriteD),     .ResultSrcE(ResultSrcE),
              .ResultSrcD(ResultSrcD),   .MemWriteE(MemWriteE),
              .MemWriteD(MemWriteD),     .JumpE(JumpE),
              .JumpD(JumpD),             .BranchE(BranchE),
              .BranchD(BranchD),         .ALUControlE(ALUControlE),
              .ALUControlD(ALUControlD), .ALUSrcE(ALUSrcE),
              .ALUSrcD(ALUSrcD),         .rd1E(rd1E),
              .rd1(rd1D),                .rd2E(rd2E),
              .rd2(rd2D),                .PCE(PCE),
              .PCD(PCD),                 .Rs1E(Rs1E),
              .Rs1D(InstrD[19:15]),      .Rs2E(Rs2E),
              .Rs2D(InstrD[24:20]),      .RdE(RdE),
              .RdD(InstrD[11:7]),        .ImmExtE(ImmExtE),
              .ImmExtD(ImmExtD),         .PCPlus4E(PCPlus4E),
              .PCPlus4D(PCPlus4D),
              .flush(FlushE),
              .reset(reset)
    );

    // alu logic
    wire[31:0] srcAE;
    wire[31:0] srcBE;
    wire[31:0] WriteDataE;
    wire ZeroE;
    wire[31:0] ALUResultE;

    mux3 fwdAmux(.s0(rd1E),       .s(ForwardAE),
                .s1(ResultW),     .sig(srcAE),
                .s2(ALUResultM));

    mux3 fwdBmux(.s0(rd2E),      .s(ForwardBE),
                .s1(ResultW),    .sig(WriteDataE),
                .s2(ALUResultM));

    mux2 srcbmux(.s0(WriteDataE), .s1(ImmExtE), .s(ALUSrcE), .sig(srcBE));
    alu alu(.a(srcAE), .b(srcBE), .ALUop(ALUControlE), .res(ALUResultE), .zero(ZeroE));

    //memory stage register
    rmem rmem(.clk(clk),               .RegWriteM(RegWriteM),
              .RegWriteE(RegWriteE),   .ResultSrcM(ResultSrcM),
              .ResultSrcE(ResultSrcE), .WriteDataM(WriteDataM),
              .WriteDataE(WriteDataE), .MemWriteM(MemWriteM),
              .MemWriteE(MemWriteE),   .ALUResultM(ALUResultM),
              .ALUResultE(ALUResultE), .RdM(RdM),
              .RdE(RdE),               .PCPlus4M(PCPlus4M),
              .PCPlus4E(PCPlus4E),
              .reset(reset)
    );

endmodule