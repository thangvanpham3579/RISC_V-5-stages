`timescale 1ns / 1ps

module IF_tb;

  // Inputs
  reg clk;
  reg reset;
  reg enable;
  reg [31:0] PC;

  // Outputs
  wire [31:0] PCF;
  wire [31:0] instruction;

  // Instantiate the modules
  First_register first_reg (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .PC(PC),
    .PCF(PCF)
  );

  instmem imem (
    .instr_addr(PCF),
    .instruction(instruction)
  );

  // Clock generation: 10ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Monitor outputs
    $monitor("Time = %0t | reset = %b | enable = %b | PC = %h | PCF = %h | instruction = %h",
             $time, reset, enable, PC, PCF, instruction);

    // Initialize signals
    reset = 1;
    enable = 0;
    PC = 0;

    // Reset pulse
    #10;
    reset = 0;

    // Fetch a few instructions
    #10 PC = 0;     // Fetch instruction at address 0
    #10 PC = 4;     // Fetch instruction at address 4
    #10 PC = 8;     // Fetch instruction at address 8

    // Simulate enable = 1 (stall)
    enable = 1;
    #10 PC = 12;    // Should hold previous PCF, instruction should remain same

    // Disable stall
    enable = 0;
    #10 PC = 16;    // PCF should update now

    // Finish simulation
    #20;
    $finish;
  end

endmodule

