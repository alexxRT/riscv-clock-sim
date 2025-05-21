module controller(input wire[6:0] op,       output wire[1:0] ResultSrc,
                  input wire[2:0] funct3,   output wire MemWrite,
                  input wire funct7b5,      output wire PCSrc,
                                            output wire ALUSrc,
                                            output wire RegWrite,
                                            output wire Jump,
                                            output wire Branch,
                                            output wire[1:0] ImmSrc,
                                            output wire[2:0] ALUControl
);
    wire[1:0] ALUOp;

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

endmodule