module testbench();

    reg clk = 1'b0;
    reg reset;
    wire[31:0] WriteData;
    wire[31:0] DataAdr;
    wire[31:0] PC;
    wire[31:0] Instr;
    wire MemWrite;
    wire Jump;
    wire PCSrc;
    wire Zero;

    // instantiate device to be tested
    top testdevice(.clk(clk), .reset(reset),
                   .PC(PC),
                   .Instr(Instr),
                   .WriteData(WriteData),
                   .DataAdr(DataAdr),
                   .Zero(Zero),
                   .Jump(Jump),
                   .PCSrc(PCSrc),
                   .MemWrite(MemWrite));

    // initialize test
    initial begin
        reset = 1; #22; reset = 0;
    end

    // generate clock to sequence tests
    always begin
        clk <= ~clk; #5;
    end

    // check results
    always @(negedge clk) begin
        if(MemWrite) begin
            if(DataAdr === 100 & WriteData === 25) begin
                $display("Simulation succeeded");
            end else if (DataAdr !== 96) begin
                $display("Simulation failed");
            end
        end
    end


    initial begin
        $dumpvars;
        $display("Test started...");
        #1000 $finish;
    end


endmodule