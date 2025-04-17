`timescale 1ns / 1ps

module WB_tb;

    // Testbench signals
    reg clk, reset;
    reg RegWriteM;
    reg [1:0] ResultSrcM;
    reg [4:0] rdM;
    reg [31:0] PCplus4M, ALUResultM, ReadDataM;
    
    wire RegWriteW;
    wire [1:0] ResultSrcW;
    wire [4:0] rdW;
    wire [31:0] PCplus4W, ALUResultW, ReadDataW, ResultW;

    // Instantiate the WB_stage module
    WB_stage uut (
        .clk(clk),
        .reset(reset),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .rdM(rdM),
        .PCplus4M(PCplus4M),
        .ALUResultM(ALUResultM),
        .ReadDataM(ReadDataM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .rdW(rdW),
        .PCplus4W(PCplus4W),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .ResultW(ResultW)
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
        RegWriteM = 0;
        ResultSrcM = 2'b00;
        rdM = 5'b00000;
        PCplus4M = 32'h00400000;
        ALUResultM = 32'h00001000;
        ReadDataM = 32'h000000FF;

        // Apply reset
        #10 reset = 1;
        #10 reset = 0;

        // Test case 1: Normal operation with ALU result
        #10 RegWriteM = 1; ResultSrcM = 2'b00; rdM = 5'b00011; // Example values
        #10 ALUResultM = 32'h00001010; ReadDataM = 32'h00000020;

        // Monitor signals during test case 1
        #10 $display("Time=%0t | ResultW=%h | ALUResultW=%h | ReadDataW=%h | RegWriteW=%b", $time, ResultW, ALUResultW, ReadDataW, RegWriteW);

        // Test case 2: Using ReadDataM as result
        #10 ResultSrcM = 2'b01; // Select ReadDataM as the result
        #10 ALUResultM = 32'h00000000; ReadDataM = 32'h12345678;

        // Monitor signals during test case 2
        #10 $display("Time=%0t | ResultW=%h | ALUResultW=%h | ReadDataW=%h | RegWriteW=%b", $time, ResultW, ALUResultW, ReadDataW, RegWriteW);

        // Test case 3: Using PCplus4M as result
        #10 ResultSrcM = 2'b10; // Select PCplus4M as the result
        #10 ALUResultM = 32'h00000000; ReadDataM = 32'h00000000; PCplus4M = 32'h00400004;

        // Monitor signals during test case 3
        #10 $display("Time=%0t | ResultW=%h | ALUResultW=%h | ReadDataW=%h | RegWriteW=%b", $time, ResultW, ALUResultW, ReadDataW, RegWriteW);

        // Wait for simulation to complete
        #50 $stop;
    end

    // Monitor the outputs
    initial begin
        $monitor("Time=%0t | RegWriteW=%b | ResultSrcW=%b | rdW=%h | ALUResultW=%h | ReadDataW=%h | ResultW=%h", 
                 $time, RegWriteW, ResultSrcW, rdW, ALUResultW, ReadDataW, ResultW);
    end

endmodule
