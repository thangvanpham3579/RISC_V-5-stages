`timescale 1ns / 1ps
module MEM_stage (
    input clk, reset,
    input RegWriteE, MemWriteE,
    input [1:0] ResultSrcE,
    input [4:0] rdE,
    input [31:0] PCplus4E, ALUResultE, SrcBE,

    output [31:0] ALUResultM, WriteDataM, ReadDataM,
    output [31:0] PCplus4M,
    output [1:0] ResultSrcM,
    output [4:0] rdM,
    output RegWriteM, MemWriteM
);

    // Internal signals from pipeline register (EX/MEM)
    wire [31:0] ALUResultM_int, WriteDataM_int;
    wire [31:0] PCplus4M_int;
    wire [1:0]  ResultSrcM_int;
    wire [4:0]  rdM_int;
    wire        RegWriteM_int, MemWriteM_int;

    // Pipeline Register: EX -> MEM
    Fourth_register FRM (
        .clk(clk),
        .reset(reset),
        .RegWriteM(RegWriteM_int),
        .MemWriteM(MemWriteM_int),
        .ResultSrcM(ResultSrcM_int),
        .rdM(rdM_int),
        .PCplus4M(PCplus4M_int),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .rdE(rdE),
        .PCplus4E(PCplus4E),
        .ALUResultE(ALUResultE),
        .WriteDataE(SrcBE),
        .ALUResultM(ALUResultM_int),
        .WriteDataM(WriteDataM_int)
    );

    // Data Memory
    datamem DM (
        .mem_addr(ALUResultM_int),
        .write_data(WriteDataM_int),
        .clk(clk),
        .memwrite(MemWriteM_int),
        .read_data(ReadDataM)
    );

    // Output assignments
    assign ALUResultM  = ALUResultM_int;
    assign WriteDataM  = WriteDataM_int;
    assign PCplus4M    = PCplus4M_int;
    assign ResultSrcM  = ResultSrcM_int;
    assign rdM         = rdM_int;
    assign RegWriteM   = RegWriteM_int;
    assign MemWriteM   = MemWriteM_int;

endmodule

