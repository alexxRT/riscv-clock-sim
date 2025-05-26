module testbench();

    reg clk = 1'b0;
    reg reset;
    reg btn0 = 1'b0;

    // instantiate device to be tested
    top testdevice(.clk(clk), .btn0(btn0), .reset(reset));

    // initialize test
    initial begin
        reset = 1; #17; reset = 0;
    end


    always begin
        btn0 <= ~btn0; #30;
    end

    // generate clock to sequence tests
    always begin
        clk <= ~clk; #5;
    end


    initial begin
        $dumpvars;
        $display("Test started...");
        #2000
        $finish;
    end


endmodule