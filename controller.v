module controller(input wire[6:0] op,       output wire[1:0] ResultSrc,
                  input wire[2:0] funct3,   output wire MemWrite,
                  input wire funct7b5,      output wire PCSrc,
                  input wire Zero,          output wire ALUSrc,
                                        output wire RegWrite, Jump,
                                        output wire[1:0] ImmSrc,
                                        output wire[2:0] ALUControl
);
    wire[1:0] ALUOp;
    wire Branch;

    maindec md(op, ResultSrc, MemWrite, Branch, ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);

    aludec ad(op[5], funct3, funct7b5, ALUOp, ALUControl);

    assign PCSrc = Branch & Zero | Jump; // control signal for next PC source
endmodule