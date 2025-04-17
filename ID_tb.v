`timescale 1ns / 1ps

module ID_tb;

    // Testbench signals
    reg clk, reset, FlushD, StallD;
    reg [31:0] InstrF, PCF, PCplus4F;
    reg [4:0] rdW;
    reg [31:0] ResultW;
    reg RegWriteW;
    wire [31:0] InstrD, PCD, PCplus4D;
    wire [31:0] RD1D, RD2D, ImmExtD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [2:0] ALUControlD;
    wire RegWriteD, MemWriteD, BranchD, JumpD, ALUSrcD;

    // Instantiate the ID_stage module
    ID_stage uut (
        .clk(clk),
        .reset(reset),
        .FlushD(FlushD),
        .StallD(StallD),
        .InstrF(InstrF),
        .PCF(PCF),
        .PCplus4F(PCplus4F),
        .rdW(rdW),
        .ResultW(ResultW),
        .RegWriteW(RegWriteW),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCplus4D(PCplus4D),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .ImmExtD(ImmExtD),
        .ResultSrcD(ResultSrcD),
        .ImmSrcD(ImmSrcD),
        .ALUControlD(ALUControlD),
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .BranchD(BranchD),
        .JumpD(JumpD),
        .ALUSrcD(ALUSrcD)
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
        FlushD = 0;
        StallD = 0;
        InstrF = 32'h00000000;
        PCF = 32'h00000000;
        PCplus4F = 32'h00000000;
        rdW = 5'b00000;
        ResultW = 32'h00000000;
        RegWriteW = 0;

        // Apply reset
        #10 reset = 1;
        #10 reset = 0;

        // Test case 1: Normal operation with valid instruction
        #10 InstrF = 32'h12345678;   // Sample instruction
        #10 PCF = 32'h00400000;       // Sample PC value
        #10 PCplus4F = 32'h00400004;  // Sample PC+4 value
        #10 rdW = 5'b00001;           // Sample register destination
        #10 ResultW = 32'h1234ABCD;   // Sample result to write back
        #10 RegWriteW = 1;            // Enable writeback
        #10 FlushD = 0;               // No flush
        #10 StallD = 0;               // No stall

        // Monitor signals during test case 1
        #10 $display("Time=%0t | InstrF=%h | PCF=%h | PCplus4F=%h | rdW=%b | ResultW=%h | RegWriteW=%b", $time, InstrF, PCF, PCplus4F, rdW, ResultW, RegWriteW);

        // Test case 2: Check FlushD functionality
        #10 FlushD = 1;               // Apply flush in the ID stage
        #10 StallD = 0;               // No stall during flush
        #10 $display("Time=%0t | FlushD=%b | StallD=%b", $time, FlushD, StallD);

        // Test case 3: Check StallD functionality
        #10 FlushD = 0;               // No flush
        #10 StallD = 1;               // Apply stall in the ID stage
        #10 $display("Time=%0t | FlushD=%b | StallD=%b", $time, FlushD, StallD);

        // Test case 4: Check instruction decoding and register file access
        #10 InstrF = 32'hABCDE123;    // New instruction to test decoding
        #10 PCF = 32'h00400008;       // Update PC value
        #10 PCplus4F = 32'h0040000C;  // Update PC+4 value
        #10 rdW = 5'b00010;           // Update register destination
        #10 ResultW = 32'hAABBCCDD;   // New result to write back
        #10 RegWriteW = 1;            // Enable writeback
        #10 StallD = 0;               // Remove stall
        #10 $display("Time=%0t | InstrF=%h | PCF=%h | PCplus4F=%h | rdW=%b | ResultW=%h | RegWriteW=%b", $time, InstrF, PCF, PCplus4F, rdW, ResultW, RegWriteW);

        // Test case 5: Another valid instruction
        #10 InstrF = 32'hDEADBEEF;
        #10 PCF = 32'h00400010;
        #10 PCplus4F = 32'h00400014;
        #10 rdW = 5'b00011;
        #10 ResultW = 32'hDEADBE01;
        #10 RegWriteW = 1;

        // Wait for simulation to complete
        #50 $stop;
    end

    // Monitor the outputs
    initial begin
        $monitor("Time=%0t | InstrD=%h | PCD=%h | PCplus4D=%h | RD1D=%h | RD2D=%h | ImmExtD=%h | ResultSrcD=%b | ImmSrcD=%b | ALUControlD=%b | RegWriteD=%b | MemWriteD=%b | BranchD=%b | JumpD=%b | ALUSrcD=%b", 
                 $time, InstrD, PCD, PCplus4D, RD1D, RD2D, ImmExtD, ResultSrcD, ImmSrcD, ALUControlD, RegWriteD, MemWriteD, BranchD, JumpD, ALUSrcD);
    end

endmodule
