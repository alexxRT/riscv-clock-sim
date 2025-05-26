module regfile(input wire clk,       output wire[31:0] rd1,
               input wire[31:0] wd3, output wire[31:0] rd2,
               input wire we,
               input wire[4:0] a1,
               input wire[4:0] a2,
               input wire[4:0] a3);

    reg[31:0] REG[31:0];

    initial begin
        REG[0] = 32'b0;
    end

    assign rd1 = REG[a1];
    assign rd2 = REG[a2];

    always @(negedge clk) begin
        if (we && a3 != 0)
            REG[a3] <= wd3;
        // $display("Reg[a3] = %d, wd3 = %d, rd2 = %d, a3 = %d, a2 = %d", REG[2], wd3, rd2, a3, a2);
    end

endmodule

