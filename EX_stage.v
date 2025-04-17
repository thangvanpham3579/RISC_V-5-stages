module EX_stage(
    input clk, reset, FlushE,
    input RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD,
    input [2:0] ALUControlD,
    input [1:0] ResultSrcD, ImmSrcD,
    input [4:0] rdD, rs1D, rs2D,
    input [31:0] RD1D, RD2D, PCD, ImmExtD, PCplus4D,
    input [31:0] SrcAE, SrcBE,
    output RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,
    output [2:0] ALUControlE,
    output [1:0] ResultSrcE,
    output [4:0] rdE, rs1E, rs2E,
    output [31:0] RD1E, RD2E, PCE, ImmExtE, PCplus4E, PCTargetE, ALUResultE,
    output ZeroE, PCSrcE
);

    wire [31:0] Src2BE;

    Third_register TR (clk, reset, FlushE, RegWriteD, MemWriteD, JumpD, BranchD,
                       ALUSrcD, ALUControlD, ResultSrcD, ImmSrcD, rdD, RD1D, RD2D, PCD,
                       ImmExtD, PCplus4D, RegWriteE, MemWriteE, JumpE, BranchE,
                       ALUSrcE, ALUControlE, ResultSrcE, rdE, RD1E, RD2E, PCE,
                       ImmExtE, PCplus4E, rs1D, rs2D, rs1E, rs2E);

    mux ALUSrc (SrcBE, ImmExtE, ALUSrcE, Src2BE);
    adder PCplusImm (PCE, ImmExtE, PCTargetE);
    alu ALU (SrcAE, Src2BE, ALUControlE, ZeroE, ALUResultE);
    assign PCSrcE = JumpE | (BranchE & ZeroE);

endmodule
