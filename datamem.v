module dmem(input clk, output wire[31:0] rd,
            input we,
            input wire[31:0] a,
            input wire[31:0] wd,
            input wire reset
            );

    reg[31:0] RAM[63:0];

    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1)
            RAM[i] = 32'b0;
    end


    assign rd = RAM[a[31:2]]; // word aligned

    // write to memory operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 64; i = i + 1)
                RAM[i] = 32'b0;
        end

       else if (we)
            RAM[a[31:2]] <= wd;
    end

endmodule