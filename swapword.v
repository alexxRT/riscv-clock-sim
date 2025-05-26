

module nextword(input wire clk,          output wire[31:0] next,
                input wire[31:0] word1,
                input wire[31:0] word2);

wire ce1ms;
wire ce1s;
reg cw = 1'b0;

gen1ms ms(.clk(clk), .ce1ms(ce1ms));
gen1ms1s s(.clk(clk), .ce(ce1ms), .ce1s(ce1s));

mux2 nw(.s0(word1), .s1(word2), .s(cw), .sig(next));

always @(posedge ce1s) begin
    cw <= ~cw;
end

endmodule