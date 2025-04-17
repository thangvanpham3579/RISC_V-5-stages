module WB_stage(
    input clk, reset,
    input RegWriteM,
    input [1:0] ResultSrcM,
    input [4:0] rdM,
    input [31:0] PCplus4M, ALUResultM, ReadDataM,
    output RegWriteW,
    output [1:0] ResultSrcW,
    output [4:0] rdW,
    output [31:0] PCplus4W, ALUResultW, ReadDataW, ResultW
);

    Fifth_register FIFR (clk, reset, RegWriteM, ResultSrcM, rdM, PCplus4M,
                         RegWriteW, ResultSrcW, rdW, PCplus4W, ALUResultW, ReadDataW,
                         ALUResultM, ReadDataM);
    mux3to1 resultSrc (ALUResultW, ReadDataW, PCplus4W, ResultSrcW, ResultW);

endmodule
