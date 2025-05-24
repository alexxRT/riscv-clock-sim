module rdec(input clk,
            input wire[31:0] InstrF,     output wire[31:0] InstrD,
            input wire[31:0] PCF,        output wire[31:0] PCD,
            input wire[31:0] PCPlus4F,   output wire[31:0] PCPlus4D,
            input wire en,
            input wire reset,
            input wire clr
);

reg[127:0] q = 32'h13;
reg[5:0] clk_counter = 0;

assign {PCD, PCPlus4D, InstrD} = q;

always @(posedge clk) begin
    if (en)
        q <= (reset | clr) ? 32'h13 : {PCF, PCPlus4F, InstrF};
    // clk_counter <= clk_counter + 1;
end


endmodule
