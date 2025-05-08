
module flopenr (input wire clk, output reg[31:0] q = 0,
                 input wire reset,
                 input wire en,
                 input wire[31:0] d
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 0;
        else if (en)
            q <= d;
    end

endmodule
