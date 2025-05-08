module riscv(input wire clk,             output wire[31:0] PC,
             input wire reset,           output wire MemWrite,
             input wire[31:0] Instr,     output wire[31:0] ALUResult,
             input wire[31:0] ReadData,  output wire[31:0] WriteData
);

wire ALUSrc;
wire RegWrite;
wire Jump;
wire Zero;
wire PCSrc;

wire[1:0] ResultSrc;
wire[1:0] ImmSrc;
wire[2:0] ALUControl;

controller c(.op(Instr[6:0]), .funct3(Instr[14:12]), .funct7(Instr[30]), .Zero(Zero),
            .ResultSrc(ResultSrc),
            .MemWrite(MemWrite),
            .PCSrc(PCSrc),
            .ALUSrc(ALUSrc),
            .RegWrite(RegWrite),
            .Jump(Jump),
            .ImmSrc(ImmSrc),
            .ALUControl(ALUControl));

datapath dp(.clk(clk), .Instr(Instr), .ReadData(ReadData), .reset(reset), .ResultSrc(ResultSrc), .PCSrc(PCSrc), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .ImmSrc(ImmSrc), .ALUControl(ALUControl),
            .Zero(Zero),
            .PC(PC),
            .ALUResult(ALUResult),
            .WriteData(WriteData),
            );

endmodule
