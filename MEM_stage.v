module MEM_stage(
    input clk, reset,
    input RegWriteE, MemWriteE,
    input [1:0] ResultSrcE,
    input [4:0] rdE,
    input [31:0] PCplus4E, ALUResultE, SrcBE,
    output RegWriteM, MemWriteM,
    output [1:0] ResultSrcM,
    output [4:0] rdM,
    output [31:0] PCplus4M, ALUResultM, WriteDataM,
    output [31:0] ReadDataM
);

    Fourth_register FRR (clk, reset, RegWriteM, MemWriteM, ResultSrcM, rdM, PCplus4M,
                         RegWriteE, MemWriteE, ResultSrcE, rdE, PCplus4E, ALUResultE, SrcBE,
                         ALUResultM, WriteDataM);
    datamem DM (ALUResultM, WriteDataM, clk, MemWriteM, ReadDataM);

endmodule
