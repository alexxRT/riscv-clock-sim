module rexe(input wire clk,               output wire RegWriteE,
            input wire RegWriteD,         output wire[1:0] ResultSrcE,
            input wire[1:0] ResultSrcD,   output wire MemWriteE,
            input wire MemWriteD,         output wire JumpE,
            input wire JumpD,             output wire BranchE,
            input wire BranchD,           output wire[2:0] ALUControlE,
            input wire[2:0] ALUControlD,  output wire ALUSrcE,
            input wire ALUSrcD,           output wire[31:0] rd1E,
            input wire[31:0] rd1,         output wire[31:0] rd2E,
            input wire[31:0] rd2,         output wire[31:0] PCE,
            input wire[31:0] PCD,         output wire[4:0] Rs1E,
            input wire[4:0] Rs1D,         output wire[4:0] Rs2E,
            input wire[4:0] Rs2D,         output wire[4:0] RdE,
            input wire[4:0] RdD,          output wire[31:0] ImmExtE,
            input wire[31:0] ImmExtD,     output wire[31:0] PCPlus4E,
            input wire[31:0] PCPlus4D,
            input wire[31:0] InstrD,
            input wire flush,
            input wire reset
);

reg[255:0] q;
wire[31:0] InstrE;
wire flushE;

assign {RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE,
       ALUControlE, ALUSrcE, rd1E, rd2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E, InstrE, flushE} = q;

always @(posedge clk or posedge reset) begin
    q <= (reset | flush) ? flush : {RegWriteD, ResultSrcD, MemWriteD, JumpD,
                        BranchD, ALUControlD, ALUSrcD, rd1, rd2,
                        PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D, InstrD, flush};
end

reg[7:0] icb = 0;

always @(negedge clk) begin
    if (InstrE != 32'h13 && ~flushE && ~reset) begin
        $display("%d: [%x]", icb, InstrE);
        icb <= icb + 1;
    end
end


endmodule