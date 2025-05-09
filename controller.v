module controller(input wire[6:0] op,       output wire[1:0] ResultSrc,
                  input wire[2:0] funct3,   output wire MemWrite,
                  input wire funct7b5,      output wire PCSrc,
                  input wire Zero,          output wire ALUSrc,
                                        output wire RegWrite,
                                        output wire Jump,
                                        output wire[1:0] ImmSrc,
                                        output wire[2:0] ALUControl
);
    wire[1:0] ALUOp;
    wire Branch;

    maindec md(.op(op),
                .ResultSrc(ResultSrc),
                .MemWrite(MemWrite),
                .Branch(Branch),
                .ALUSrc(ALUSrc),
                .RegWrite(RegWrite),
                .Jump(Jump),
                .ImmSrc(ImmSrc),
                .ALUOp(ALUOp)
    );

    aludec ad(.opb5(op[5]), .funct3(funct3), .funct7b5(funct7b5), .ALUOp(ALUOp),
              .ALUControl(ALUControl));

    assign PCSrc = Branch & Zero | Jump; // control signal for next PC source
endmodule