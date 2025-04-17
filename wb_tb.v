
`timescale 1ns / 1ps

module wb_tb;

// Các tín hi?u c?n thi?t
reg clk, reset;
reg RegWriteM;
reg [1:0] ResultSrcM;
reg [4:0] rdM;
reg [31:0] PCplus4M, ALUResultM, ReadDataM;

wire RegWriteW;
wire [1:0] ResultSrcW;
wire [4:0] rdW;
wire [31:0] PCplus4W, ALUResultW, ReadDataW;

// Các tín hi?u ??u vào cho mux
reg [31:0] m, n, o;
reg [1:0] sel;
wire [31:0] mux_out;
wire [31:0] mux3_out;

// Kh?i t?o mô-?un Fifth_register
Fifth_register uut (
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
    .ReadDataW(ReadDataW)
);

// Kh?i t?o mô-?un mux
mux u_mux (
    .m(m),
    .n(n),
    .sel(sel),
    .out(mux_out)
);

// Kh?i t?o mô-?un mux3to1
mux3to1 u_mux3to1 (
    .m(m),
    .n(n),
    .o(o),
    .sel(sel),
    .out(mux3_out)
);

// Kh?i t?o ??ng h? và reset
initial begin
    clk = 0;
    reset = 0;
    
    // ??t các tín hi?u ban ??u
    RegWriteM = 1;
    ResultSrcM = 2'b01; // Ví d?, có th? là t? b? nh?
    rdM = 5'b00001; // Rd có giá tr? m?u
    PCplus4M = 32'h00400004;
    ALUResultM = 32'h00000010; // K?t qu? t? ALU
    ReadDataM = 32'h00000020; // D? li?u ??c t? b? nh?
    
    m = 32'hA0A0A0A0; // Giá tr? ??u vào cho mux
    n = 32'hB0B0B0B0;
    o = 32'hC0C0C0C0;
    sel = 2'b01; // Ch?n n trong mux3to1

    // Mô ph?ng
    #5 reset = 1; // Reset h? th?ng
    #5 reset = 0; // H?y reset

    // Th?c hi?n m?t s? thay ??i tín hi?u cho ki?m th?
    #10 RegWriteM = 0;
    #10 ResultSrcM = 2'b10; // Thay ??i ki?u ngu?n d? li?u

    // Ti?n hành mô ph?ng thêm n?u c?n thi?t
    #20 $stop;
end

// T?o ??ng h?
always #5 clk = ~clk; // T?o xung ??ng h? v?i chu k? 10ns

endmodule
