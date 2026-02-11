// ============================================================================
// Base Library - 通用工具类
// ============================================================================

`timescale 1ns/1ps

// ============================================================================
// 工具函数包
// ============================================================================

package base_utils;
    
    // 打印数组
    function void print_array(string name, bit [31:0] arr[]);
        $display("%s: ", name);
        foreach (arr[i]) $display("  [%0d] = 0x%0h", i, arr[i]);
    endfunction
    
    // 计算校验和
    function bit [7:0] calc_checksum(bit [7:0] data[]);
        bit [8:0] sum = 0;
        foreach (data[i]) sum += data[i];
        return sum[7:0];
    endfunction
    
    // 延时转换
    function real ns_to_clk(real ns, real period);
        return ns / period;
    endfunction
    
endpackage

// ============================================================================
// 基础配置对象
// ============================================================================

class base_config extends uvm_object;
    rand bit [31:0] addr_base;
    rand bit [31:0] addr_range;
    rand int         timeout;
    
    `uvm_object_utils_begin(base_config)
    `uvm_field_int(addr_base, UVM_ALL_ON)
    `uvm_field_int(addr_range, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// ============================================================================
// 序列基类
// ============================================================================

class base_seq extends uvm_sequence#(base_trans);
    `uvm_object_utils(base_seq)
    
    int repeat_count = 1;
    
    virtual task body();
        repeat(repeat_count) begin
            `uvm_do(req)
        end
    endtask
endclass

endmodule
