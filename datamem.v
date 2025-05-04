module dmem(input clk, output wire[31:0] rd
            input we,
            input wire[31:0] a,
            input wire[31:0] wd);

    reg[31:0] RAM[63:0];
    assign rd = RAM[a[31:2]]; // word aligned

    always_ff @(posedge clk)
        RAM[a[31:2]] = wd ? we : rd;

endmodule