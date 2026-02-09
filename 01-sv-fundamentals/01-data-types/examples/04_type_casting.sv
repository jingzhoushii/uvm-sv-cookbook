// ============================================================
// File: 04_type_casting.sv
// Description: SystemVerilog 类型转换示例
// ============================================================

`timescale 1ns/1ps

module type_casting_demo;
    
    bit [7:0]   b8;
    bit [31:0]  b32;
    int         i;
    
    initial begin
        $display("========================================");
        $display("  Type Casting Demo");
        $display("========================================");
        $display("");
        
        $display("--- 隐式转换 ---");
        b8 = 8'hFF;
        b32 = b8;  // 符号扩展: 0000_00FF
        $display("8-bit 0x%0h → 32-bit 0x%0h", b8, b32);
        $display("");
        
        $display("--- 显式转换 ---");
        b32 = 32'h1234_5678;
        b8 = 8'(b32);  // 截断: 78
        $display("32-bit 0x%0h → 8-bit 0x%0h", b32, b8);
        $display("");
        
        $display("--- 符号转换 ---");
        b32 = 32'hFFFF_FF80;  // 4294967040 unsigned
        i = $signed(b32);       // -128 signed
        $display("unsigned 0x%0h → signed %0d", b32, i);
        $display("");
        
        $display("========================================");
        $display("  Type Casting Demo Complete!");
        $display("========================================");
        $finish;
    end
    
endmodule
