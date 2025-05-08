
module adder(input wire[31:0] a, output wire[31:0] res,
             input wire[31:0] b);
    assign res = a + b;
endmodule