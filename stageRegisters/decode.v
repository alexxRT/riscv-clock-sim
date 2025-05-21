module rdec(input clk,
            input wire[31:0] InstrF,     output wire[31:0] InstrD,
            input wire[31:0] PCF,        output wire[31:0] PCD,
            input wire[31:0] PCPlus4F,   output wire[31:0] PCPlus4D,
            input wire reset,
            input wire en
);

reg[127:0] q;

assign {InstrD, PCD, PCPlus4D} = q;

always @(posedge clk) begin
    if (~en)
        q <= reset ? 0 : {InstrF, PCF, PCPlus4F};
end


endmodule
