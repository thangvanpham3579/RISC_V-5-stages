`timescale 1ns / 1ps
module pipeline_new_tb;
  reg clk, reset;
  pipeline_new dut (
    .clk(clk),
    .reset(reset)
  );
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  initial begin
    reset = 1;
    #10 reset = 0;  
    #100 $stop; 
  end
  initial begin
    $monitor("Time: %0t | clk: %b | reset: %b", $time, clk, reset);
  end

endmodule
