
module mux3 #(parameter WIDTH=8)
            (input wire[WIDTH-1:0] s0, output wire[WIDTH-1: 0] sig,
             input wire[WIDTH-1:0] s1,
             input wire[WIDTH-1:0] s2,
             input reg[1:0] s);
    assign sig = s[1] ? s2 : (s[0] ? s1 : s0);
endmodule