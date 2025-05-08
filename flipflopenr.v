
module flopenr #(parameter WIDTH = 8)
                (input wire clk, output reg[WIDTH–1:0] q = 0,
                 input wire reset,
                 input wire en,
                 input wire[WIDTH–1:0] d
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 0
        else if (en)
            q <= d
    end

endmodule
