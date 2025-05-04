module controller(input [6:0] op,       output [1:0] ResultSrc,
                  input [2:0] funct3,   output MemWrite,
                  input funct7b5,       output PCSrc,
                  input Zero,           output ALUSrc,
                                        output logic RegWrite, Jump,
                                        output logic [1:0] ImmSrc,
                                        output logic [2:0] ALUControl
);
    reg[1:0] ALUOp;
    reg Branch;

    maindec md(op, ResultSrc, MemWrite, Branch, ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);
    aludec ad(op[5], funct3, funct7b5, ALUOp, ALUControl);

    assign PCSrc = Branch & Zero | Jump; // control signal for next PC source 
endmodule