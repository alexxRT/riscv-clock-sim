
module hazard(input wire[4:0] Rs1E,  output reg[1:0] ForwardAE,
              input wire[4:0] Rs2E,  output wire lwStall,
              input wire[4:0] RdE,   output wire StallF,
              input wire[4:0] Rs1D,  output wire FlushE,
              input wire[4:0] Rs2D,  output wire StallD,
              input wire RegWriteW,  output wire FlushD,
              input wire RegWriteM,  output reg[1:0] ForwardBE,
              input wire[1:0] ResultSrcE
              input wire PCSrcE);

    // forward alu execution
    always @(*) begin
        if ((Rs1E == RdM) & RegWriteM) & (Rs1E != 0)
            ForwardAE = 2'b10;
        else if ((Rs1E == RdW) & RegWriteW) & (Rs1E != 0)
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;
    end

    // forward branch  execution
    always @(*) begin
        if ((Rs2E == RdM) & RegWriteM) & (Rs2E != 0)
            ForwardAE = 2'b10;
        else if ((Rs2E == RdW) & RegWriteW) & (Rs2E != 0)
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end


    assign lwStall = ResultSrc & ((Rs1D == RdE) | (Rs2D == RdE));
    assign StallD = lwStall;
    assign StallF = lwStall;

    assign FlushD = PCSrcE;
    assign FlushE = lwStall | PCSrcE;

endmodule
