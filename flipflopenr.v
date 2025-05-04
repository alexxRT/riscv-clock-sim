
module flopenr #(parameter WIDTH = 8)
                (input clk, output wire[WIDTH–1:0] q
                input reset,
                input en,
                input wire[WIDTH–1:0] d
);
    always_ff @(posedge clk, posedge reset)
        q <= 0 ? reset : d ? en : q;
endmodule
