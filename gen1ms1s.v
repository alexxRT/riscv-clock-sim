module gen1ms1s (input clk, input ce, output wire ce1s);
    parameter F1kHz=1000;
    parameter F1Hz=1;

    reg[9:0]cb_Nms = 0;
    assign ce1s = ce & (cb_Nms==0);

    always @(posedge clk) if (ce) begin
        cb_Nms <= ce1s? (F1kHz/F1Hz)-1 : cb_Nms-1;
    end
endmodule