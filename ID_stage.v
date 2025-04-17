`timescale 1ns / 1ps
module ID_stage (
  input clk,
  input reset,
  input clr,
  input en,
  input [31:0] InstrF,
  input [31:0] PCF,
  input [31:0] PCplus4F,
  input [31:0] ResultW,
  input [4:0] RdW,
  input RegWriteW,

  output [31:0] PCD,
  output [31:0] InstrD,
  output [31:0] PCplus4D,
  output [31:0] RD1, RD2,
  output [31:0] ImmD,
  output [2:0] ALUControlD,
  output [1:0] ImmSrcD, ResultSrcD,
  output ALUSrcD, MemWriteD, RegWriteD,
  output BranchD, JumpD
);

  wire [6:0] opcode;
  wire [2:0] funct3;
  wire funct7;
  wire [4:0] rs1, rs2, rd;

  // Trích xu?t các tr??ng t? instruction
  assign opcode = InstrD[6:0];
  assign rd     = InstrD[11:7];
  assign funct3 = InstrD[14:12];
  assign rs1    = InstrD[19:15];
  assign rs2    = InstrD[24:20];
  assign funct7 = InstrD[30];

  // ??ng ký ??u ra
  Second_Register regD (
    .clk(clk),
    .reset(reset),
    .clr(clr),
    .en(en),
    .InstrF(InstrF),
    .PCF(PCF),
    .PCplus4F(PCplus4F),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCplus4D(PCplus4D)
  );

  // ?i?u khi?n l?nh
  Control_unit cu (
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .alusrc(ALUSrcD),
    .resultsrc(ResultSrcD),
    .immsrc(ImmSrcD),
    .regwrite(RegWriteD),
    .memwrite(MemWriteD),
    .alucontrol(ALUControlD),
    .branch(BranchD),
    .jump(JumpD)
  );

  // ??c d? li?u t? thanh ghi
  registerfile rf (
    .rs1(rs1),
    .rs2(rs2),
    .rd(RdW),
    .writedata(ResultW),
    .regwrite(RegWriteW),
    .rd1(RD1),
    .rd2(RD2),
    .clk(clk)
  );

  // M? r?ng immediate
  immext imm_ext (
    .instruction(InstrD),
    .immsrc(ImmSrcD),
    .imm_data(ImmD)
  );

endmodule

