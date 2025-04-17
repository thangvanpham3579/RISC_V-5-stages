`timescale 1ns / 1ps
module WB_stage (
    input clk, reset,
    input RegWriteM,
    input [1:0] ResultSrcM,
    input [4:0] rdM,
    input [31:0] PCplus4M, ALUResultM, ReadDataM,
    
    output [4:0] rdW,
    output [1:0] ResultSrcW,
    output [31:0] ResultW,
    output RegWriteW
);

    // Internal wires from the Fifth register
    wire [31:0] ALUResultW, ReadDataW, PCplus4W;

    // Fifth register (MEM -> WB)
    Fifth_register FIFR (
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

    // Mux to select the final result for WB stage (ALU result, ReadData, or PC+4)
    mux3to1 result_mux (
        .m(ALUResultW),
        .n(ReadDataW),
        .o(PCplus4W),
        .sel(ResultSrcW),
        .out(ResultW)
    );

endmodule

