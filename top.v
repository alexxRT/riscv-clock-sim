
module top(input wire clk,           output wire[31:0] WriteData,
           input wire reset,         output wire[31:0] DataAdr,
                                     output wire[31:0] PC,
                                     output wire[31:0] Instr,
                                     output wire Zero,
                                     output wire PCSrc,
                                     output wire Jump,
                                     output wire MemWrite);

    // wire[31:0] PC;
    // wire[31:0] Instr;
    wire[31:0] ReadData;

    // instantiate processor and memories
    riscvsingle rvsingle(.clk(clk), .reset(reset), .Instr(Instr), .ReadData(ReadData),
                        .PC(PC),
                        .ALUResult(DataAdr),
                        .MemWrite(MemWrite),
                        .PCSrc(PCSrc),
                        .Zero(Zero),
                        .Jump(Jump),
                        .WriteData(WriteData));

    // intstantiate both memories - instr and data
    imem imem(.a(PC), .rd(Instr));

    dmem dmem(.clk(clk), .we(MemWrite), .a(DataAdr),
              .wd(WriteData), .rd(ReadData));

endmodule