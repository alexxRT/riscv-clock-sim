module imem(input wire[31:0] a,
            output wire[31:0] rd);

reg[31:0] RAM[63:0];

assign rd = RAM[a[31:2]]; // word aligned

initial begin
    $readmemh("riscvtest.txt", RAM);
end


endmodule