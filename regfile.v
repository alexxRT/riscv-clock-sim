module regfile(input wire clk,       output wire[31:0] rd1,
               input wire[31:0] wd3, output wire[31:0] rd2,
               input wire we,
               input wire[4:0] a1,
               input wire[4:0] a2,
               input wire[4:0] a3,
               input wire reset
               );

    reg[31:0] REG[31:0];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            REG[i] = 32'b0;
    end

    assign rd1 = REG[a1];
    assign rd2 = REG[a2];

    always @(negedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                REG[i] <= 32'b0;
        end

        else if (we && a3 != 0)
            REG[a3] <= wd3;
    end

endmodule

