// ============================================================
// File: 02_arrays.sv
// Description: SystemVerilog 数组类型示例
// ============================================================

`timescale 1ns/1ps

module arrays_demo;
    
    bit [7:0] mem [0:15];
    int queue [$];
    int dyn_arr[];
    bit [31:0] assoc [string];
    
    int i;
    
    initial begin
        $display("========================================");
        $display("  Arrays Demo");
        $display("========================================");
        $display("");
        
        // 静态数组
        $display("--- 静态数组 ---");
        for (i = 0; i < 5; i++) begin
            mem[i] = i * 10;
            $display("mem[%0d] = 0x%0h", i, mem[i]);
        end
        $display("");
        
        // 队列
        $display("--- 队列 ---");
        queue.push_back(10);
        queue.push_back(20);
        queue.push_back(30);
        $display("入队后: %p", queue);
        $display("出队: %0d", queue.pop_front());
        $display("出队后: %p", queue);
        $display("");
        
        // 动态数组
        $display("--- 动态数组 ---");
        dyn_arr = new[5];
        foreach (dyn_arr[i]) dyn_arr[i] = i * 100;
        foreach (dyn_arr[i]) begin
            $display("dyn_arr[%0d] = %0d", i, dyn_arr[i]);
        end
        $display("");
        
        // 关联数组
        $display("--- 关联数组 ---");
        assoc["key1"] = 100;
        assoc["key2"] = 200;
        foreach (assoc[key]) begin
            $display("%s = %0d", key, assoc[key]);
        end
        $display("");
        
        $display("========================================");
        $display("  Arrays Demo Complete!");
        $display("========================================");
        $finish;
    end
    
endmodule
