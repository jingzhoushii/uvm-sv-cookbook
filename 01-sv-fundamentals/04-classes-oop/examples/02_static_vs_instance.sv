// ============================================================================
// SystemVerilog 静态变量 vs 实例变量 - 常见错误演示
// ============================================================================
// 本文件演示新手常犯的错误：静态变量误用
// ============================================================================

`timescale 1ns/1ps

// ============================================================================
// ❌ 错误示例：静态变量
// 所有实例共享同一个 count 变量
// ============================================================================
class bad_example;
    static int count;  // ⚠️ 静态变量：所有对象共享
    
    function new(string name="bad");
        count++;  // 每次创建对象都会增加同一个变量
    endfunction
    
    function void print();
        $display("%s: count=%0d (shared!)", name, count);
    endfunction
endclass

// ============================================================================
// ✅ 正确示例：实例变量
// 每个对象有独立的 count 变量
// ============================================================================
class good_example;
    int count;  // ✅ 实例变量：每个对象独立
    
    function new(string name="good");
        count++;  // 只增加当前对象的 count
    endfunction
    
    function void print();
        $display("%s: count=%0d (independent)", name, count);
    endfunction
endclass

// ============================================================================
// 测试模块
// ============================================================================
module tb_static_vs_instance;
    initial begin
        $display("========================================");
        $display("  静态变量 vs 实例变量 演示");
        $display("========================================");
        
        // 测试错误示例
        $display("\n--- ❌ 静态变量（错误用法）---");
        bad_example bad1 = new("obj1");
        bad1.print();  // count=1
        bad_example bad2 = new("obj2");
        bad2.print();  // count=2（共享！）
        $display("问题：两个对象共享同一个 count！");
        
        // 测试正确示例
        $display("\n--- ✅ 实例变量（正确用法）---");
        good_example good1 = new("obj1");
        good1.print();  // count=1
        good_example good2 = new("obj2");
        good2.print();  // count=1（独立！）
        $display("正确：每个对象有独立的 count！");
        
        $display("\n========================================");
        $display("  关键区别");
        $display("========================================");
        $display("static: 所有实例共享");
        $display("实例变量: 每个实例独立");
        $display("========================================");
        
        #100;
        $finish;
    end
endmodule
