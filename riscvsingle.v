module riscvsingle(input wire clk,              output wire[31:0] PCPlus4M,
                   input wire[31:0] InstrF,     output wire[31:0] WriteDataM,
                   input wire RegWriteW,        output wire[31:0] ALUResultM,
                   input wire[31:0] ResultW,    output wire[1:0] ResultSrcM,
                   input wire[4:0] RdW,         output wire RegWriteM,
                                                output wire[4:0] RdM,
                                                output wire[31:0] PC,
                                                output wire MemWriteM
);


// controller to datapath
wire ALUSrcD;
wire RegWriteD;
wire JumpD;
wire BranchD;
wire[1:0] ResultSrcD;
wire[1:0] ImmSrcD;
wire[2:0] ALUControlD;

//datapath -> hazard
wire PCSrcE;
wire[1:0] ResultSrcE;
wire[4:0] Rs1E;
wire[4:0] Rs2E;
wire[4:0] Rs1D;
wire[4:0] Rs2D;
wire[4:0] RdE;

// hazard -> datapath
wire[1:0] ForwardAE;
wire[1:0] ForwardBE;
wire lwStall;
wire StallF;
wire FlushE;
wire StallD;
wire FlushD;

controller c(.op(InstrF[6:0]), .funct3(InstrF[14:12]), .funct7b5(InstrF[30]),
            .ResultSrc(ResultSrcD),
            .MemWrite(MemWriteD),
            .ALUSrc(ALUSrcD),
            .RegWrite(RegWriteD),
            .Jump(JumpD),
            .Branch(BranchD),
            .ImmSrc(ImmSrcD),
            .ALUControl(ALUControlD)
);

datapath dp(.clk(clk),                  .ALUResultM(ALUResultM),
            .InstrF(InstrF),             .PCSrcE(PCSrcE),
                                        .RegWriteM(RegWriteM),
                                         .ResultSrcE(ResultSrcE),
            .ResultSrcD(ResultSrcD),     .RdM(RdM),
            .ALUSrcD(ALUSrcD),           .Rs1E(Rs1E),
            .RegWriteD(RegWriteD),       .Rs2E(Rs2E),
            .ImmSrcD(ImmSrcD),           .RdE(RdE),
            .ALUControlD(ALUControlD),   .Rs1D(Rs1D),
            .ForwardAE(ForwardAE),      .Rs2D(Rs2D),
            .ForwardBE(ForwardBE),      .PC(PC),
                                        .PCPlus4M(PCPlus4M),
            .FlushE(FlushE),            .ResultSrcM(ResultSrcM),
            .StallD(StallD),            .WriteDataM(WriteDataM),
            .FlushD(FlushD),            .MemWriteM(MemWriteM),
            .ResultW(ResultW)
);


hazard unit(.Rs1E(Rs1E),                  .ForwardAE(ForwardAE),
            .Rs2E(Rs2E),                  .ForwardBE(ForwardBE),
            .RdE(RdE),                    .lwStall(lwStall),
            .Rs1D(Rs1D),                  .StallF(StallF),
            .Rs2D(Rs2D),                  .FlushE(FlushE),
            .RegWriteW(RegWriteW),        .StallD(StallD),
            .RegWriteM(RegWriteM),        .FlushD(FlushD),
            .ResultSrcE(ResultSrcE),
            .RdM(RdM),
            .RdW(RdW),
            .PCSrcE(PCSrcE));




endmodule
