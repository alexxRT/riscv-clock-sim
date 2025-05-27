
module rwb(input wire clk,                    output wire RegWriteW,
                 input wire RegWriteM,           output wire[1:0] ResultSrcW,
                 input wire[1:0] ResultSrcM,  output wire[31:0] ALUResultW,
                 input wire[31:0] ReadDataM,  output wire[31:0] ReadDataW,
                 input wire[31:0] ALUResultM, output wire[4:0] RdW,
                 input wire[4:0] RdM,         output wire[31:0] PCPlus4W,
                 input wire[31:0] PCPlus4M,
                 input wire reset
                );

    reg[127:0] q;

    assign {RegWriteW, ResultSrcW, ReadDataW, ALUResultW, RdW, PCPlus4W} = q;

    always @(posedge clk or posedge reset) begin
        q <= reset? 0 : {RegWriteM, ResultSrcM, ReadDataM, ALUResultM, RdM, PCPlus4M};
    end


endmodule