`timescale 1ns / 1ps

module if_tb;

    // Testbench signals
    reg clk, reset, PCSrcE, StallF;
    reg [31:0] PCTargetE;
    wire [31:0] PCF, InstrF, PCplus4F;

    // Instantiate the IF_stage module
    IF_stage uut (
        .clk(clk),
        .reset(reset),
        .PCSrcE(PCSrcE),
        .StallF(StallF),
        .PCTargetE(PCTargetE),
        .PCF(PCF),
        .InstrF(InstrF),
        .PCplus4F(PCplus4F)
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
        PCSrcE = 0;
        StallF = 0;
        PCTargetE = 32'b0;

        // Apply reset
        #10 reset = 1;
        #10 reset = 0;

        // Test case 1: Normal operation
        #10 PCTargetE = 32'h4; // Target address
        #10 StallF = 0;        // No stall

        // Test case 2: PC Source Selection (PCSrcE = 1)
        #10 PCSrcE = 1;        // Select PCTargetE as next PC value
        #10 PCTargetE = 32'h8;

        // Test case 3: Stall condition (StallF = 1)
        #10 StallF = 1;        // Stall the IF stage

        // Test case 4: Reset and change values
        #10 reset = 1;         // Apply reset
        #10 reset = 0;         // Release reset
        #10 PCTargetE = 32'hC; // Change target address
        #10 StallF = 0;        // Remove stall

        // Test case 5: Changing PCTargetE during operation
        #10 PCTargetE = 32'h10;

        // Test case 6: Test for PCPlus4 calculation
        #10 PCTargetE = 32'h14;

        // Wait for simulation to complete
        #50 $stop;
    end

    // Monitor the outputs
    initial begin
        $monitor("Time=%0t | Reset=%b | PCSrcE=%b | StallF=%b | PCTargetE=%h | PCF=%h | InstrF=%h | PCplus4F=%h",
                 $time, reset, PCSrcE, StallF, PCTargetE, PCF, InstrF, PCplus4F);
    end

endmodule
