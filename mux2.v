
module mux2 #(parameter WIDTH=8)
            (input wire[WIDTH-1:0] s0, output wire[WIDTH-1: 0] sig,
             input wire[WIDTH-1:0] s1,
             input reg s
);
    assign sig = s ? s1 : s0;
endmodule