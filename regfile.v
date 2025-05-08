module regfile(input wire clk,       output wire[31:0] rd1,
               input wire[31:0] wd3, output wire[31:0] rd2,
               input wire we,
               input wire[4:0] a1,
               input wire[4:0] a2,
               input wire[4:0] a3);

    reg[31:0] REG[31:0];

    assign rd1 = REG[a1];
    assign rd2 = REG[a2];

    always @(posedge clk) begin
        if (we && a3 != 0)
            REG[a3] <= wd3;
    end

endmodule

