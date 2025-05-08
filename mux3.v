
module mux3 (input wire[31:0] s0, output wire[31: 0] sig,
             input wire[31:0] s1,
             input wire[31:0] s2,
             input wire[1:0] s);
    assign sig = s[1] ? s2 : (s[0] ? s1 : s0);
endmodule