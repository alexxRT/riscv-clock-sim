
module top(input clk,           output wire[31:0] WriteData,
           input reset,         output wire[31:0] DataAdr
                                output MemWrite);

    reg[31:0] PC = 32'b0;
    reg[31:0] Instr = 32'b0;
    reg[31:0] ReadData = 32'b0;

    // instantiate processor and memories
    riscvsingle rvsingle(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);

    imem imem(PC, Instr);

    dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData);

endmodule