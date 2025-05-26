module display(input clk, input[31:0] word,
               output wire[7:0] AN, output wire[7:0] SEG);
    wire ce1ms;
    reg[3:0] s;
    reg[7:0] an;
    wire[3:0] dig;

    assign dig = (s==0) ? word[3:0]:
                (s==1) ? word[7:4]:
                (s==2) ? word[11:8]:
                (s==3) ? word[15:12]:
                (s==4) ? word[19:16]:
                (s==5) ? word[23:20]:
                (s==6) ? word[27:24]:
                word[31:28];

    assign AN = ~an;

    initial begin
        an = 8'b00000001;
        s = 0;
    end

    always @ (posedge ce1ms) begin
        an <= an == 8'b10000000 ? 8'b1 : an << 1;
        s <= s == 7 ? 0 : s + 1;
    end

    dec7seg seg7(.dig(dig), .seg(SEG[6:0]));

    gen1ms ms(.clk(clk), .ce1ms(ce1ms));

endmodule