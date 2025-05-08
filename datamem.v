module dmem(input clk, output wire[31:0] rd,
            input we,
            input wire[31:0] a,
            input wire[31:0] wd);

    reg[31:0] RAM[63:0];
    assign rd = RAM[a[31:2]]; // word aligned

    // write to memory operation
    always @(posedge clk) begin
        if (we)
            RAM[a[31:2]] <= wd;
    end

endmodule