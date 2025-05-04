module riscv(input clk,             output [31:0] PC,
             input reset,           output MemWrite,
             input [31:0] Instr,    output [31:0] ALUResult,
             input [31:0], ReadData output [31:0] WriteData,
);

reg ALUSrc;
reg RegWrite;
reg Jump;
reg Zero;

reg[1:0] ResultSrc;
reg[1:0] ImmSrc;
reg[2:0] ALUControl;

controller c(Instr[6:0], Instr[14:12], Instr[30], Zero, ResultSrc, MemWrite,
            PCSrc, ALUSrc, RegWrite, Jump, ImmSrc, ALUControl);

datapath dp(clk, reset, ResultSrc, PCSrc, ALUSrc, RegWrite, ImmSrc, ALUControl,
            Zero, PC, Instr, ALUResult, WriteData, ReadData);

endmodule
