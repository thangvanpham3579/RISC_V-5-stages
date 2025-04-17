`timescale 1ns / 1ps

module MEM_tb;

    // Testbench signals
    reg clk, reset;
    reg RegWriteE, MemWriteE;
    reg [1:0] ResultSrcE;
    reg [4:0] rdE;
    reg [31:0] PCplus4E, ALUResultE, SrcBE;
    
    wire RegWriteM, MemWriteM;
    wire [1:0] ResultSrcM;
    wire [4:0] rdM;
    wire [31:0] PCplus4M, ALUResultM, WriteDataM;
    wire [31:0] ReadDataM;

    // Instantiate the MEM_stage module
    MEM_stage uut (
        .clk(clk),
        .reset(reset),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .rdE(rdE),
        .PCplus4E(PCplus4E),
        .ALUResultE(ALUResultE),
        .SrcBE(SrcBE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .rdM(rdM),
        .PCplus4M(PCplus4M),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .ReadDataM(ReadDataM)
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
        RegWriteE = 0;
        MemWriteE = 0;
        ResultSrcE = 2'b00;
        rdE = 5'b00000;
        PCplus4E = 32'h00400000;
        ALUResultE = 32'h00001000;
        SrcBE = 32'h000000FF;

        // Apply reset
        #10 reset = 1;
        #10 reset = 0;

        // Test case 1: Normal operation without memory write
        #10 RegWriteE = 1; MemWriteE = 0; ResultSrcE = 2'b01; rdE = 5'b00011; // Example values
        #10 ALUResultE = 32'h00001010; SrcBE = 32'h00000020;

        // Monitor signals during test case 1
        #10 $display("Time=%0t | ReadDataM=%h | ALUResultM=%h | WriteDataM=%h | RegWriteM=%b | MemWriteM=%b", $time, ReadDataM, ALUResultM, WriteDataM, RegWriteM, MemWriteM);

        // Test case 2: Memory write operation
        #10 MemWriteE = 1; ResultSrcE = 2'b10; // Enable memory write
        #10 ALUResultE = 32'h00400000; SrcBE = 32'h12345678;  // Test with different values for ALU result and data

        // Monitor signals during test case 2
        #10 $display("Time=%0t | ReadDataM=%h | ALUResultM=%h | WriteDataM=%h | RegWriteM=%b | MemWriteM=%b", $time, ReadDataM, ALUResultM, WriteDataM, RegWriteM, MemWriteM);

        // Test case 3: Test result source selection
        #10 ResultSrcE = 2'b11; // Test with a different result source
        #10 ALUResultE = 32'h00000000; SrcBE = 32'h00000010;

        // Monitor signals during test case 3
        #10 $display("Time=%0t | ReadDataM=%h | ALUResultM=%h | WriteDataM=%h | RegWriteM=%b | MemWriteM=%b", $time, ReadDataM, ALUResultM, WriteDataM, RegWriteM, MemWriteM);

        // Wait for simulation to complete
        #50 $stop;
    end

    // Monitor the outputs
    initial begin
        $monitor("Time=%0t | RegWriteM=%b | MemWriteM=%b | ResultSrcM=%b | rdM=%h | ALUResultM=%h | WriteDataM=%h", 
                 $time, RegWriteM, MemWriteM, ResultSrcM, rdM, ALUResultM, WriteDataM);
    end

endmodule
