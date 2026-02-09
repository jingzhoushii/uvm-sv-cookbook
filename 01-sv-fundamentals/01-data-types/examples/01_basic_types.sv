// ============================================================
// File: 01_basic_types.sv
// Description: SystemVerilog 基本数据类型示例
// ============================================================

`timescale 1ns/1ps

module basic_types_demo;
    
    // 2态类型
    bit         bit_var;
    bit [7:0]   byte_var;
    int         int_var;
    
    // 4态类型
    logic       logic_var;
    integer     int_var;
    
    initial begin
        $display("========================================");
        $display("  Basic Types Demo");
        $display("========================================");
        $display("");
        
        $display("--- 2态类型初始值 (应为 0) ---");
        $display("bit_var = %b", bit_var);
        $display("byte_var = %0d", byte_var);
        $display("");
        
        $display("--- 4态类型初始值 (应为 X) ---");
        $display("logic_var = %b", logic_var);
        $display("");
        
        bit_var = 1'b1;
        byte_var = 255;
        int_var = 1000;
        
        $display("--- 赋值后 ---");
        $display("bit_var = %b", bit_var);
        $display("byte_var = %0d", byte_var);
        $display("int_var = %0d", int_var);
        $display("");
        
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    
endmodule
