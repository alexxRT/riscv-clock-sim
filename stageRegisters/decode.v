module rdec(input clk,
            input wire[31:0] InstrF,     output wire[31:0] InstrD,
            input wire[31:0] PCF,        output wire[31:0] PCD,
            input wire[31:0] PCPlus4F,   output wire[31:0] PCPlus4D,
            input wire en,
            input wire reset,
            input wire flush
);

reg[127:0] q = 32'h13;
reg[5:0] clk_counter = 0;

assign {PCD, PCPlus4D, InstrD} = q;

always @(posedge clk or posedge reset) begin
    if (reset)
		  q <= 32'h13;
	 else if (en)
        q <= (flush) ? 32'h13 : {PCF, PCPlus4F, InstrF};
end


endmodule
