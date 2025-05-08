module alu(input wire[31:0] a, output wire[31:0] res,
           input wire[31:0] b, output wire zero,
           input wire[2:0] ALUop);

    assign res = (ALUop == 3'b000) ? (a + b):
                 (ALUop == 3'b001) ? (a - b):
                 (ALUop == 3'b101) ? ((a < b) ? 1 : 0):
                 (ALUop == 3'b011) ? (a | b):
                 (ALUop == 3'b010) ? (a & b):
                 31'bx; // ???

    assign zero = (res == 0);

endmodule

