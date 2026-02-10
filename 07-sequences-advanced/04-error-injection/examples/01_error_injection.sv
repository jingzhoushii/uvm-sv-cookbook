// ============================================================================
// @file    : 01_error_injection.sv
// @brief   : 错误注入演示
// @note    : 展示边界条件和错误场景
// ============================================================================

`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    bit error;  // 错误注入标志
    `uvm_object_utils_begin(txn)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(error, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// 错误注入序列
class error_inject_seq extends uvm_sequence#(txn);
    `uvm_object_utils(error_inject_seq)
    
    int error_count;
    
    task body();
        // 正常事务
        repeat (5) begin
            txn tr; tr = txn::type_id::create("tr");
            start_item(tr);
            void'(tr.randomize() with { addr inside {[0:100]}; });
            tr.error = 0;
            finish_item(tr);
        end
        
        // 注入错误
        $display("[%0t] [SEQ] Injecting errors...", $time);
        
        repeat (3) begin
            txn tr; tr = txn::type_id::create("tr");
            start_item(tr);
            tr.error = 1;
            tr.addr = 32'hFFFF_FFFF;  // 无效地址
            finish_item(tr);
            error_count++;
        end
        
        // 恢复
        repeat (5) begin
            txn tr; tr = txn::type_id::create("tr");
            start_item(tr);
            void'(tr.randomize());
            tr.error = 0;
            finish_item(tr);
        end
        
        `uvm_info(get_type_name(), 
            $sformatf("Injected %0d errors", error_count), UVM_LOW)
    endtask
endclass

module tb_error_injection;
    initial begin
        $display("========================================");
        $display("  Error Injection Demo");
        $display("========================================");
        
        error_inject_seq seq;
        seq = new("seq");
        seq.start(null);
        
        #200;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_error_injection); end
endmodule
