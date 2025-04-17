`timescale 1ns / 1ps

module pipeline_new (clk, reset);
input clk, reset;

    // IF Stage
    wire [31:0] PCplus4F, PC, PCF, InstrF;
    wire StallF;

    // ID Stage
    wire [31:0] RD1D, RD2D, InstrD, PCD, PCplus4D, ImmExtD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [2:0] ALUControlD;
    wire RegWriteD, MemWriteD, BranchD, JumpD, ALUSrcD;
    wire StallD, FlushD;

    // EX Stage
    wire [31:0] PCTargetE, RD1E, RD2E, PCE, ImmExtE, PCplus4E, SrcAE, SrcBE, Src2BE, ALUResultE;
    wire [2:0] ALUControlE;
    wire [1:0] ResultSrcE;
    wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
    wire ZeroE, PCSrcE;

    // MEM Stage
    wire [31:0] PCplus4M, ALUResultM, WriteDataM, ReadDataM;
    wire RegWriteM, MemWriteM;
    wire [1:0] ResultSrcM;

    // WB Stage
    wire RegWriteW;
    wire [31:0] ResultW, PCplus4W, ALUResultW, ReadDataW;
    wire [1:0] ResultSrcW;
    wire [4:0] rdW, rdE, rdM;

    // IF Stage
    IF_stage IF1 (
        .clk(clk), 
        .reset(reset), 
        .StallF(StallF), 
        .PC(PC), 
        .PCF(PCF), 
        .InstrF(InstrF), 
        .PCplus4F(PCplus4F)
    );

    // ID Stage
    ID_stage ID1 (
        .clk(clk), 
        .reset(reset), 
        .FlushD(FlushD), 
        .StallD(StallD), 
        .InstrF(InstrF), 
        .PCF(PCF), 
        .PCplus4F(PCplus4F), 
        .InstrD(InstrD), 
        .PCD(PCD), 
        .PCplus4D(PCplus4D)
    );

    Control_unit CU (
        .opcode(InstrD[6:0]), 
        .funct3(InstrD[14:12]), 
        .funct7(InstrD[30]), 
        .ALUSrcD(ALUSrcD), 
        .ResultSrcD(ResultSrcD), 
        .ImmSrcD(ImmSrcD), 
        .RegWriteD(RegWriteD), 
        .MemWriteD(MemWriteD), 
        .ALUControlD(ALUControlD), 
        .BranchD(BranchD), 
        .JumpD(JumpD)
    );

    registerfile RF (
        .rs1(InstrD[19:15]), 
        .rs2(InstrD[24:20]), 
        .rd(rdW), 
        .Result(ResultW), 
        .RegWrite(RegWriteW), 
        .RD1(RD1D), 
        .RD2(RD2D), 
        .clk(clk)
    );

    immext Im_Ext (
        .InstrD(InstrD), 
        .ImmSrcD(ImmSrcD), 
        .ImmExtD(ImmExtD)
    );

    // EX Stage
    EX_stage EX1 (
        .clk(clk), 
        .reset(reset), 
        .FlushE(FlushE), 
        .RegWriteD(RegWriteD), 
        .MemWriteD(MemWriteD), 
        .JumpD(JumpD), 
        .BranchD(BranchD), 
        .ALUSrcD(ALUSrcD), 
        .ALUControlD(ALUControlD), 
        .ResultSrcD(ResultSrcD), 
        .ImmSrcD(ImmSrcD), 
        .InstrD(InstrD), 
        .RD1D(RD1D), 
        .RD2D(RD2D), 
        .PCD(PCD), 
        .ImmExtD(ImmExtD), 
        .PCplus4D(PCplus4D), 
        .RegWriteE(RegWriteE), 
        .MemWriteE(MemWriteE), 
        .JumpE(JumpE), 
        .BranchE(BranchE), 
        .ALUSrcE(ALUSrcE), 
        .ALUControlE(ALUControlE), 
        .ResultSrcE(ResultSrcE), 
        .rdE(rdE), 
        .RD1E(RD1E), 
        .RD2E(RD2E), 
        .PCE(PCE), 
        .ImmExtE(ImmExtE), 
        .PCplus4E(PCplus4E)
    );

    // MEM Stage
    MEM_stage MEM1 (
        .clk(clk), 
        .reset(reset), 
        .RegWriteM(RegWriteM), 
        .MemWriteM(MemWriteM), 
        .ResultSrcM(ResultSrcM), 
        .rdM(rdM), 
        .PCplus4M(PCplus4M), 
        .RegWriteE(RegWriteE), 
        .MemWriteE(MemWriteE), 
        .ResultSrcE(ResultSrcE), 
        .rdE(rdE), 
        .PCplus4E(PCplus4E), 
        .ALUResultE(ALUResultE), 
        .SrcBE(SrcBE), 
        .ALUResultM(ALUResultM), 
        .WriteDataM(WriteDataM)
    );

    datamem DM (
        .Address(ALUResultM), 
        .WriteData(WriteDataM), 
        .clk(clk), 
        .MemWrite(MemWriteM), 
        .ReadData(ReadDataM)
    );

    // WB Stage
    WB_stage WB1 (
        .clk(clk), 
        .reset(reset), 
        .RegWriteM(RegWriteM), 
        .ResultSrcM(ResultSrcM), 
        .rdM(rdM), 
        .PCplus4M(PCplus4M), 
        .RegWriteW(RegWriteW), 
        .ResultSrcW(ResultSrcW), 
        .rdW(rdW), 
        .PCplus4W(PCplus4W), 
        .ALUResultW(ALUResultW), 
        .ReadDataW(ReadDataW), 
        .ALUResultM(ALUResultM), 
        .ReadDataM(ReadDataM)
    );

    // Hazard Unit
    Hazard_unit HU (
        .rs1(InstrD[19:15]), 
        .rs2(InstrD[24:20]), 
        .rs1E(rs1E), 
        .rs2E(rs2E), 
        .rdM(rdM), 
        .rdW(rdW), 
        .RegWriteM(RegWriteM), 
        .RegWriteW(RegWriteW), 
        .rdE(rdE), 
        .ResultSrcE(ResultSrcE), 
        .PCSrcE(PCSrcE), 
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE), 
        .StallD(StallD), 
        .StallF(StallF), 
        .FlushE(FlushE), 
        .FlushD(FlushD)
    );

    // Forwarding Unit
    mux3to1 SrcA (
        .in0(RD1E), 
        .in1(ResultW), 
        .in2(ALUResultM), 
        .select(ForwardAE), 
        .out(SrcAE)
    );

    mux3to1 SrcB (
        .in0(RD2E), 
        .in1(ResultW), 
        .in2(ALUResultM), 
        .select(ForwardBE), 
        .out(SrcBE)
    );

endmodule
