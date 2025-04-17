`timescale 1ns / 1ps

module ID_tb;

  // Inputs
  reg clk, reset, clr, en;
  reg [31:0] InstrF, PCF, PCplus4F;
  reg [4:0] rs1, rs2, rd;
  reg [31:0] writedata;
  reg regwrite;
  reg [1:0] immsrc;

  // Outputs
  wire [31:0] InstrD, PCD, PCplus4D;
  wire [31:0] rd1, rd2;
  wire [31:0] imm_data;

  // Instantiate modules
  Second_Register second_reg (
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

  registerfile rf (
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .writedata(writedata),
    .regwrite(regwrite),
    .rd1(rd1),
    .rd2(rd2),
    .clk(clk)
  );

  immext imm_ext (
    .instruction(InstrD),
    .immsrc(immsrc),
    .imm_data(imm_data)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Kh?i t?o
    clk = 0;
    reset = 1; clr = 0; en = 0;
    InstrF = 32'b0; PCF = 0; PCplus4F = 0;
    rs1 = 0; rs2 = 0; rd = 0;
    writedata = 0; regwrite = 0;
    immsrc = 2'b00;

    // Reset vài chu k?
    #10 reset = 0;

    // Ghi giá tr? vào register x1 = CAFEBABE
    rd = 5'd1;
    writedata = 32'hCAFEBABE;
    regwrite = 1;
    #10 regwrite = 0;

    // G?i l?nh addi x2, x1, 5 (I-type)
    InstrF = 32'h00508093;  // opcode=0010011, rd=2, funct3=000, rs1=1, imm=5
    PCF = 32'h00000010;
    PCplus4F = 32'h00000014;
    en = 0; // cho phép c?p nh?t
    immsrc = 2'b00; // I-type
    #10;

    // C?p nh?t rs1 và rs2 t? l?nh
    rs1 = InstrD[19:15];
    rs2 = InstrD[24:20];

    // Gi? giá tr?
    en = 1;
    #10;

    // G?i l?nh S-type: sw x2, 4(x1)
    InstrF = 32'h0020A023;  // opcode=0100011
    PCF = 32'h00000020;
    PCplus4F = 32'h00000024;
    en = 0;
    immsrc = 2'b01;
    #10;

    rs1 = InstrD[19:15];
    rs2 = InstrD[24:20];

    // G?i l?nh B-type: beq x1, x2, -4
    InstrF = 32'h00208663;  // opcode=1100011
    PCF = 32'h00000030;
    PCplus4F = 32'h00000034;
    en = 0;
    immsrc = 2'b10;
    #10;

    rs1 = InstrD[19:15];
    rs2 = InstrD[24:20];

    #20;
    $finish;
  end

endmodule

