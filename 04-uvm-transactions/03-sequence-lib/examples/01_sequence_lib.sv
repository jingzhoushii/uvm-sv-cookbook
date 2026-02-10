// ============================================================================
// @file    : 01_sequence_lib.sv
// @brief   : 序列库演示
// @note    : 展示常用序列的封装
// ============================================================================

`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit rw;  // 0=read, 1=write
    `uvm_object_utils_begin(txn)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// ---------- 基础序列库 ----------

// 1. 读序列
class read_seq extends uvm_sequence#(txn);
    `uvm_object_utils(read_seq)
    
    int num_reads = 1;
    bit [31:0] base_addr;
    
    function new(string name = "read_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        repeat (num_reads) begin
            txn tr;
            tr = txn::type_id::create("tr");
            start_item(tr);
            tr.rw = 0;
            tr.addr = base_addr + $random % 16;
            tr.data = 0;
            finish_item(tr);
        end
    endtask
endclass

// 2. 写序列
class write_seq extends uvm_sequence#(txn);
    `uvm_object_utils(write_seq)
    
    int num_writes = 1;
    bit [31:0] base_addr;
    
    function new(string name = "write_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        repeat (num_writes) begin
            txn tr;
            tr = txn::type_id::create("tr");
            start_item(tr);
            tr.rw = 1;
            tr.addr = base_addr + $random % 16;
            tr.data = $random;
            finish_item(tr);
        end
    endtask
endclass

// 3. BURST 序列
class burst_seq extends uvm_sequence#(txn);
    `uvm_object_utils(burst_seq)
    
    int burst_len = 4;
    bit [31:0] start_addr;
    
    function new(string name = "burst_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        for (int i = 0; i < burst_len; i++) begin
            txn tr;
            tr = txn::type_id::create("tr");
            start_item(tr);
            tr.rw = 1;
            tr.addr = start_addr + i * 4;
            tr.data = $random;
            finish_item(tr);
        end
    endtask
endclass

// 4. 随机序列
class random_seq extends uvm_sequence#(txn);
    `uvm_object_utils(random_seq)
    
    int count = 10;
    
    function new(string name = "random_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        repeat (count) begin
            txn tr;
            tr = txn::type_id::create("tr");
            start_item(tr);
            void'(tr.randomize());
            finish_item(tr);
        end
    endtask
endclass

// ---------- 虚拟序列库 ----------

// 测试序列：组合多个序列
class test_seq extends uvm_sequence#(txn);
    `uvm_object_utils(test_seq)
    
    task body();
        read_seq rseq;
        write_seq wseq;
        burst_seq bseq;
        
        // 写初始化
        $display("[%0t] [TEST] Write initialization", $time);
        wseq = new("wseq");
        wseq.num_writes = 8;
        wseq.base_addr = 32'h1000;
        wseq.start(null);
        
        // 读回验证
        $display("[%0t] [TEST] Read back", $time);
        rseq = new("rseq");
        rseq.num_reads = 8;
        rseq.base_addr = 32'h1000;
        rseq.start(null);
        
        // BURST 测试
        $display("[%0t] [TEST] BURST", $time);
        bseq = new("bseq");
        bseq.burst_len = 16;
        bseq.start_addr = 32'h2000;
        bseq.start(null);
    endtask
endclass

module tb_sequence_lib;
    
    initial begin
        $display("========================================");
        $display("  Sequence Library Demo");
        $display("========================================");
        
        test_seq tseq;
        tseq = new("tseq");
        tseq.start(null);
        
        #100;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_sequence_lib); end
endmodule
