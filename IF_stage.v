module IF_stage(
    input clk, reset, PCSrcE, StallF,
    input [31:0] PCTargetE,
    output [31:0] PCF, InstrF, PCplus4F
);

    wire [31:0] PC;

    mux PCSrc (PCplus4F, PCTargetE, PCSrcE, PC);
    First_register FR (clk, reset, StallF, PC, PCF);
    instmem IM (PCF, InstrF);
    adder PCplus4 (PCF, 32'b100, PCplus4F);

endmodule
