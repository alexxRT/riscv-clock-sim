module testbench();

    reg clk = 1'b0;
    reg reset;

    // instantiate device to be tested
    top testdevice(.clk(clk), .reset(reset));

    // initialize test
    initial begin
        reset = 1; #17; reset = 0;
    end

    // generate clock to sequence tests
    always begin
        clk <= ~clk; #5;
    end


    initial begin
        $dumpvars;
        $display("Test started...");
        #1000
        $finish;
    end


endmodule