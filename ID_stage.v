module ID_stage(
    input clk, reset, FlushD, StallD,
    input [31:0] InstrF, PCF, PCplus4F,
    input [4:0] rdW,
    input [31:0] ResultW,
    input RegWriteW,
    output [31:0] InstrD, PCD, PCplus4D,
    output [31:0] RD1D, RD2D, ImmExtD,
    output [1:0] ResultSrcD, ImmSrcD,
    output [2:0] ALUControlD,
    output RegWriteD, MemWriteD, BranchD, JumpD, ALUSrcD
);

    Second_Register SR (clk, reset, FlushD, StallD, InstrF, PCF, PCplus4F, InstrD, PCD, PCplus4D);
    Control_unit CU (InstrD[6:0], InstrD[14:12], InstrD[30], ALUSrcD, ResultSrcD, ImmSrcD,
                     RegWriteD, MemWriteD, ALUControlD, BranchD, JumpD);
    registerfile RF (InstrD[19:15], InstrD[24:20], rdW, ResultW, RegWriteW, RD1D, RD2D, clk);
    immext Im_Ext (InstrD, ImmSrcD, ImmExtD);

endmodule
