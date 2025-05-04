

module flopr #(parameter WIDTH = 8)
                (input clk,                output logic [WIDTH−1:0] q,
                input reset,
                input wire[WIDTH−1:0] d
);

always_ff @(posedge clk, posedge reset)
    q <= reset ? 0 : d;
endmodule