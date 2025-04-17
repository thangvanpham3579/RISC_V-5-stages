
`timescale 1ns / 1ps

module EX_tb;

    // ??nh ngh?a c�c t�n hi?u
    reg [31:0] a, b;              // ??u v�o c?a ALU
    reg [2:0] aluoperation;       // T�n hi?u ?i?u khi?n ALU
    reg [1:0] aluop;              // T�n hi?u ?i?u khi?n ALU t? ALUControl
    reg [2:0] funct3;             // T�n hi?u funct3 t? instruction
    reg funct7;                   // T�n hi?u funct7 t? instruction
    wire [31:0] result;           // K?t qu? ALU
    wire zero;                    // C? zero c?a ALU
    wire [2:0] operation;         // K?t qu? ?i?u khi?n ALU

    // Kh?i t?o c�c module
    alu uut_alu (
        .a(a),
        .b(b),
        .aluoperation(aluoperation),
        .zero(zero),
        .result(result)
    );
    
    alucontrol uut_alucontrol (
        .aluop(aluop),
        .funct3(funct3),
        .funct7(funct7),
        .operation(operation)
    );

    // C�c t�n hi?u ??u v�o
    initial begin
        // Kh?i t?o c�c gi� tr? ban ??u
        a = 32'b0;
        b = 32'b0;
        aluoperation = 3'b000;   // C?ng
        aluop = 2'b00;           // S? d?ng aluop=00 cho ph�p c?ng
        funct3 = 3'b000;
        funct7 = 1'b0;
        
        // Ch?y c�c tr??ng h?p th? nghi?m
        #10; a = 32'hA; b = 32'h5;  aluoperation = 3'b000;  // Test C?ng
        #10; a = 32'hA; b = 32'h5;  aluoperation = 3'b001;  // Test Tr?
        #10; a = 32'hA; b = 32'h5;  aluoperation = 3'b010;  // Test AND
        #10; a = 32'hA; b = 32'h5;  aluoperation = 3'b011;  // Test OR
        #10; a = 32'hA; b = 32'h5;  aluoperation = 3'b101;  // Test Less Than
        #10; a = 32'hA; b = 32'h5;  aluoperation = 3'b000;  // Test C?ng l?i
        
        // Th? ALUControl
        #10; aluop = 2'b01; funct3 = 3'b000; funct7 = 1'b0;  // Test v?i ALUControl
        #10; aluop = 2'b10; funct3 = 3'b010; funct7 = 1'b0;  // Test v?i ALUControl
        #10; aluop = 2'b10; funct3 = 3'b111; funct7 = 1'b1;  // Test v?i ALUControl
        
        #10; $finish; // K?t th�c m� ph?ng
    end

    // Quan s�t c�c t�n hi?u
    initial begin
        $monitor("Time: %t, a: %h, b: %h, aluoperation: %b, result: %h, zero: %b, operation: %b",
                 $time, a, b, aluoperation, result, zero, operation);
    end

endmodule
