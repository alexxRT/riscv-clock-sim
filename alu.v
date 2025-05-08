module alu(input wire[31:0] a, output wire[31:0] res,
           input wire[31:0] b, output wire zero,
           input wire op);

    assign res = (op == 3'b000) ? (a + b):
                 (op == 3'b001) ? (a - b):
                 (op == 3'b101) ? ((a < b) ? 1 : 0):
                 (op == 3'b011) ? (a | b):
                 (op == 3'b010) ? (a & b):
                 31'bx; // ???

    assign zero = (res == 0);
    
endmodule

