
module top(input wire clk,     output wire[7:0] SEG,
           input wire btn0,    output wire[7:0] AN,
           input wire reset
          );

    wire[31:0] PC;
    wire[31:0] InstrF;
    wire[31:0] ReadDataM;
    wire[31:0] WriteDataM;
    wire[31:0] ALUResultM;
    wire RegWriteM;
    wire MemWriteM;
    wire[4:0] RdM;
    wire[31:0] PCPlus4M;
    wire[1:0] ResultSrcM;

    wire RegWriteW;
    wire[31:0] ResultW;
    wire[4:0] RdW;

    wire[31:0] dispword;

    nextword nw(.clk(clk), .word1(PC), .word2(InstrF), .next(dispword));
    display disp(.clk(clk), .word(dispword), .AN(AN), .SEG(SEG));

    // instantiate processor and memories
    riscvsingle rvsingle(.clk(clk),              .RegWriteM(RegWriteM),
                         .InstrF(InstrF),        .RdM(RdM),
                         .RegWriteW(RegWriteW),  .PCPlus4M(PCPlus4M),
                         .ResultW(ResultW),      .ALUResultM(ALUResultM),
                         .RdW(RdW),              .ResultSrcM(ResultSrcM),
                         .reset(reset),          .PC(PC),
                                                 .MemWriteM(MemWriteM),
                                                 .WriteDataM(WriteDataM)

    );
    // intstantiate both memories - instr and data
    imem imem(.a(PC), .rd(InstrF));

    dmem dmem(.clk(clk), .we(MemWriteM), .a(ALUResultM),
              .wd(WriteDataM), .rd(ReadDataM), .reset(reset));

    wire[1:0] ResultSrcW;
    wire[31:0] ALUResultW;
    wire[31:0] ReadDataW;
    wire[31:0] PCPlus4W;

    // writeback stage register
    rwb rwb(.clk(clk),               .RegWriteW(RegWriteW),
            .RegWriteM(RegWriteM),   .RdW(RdW),
            .ResultSrcM(ResultSrcM), .ALUResultW(ALUResultW),
            .ALUResultM(ALUResultM), .ReadDataW(ReadDataW),
            .ReadDataM(ReadDataM),   .PCPlus4W(PCPlus4W),
            .RdM(RdM),               .ResultSrcW(ResultSrcW),
            .PCPlus4M(PCPlus4M),
            .reset(reset)
    );

    mux3 muxsel(.s0(ALUResultW), .s(ResultSrcW),
                .s1(ReadDataW),  .sig(ResultW),
                .s2(PCPlus4W)
    );

endmodule