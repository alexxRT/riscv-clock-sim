module rdec(input clk,
            input wire[31:0] instrF,     output wire[31:0] instrD,
            input wire[31:0] PCF,        output wire[31:0] PCF,
            input wire[31:0] PCPlus4F,   output wire[31:0] PCPlus4D
            input wire reset,
            input wire en,
);

reg[127:0] q;

assign {instrD, PCD, PCPlus4D} = q;

always @(posedge clk) begin
    if (~en)
        q <= reset ? 0 : {instrF, PCF, PCPlus4F};
end


endmodule
