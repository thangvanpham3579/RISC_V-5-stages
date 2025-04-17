
`timescale 1ns / 1ps

module mem_tb;
  // ??nh ngh?a các tín hi?u ??u vào và ??u ra cho các module
  reg clk, reset;
  reg RegWriteE, MemWriteE;
  reg [1:0] ResultSrcE;
  reg [4:0] rdE;
  reg [31:0] PCplus4E, ALUResultE, WriteDataE;
  wire RegWriteM, MemWriteM;
  wire [1:0] ResultSrcM;
  wire [4:0] rdM;
  wire [31:0] PCplus4M, ALUResultM, WriteDataM;

  reg [31:0] mem_addr, write_data;
  reg memwrite;
  wire [31:0] read_data;

  // Instantiate Fourth_register module
  Fourth_register uut1 (
    .clk(clk),
    .reset(reset),
    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .ResultSrcE(ResultSrcE),
    .rdE(rdE),
    .PCplus4E(PCplus4E),
    .ALUResultE(ALUResultE),
    .WriteDataE(WriteDataE),
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),
    .rdM(rdM),
    .PCplus4M(PCplus4M),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM)
  );

  // Instantiate datamem module
  datamem uut2 (
    .mem_addr(mem_addr),
    .write_data(write_data),
    .clk(clk),
    .memwrite(memwrite),
    .read_data(read_data)
  );

  // Clock generation
  always #5 clk = ~clk;  // Generate clock signal with period 10ns

  initial begin
    // Kh?i t?o các tín hi?u
    clk = 0;
    reset = 1;
    RegWriteE = 0;
    MemWriteE = 0;
    ResultSrcE = 2'b00;
    rdE = 5'b00000;
    PCplus4E = 32'h00000004;
    ALUResultE = 32'h00000010;
    WriteDataE = 32'hA5A5A5A5;
    mem_addr = 32'h00000010;
    write_data = 32'h5A5A5A5A;
    memwrite = 0;

    // Th?c hi?n reset và ki?m tra giai ?o?n ??u
    #10;
    reset = 0;

    // Th? ghi vào b? nh? và ki?m tra
    #10;
    MemWriteE = 1;
    memwrite = 1;  // Kích ho?t ghi vào b? nh?
    #10;
    MemWriteE = 0;
    memwrite = 0;  // T?t ghi vào b? nh?

    // Ki?m tra vi?c ??c b? nh?
    #10;
    mem_addr = 32'h00000010;  // ??a ch? b? nh? ?? ??c
    #10;

    // Ki?m tra d? li?u sau khi ghi
    #10;
    $display("Mem Read Data: %h", read_data);

    // K?t thúc mô ph?ng sau m?t th?i gian
    #50;
    $finish;
  end

endmodule
