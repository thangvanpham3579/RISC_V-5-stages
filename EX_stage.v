`timescale 1ns / 1ps
module EX_stage(
    input clk, reset, FlushE,
    input RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD,
    input [2:0] ALUControlD,
    input [1:0] ResultSrcD,
    input [4:0] rdD, rs1D, rs2D,
    input [31:0] RD1D, RD2D, PCD, ImmExtD, PCplus4D,
    input [31:0] ResultW, ALUResultM,
    input [1:0] ForwardAE, ForwardBE,

    output RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,
    output [2:0] ALUControlE,
    output [1:0] ResultSrcE,
    output [4:0] rdE, rs1E, rs2E,
    output [31:0] ALUResultE, PCTargetE, PCplus4E,
    output ZeroE
);

    wire [31:0] RD1E, RD2E, PCE, ImmExtE;
    wire [31:0] SrcAE, SrcBE, Src2BE;

    // ID/EX Pipeline Register
    Third_register TR (
        clk, reset, FlushE,
        RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD,
        ALUControlD, ResultSrcD, 2'b00,  // ImmSrcD không dùng ? ?ây
        rdD, RD1D, RD2D, PCD, ImmExtD, PCplus4D,
        RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,
        ALUControlE, ResultSrcE,
        rdE, RD1E, RD2E, PCE, ImmExtE, PCplus4E,
        rs1D, rs2D, rs1E, rs2E
    );

    // Forwarding MUX for SrcA
    mux3to1 SrcA_mux (
        RD1E, ResultW, ALUResultM, ForwardAE, SrcAE
    );

    // Forwarding MUX for SrcB
    mux3to1 SrcB_mux (
        RD2E, ResultW, ALUResultM, ForwardBE, SrcBE
    );

    // ALUSrc MUX
    mux ALUSrc_mux (
        SrcBE, ImmExtE, ALUSrcE, Src2BE
    );

    // Branch Target Address
    adder PCTarget_adder (
        PCE, ImmExtE, PCTargetE
    );

    // ALU operation
    alu ALU_unit (
        SrcAE, Src2BE, ALUControlE, ZeroE, ALUResultE
    );

endmodule

