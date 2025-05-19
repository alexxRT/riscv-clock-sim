
module rwb(input wire clk,                    output wire WriteW,
                 input wire WriteM,           output wire[1:0] ResultSrcW,
                 input wire[1:0] ResultSrcM,  output wire[31:0] AluResultW,
                 input wire[31:0] ReadDataM,  output wire[31:0] ReadDataW,
                 input wire[31:0] AluResultM, output wire[4:0] RdW,
                 input wire[4:0] RdM,         output wire[31:0] PCPlus4W,
                 input wire[31:0] PCPlus4M);

    reg[127:0] q;

    assign {WriteW, ResultSrcW, ReadDataW, AluResultW, RdW, PCPlus4W} = q;

    always @(posedge clk) begin
        q <= {WriteM, ResultSrcM, ReadDataM, AluResultM, RdM, PCPlus4M};
    end


endmodule