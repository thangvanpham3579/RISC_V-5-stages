`timescale 1ns / 1ps
module IF_stage (
  input clk,
  input reset,
  input StallF,                   // tín hi?u stall ?? gi? nguyên PC
  input [31:0] PC,                // ??a ch? hi?n t?i t? PC MUX
  output [31:0] PCF,              // ??a ch? PC sau khi ???c l?u
  output [31:0] InstrF,           // instruction output
  output [31:0] PCplus4F          // PC + 4
);

  // Tính PC + 4
  adder add_pc (
    .s(PC),
    .t(32'd4),
    .u(PCplus4F)
  );

  // Thanh ghi PCF ?? l?u PC hi?n t?i
  First_register pc_reg (
    .clk(clk),
    .reset(reset),
    .enable(StallF),
    .PC(PC),
    .PCF(PCF)
  );

  // L?y l?nh t? b? nh? l?nh
  instmem imem (
    .instr_addr(PC),
    .instruction(InstrF)
  );

endmodule

