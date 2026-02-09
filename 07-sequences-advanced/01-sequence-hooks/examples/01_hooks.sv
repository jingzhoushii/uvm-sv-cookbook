// ============================================================
// File: 01_hooks.sv
// Description: Sequence Hooks 示例
// ============================================================

`timescale 1ns/1ps

class transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "transaction");
        super.new(name);
    endfunction
endclass

class my_sequence extends uvm_sequence#(transaction);
    `uvm_object_utils(my_sequence)
    
    int item_count;
    
    function new(string name = "my_sequence");
        super.new(name);
    endfunction
    
    // Hook: 序列开始前
    virtual task pre_body();
        `uvm_info(get_type_name(), "pre_body() - Starting sequence", UVM_LOW)
        item_count = 0;
    endtask
    
    // 主任务
    virtual task body();
        `uvm_info(get_type_name(), "body() - Generating items", UVM_LOW)
        
        repeat (5) begin
            transaction tr;
            tr = transaction::type_id::create("tr");
            
            // Hook: 每个事务前
            `uvm_info(get_type_name(), "pre_do() - Before item", UVM_LOW)
            
            start_item(tr);
            void'(tr.randomize());
            `uvm_info(get_type_name(), 
                $sformatf("addr=0x%0h data=0x%0h", tr.addr, tr.data), UVM_LOW)
            finish_item(tr);
            
            item_count++;
            
            // Hook: 每个事务后
            `uvm_info(get_type_name(), "post_do() - After item", UVM_LOW)
        end
    endtask
    
    // Hook: 序列结束后
    virtual task post_body();
        `uvm_info(get_type_name(), 
            $sformatf("post_body() - Sequence done, items=%0d", item_count), UVM_LOW)
    endtask
endclass

module tb_hooks;
    
    initial begin
        $display("========================================");
        $display("  Sequence Hooks Demo");
        $display("========================================");
        $display("");
        
        my_sequence seq;
        seq = new("seq");
        
        // 运行序列 (在 null sequencer 上)
        fork
            seq.start(null);
        join_none
        
        #100;
        
        $display("");
        $display("========================================");
        $display("  Hooks Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_hooks);
    end
    
endmodule
