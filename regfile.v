module regfile(input wire clk,       output wire[31:0] rd1,
               input wire[31:0] wd3, output wire[31:0] rd2,
               input wire we,        output wire[31:0] debug,
               input wire[4:0] a1,
               input wire[4:0] a2,
               input wire[4:0] a3);

    reg[31:0] REG[31:0];

    initial begin
        REG[0] = 32'b0;
    end

    assign rd1 = (we && a3 == a1) ? ((a3 == 0) ? 0 : wd3) : REG[a1];
    assign rd2 = (we && a3 == a2) ? ((a3 == 0) ? 0 : wd3) : REG[a2];

    always @(posedge clk) begin
        if (we && a3 != 0)
            REG[a3] <= wd3;
        // $display("Reg[a3] = %d, wd3 = %d, rd2 = %d, a3 = %d, a2 = %d", REG[2], wd3, rd2, a3, a2);
    end

endmodule

