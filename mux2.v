
module mux2 (input wire[31:0] s0, output wire[31:0] sig,
             input wire[31:0] s1,
             input wire s
);
    assign sig = s ? s1 : s0;
endmodule