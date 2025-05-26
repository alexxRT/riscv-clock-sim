module gen1ms (input clk, output wire ce1ms);
    parameter Fclk=50000000;
    parameter F1kHz=1000;

    reg[15:0]cb_ms = 0;
    assign ce1ms = (cb_ms==0);

    always @(posedge clk) begin
        cb_ms <= ce1ms? (Fclk / F1kHz - 1) : cb_ms-1;
    end
endmodule