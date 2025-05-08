

module flopr (input clk,                output reg[31:0] q,
              input reset,
              input wire[31:0] d
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 0;
        else
            q <= d;
    end
endmodule