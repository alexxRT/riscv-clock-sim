
module top(input wire clk,           output wire[31:0] WriteData,
           input wire reset,         output wire[31:0] DataAdr
                                     output wire MemWrite);

    wire[31:0] PC;
    wire[31:0] Instr;
    wire[31:0] ReadData;

    // instantiate processor and memories
    riscvsingle rvsingle(.clk(clk), .reset(reset), .Instr(Instr), .ReadData(ReadData),
                        .PC(PC),
                        .MemWrite(MemWrite),
                        .DataAdr(DataAdr),
                        .WriteData(WriteData));

    // intstantiate both memories - instr and data
    imem imem(.a(PC), .rd(Instr));

    dmem dmem(.clk(clk), .we(MemWrite), .a(DataAdr),
              .wd(WriteData), .rd(ReadData));

endmodule