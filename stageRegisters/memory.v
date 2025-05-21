
module rmem(input wire clk,                  output wire RegWriteM,
            input wire RegWriteE,            output wire[1:0] ResultSrcM,
            input wire[1:0] ResultSrcE,      output wire[31:0] WriteDataM,
            input wire[31:0] WriteDataE,         output wire MemWriteM,
            input wire MemWriteE,            output wire[31:0] ALUResultM,
            input wire[31:0] ALUResultE,         output wire[4:0] RdM,
            input wire[4:0] RdE,             output wire[31:0] PCPlus4M,
            input wire[31:0] PCPlus4E
);

    reg[127:0] q;

    assign {RegWriteM, ResultSrcM, WriteDataM,
               MemWriteM, ALUResultM, RdM, PCPlus4M} = q;

    always @(posedge clk) begin
        q <= {RegWriteE, ResultSrcE, WriteDataE,
               MemWriteE, ALUResultE, RdE, PCPlus4E};
    end



endmodule