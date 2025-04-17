`timescale 1ns / 1ps

module EX_tb;

    // Testbench signals
    reg clk, reset, FlushE;
    reg RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    reg [2:0] ALUControlD;
    reg [1:0] ResultSrcD, ImmSrcD;
    reg [4:0] rdD, rs1D, rs2D;
    reg [31:0] RD1D, RD2D, PCD, ImmExtD, PCplus4D;
    reg [31:0] SrcAE, SrcBE;
    
    wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
    wire [2:0] ALUControlE;
    wire [1:0] ResultSrcE;
    wire [4:0] rdE, rs1E, rs2E;
    wire [31:0] RD1E, RD2E, PCE, ImmExtE, PCplus4E, PCTargetE, ALUResultE;
    wire ZeroE, PCSrcE;

    // Instantiate the EX_stage module
    EX_stage uut (
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
        .rdD(rdD),
        .rs1D(rs1D),
        .rs2D(rs2D),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .PCD(PCD),
        .ImmExtD(ImmExtD),
        .PCplus4D(PCplus4D),
        .SrcAE(SrcAE),
        .SrcBE(SrcBE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .ResultSrcE(ResultSrcE),
        .rdE(rdE),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .ImmExtE(ImmExtE),
        .PCplus4E(PCplus4E),
        .PCTargetE(PCTargetE),
        .ALUResultE(ALUResultE),
        .ZeroE(ZeroE),
        .PCSrcE(PCSrcE)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle every 5ns for a 10ns clock period
    end

    // Initial block to apply test vectors
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        FlushE = 0;
        RegWriteD = 0;
        MemWriteD = 0;
        JumpD = 0;
        BranchD = 0;
        ALUSrcD = 0;
        ALUControlD = 3'b000;  // Example ALU control value (for ADD)
        ResultSrcD = 2'b00;
        ImmSrcD = 2'b00;
        rdD = 5'b00000;
        rs1D = 5'b00001;
        rs2D = 5'b00010;
        RD1D = 32'h00000010;
        RD2D = 32'h00000020;
        PCD = 32'h00400000;
        ImmExtD = 32'h00000004;
        PCplus4D = 32'h00400004;
        SrcAE = 32'h00000010;
        SrcBE = 32'h00000020;

        // Apply reset
        #10 reset = 1;
        #10 reset = 0;

        // Test case 1: Normal operation without any flush or stall
        #10 RegWriteD = 1; MemWriteD = 1; JumpD = 1; BranchD = 1; ALUSrcD = 1;
        #10 ALUControlD = 3'b010;  // Example ALU control for SUB
        #10 rdD = 5'b00011;        // Test with destination register
        #10 SrcAE = 32'h00000010;  // First operand
        #10 SrcBE = 32'h00000005;  // Second operand (for ALU test)
        
        // Monitor signals during test case 1
        #10 $display("Time=%0t | ALUResultE=%h | ZeroE=%b | PCTargetE=%h | PCSrcE=%b", $time, ALUResultE, ZeroE, PCTargetE, PCSrcE);

        // Test case 2: Test with FlushE
        #10 FlushE = 1;  // Apply flush signal
        #10 SrcAE = 32'h00000030;  // Change input values
        #10 SrcBE = 32'h00000020;

        // Monitor signals during test case 2
        #10 $display("Time=%0t | ALUResultE=%h | ZeroE=%b | PCTargetE=%h | PCSrcE=%b", $time, ALUResultE, ZeroE, PCTargetE, PCSrcE);

        // Test case 3: Test ALU with different operands
        #10 FlushE = 0;  // Disable flush
        #10 SrcAE = 32'h00000020;  // Test with new values
        #10 SrcBE = 32'h00000010;  // Test with different operands
        #10 ALUControlD = 3'b100;  // Test ALU with AND operation
        
        // Monitor signals during test case 3
        #10 $display("Time=%0t | ALUResultE=%h | ZeroE=%b | PCTargetE=%h | PCSrcE=%b", $time, ALUResultE, ZeroE, PCTargetE, PCSrcE);

        // Wait for simulation to complete
        #50 $stop;
    end

    // Monitor the outputs
    initial begin
        $monitor("Time=%0t | RegWriteE=%b | MemWriteE=%b | JumpE=%b | BranchE=%b | ALUSrcE=%b | ALUControlE=%b | ResultSrcE=%b | ALUResultE=%h | ZeroE=%b | PCTargetE=%h | PCSrcE=%b", 
                 $time, RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, ALUControlE, ResultSrcE, ALUResultE, ZeroE, PCTargetE, PCSrcE);
    end

endmodule
