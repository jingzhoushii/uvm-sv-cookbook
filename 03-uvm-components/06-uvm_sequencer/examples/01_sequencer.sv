// ============================================================================
// @file    : 01_sequencer.sv
// @brief   : Sequencer 仲裁演示
// @note    : 展示序列仲裁和锁定机制
// ============================================================================

`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [7:0] addr;
    `uvm_object_utils_begin(txn)
        `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// Sequencer
class my_sequencer extends uvm_sequencer#(txn);
    `uvm_component_utils(my_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Driver
class my_driver extends uvm_driver#(txn);
    `uvm_component_utils(my_driver)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        forever begin
            seq_item_port.get(req);
            $display("[%0t] [%s] Got: addr=0x%0h", 
                     $time, get_full_name(), req.addr);
            #10;
        end
        
        phase.drop_objection(this);
    endtask
endclass

// 序列 1 - 普通序列
class seq1 extends uvm_sequence#(txn);
    `uvm_object_utils(seq1)
    
    task body();
        repeat (3) begin
            txn tr;
            tr = txn::type_id::create("tr");
            start_item(tr);
            void'(tr.randomize() with { addr inside {[0:10]}; });
            finish_item(tr);
        end
    endtask
endclass

// 序列 2 - 带锁序列
class seq2 extends uvm_sequence#(txn);
    `uvm_object_utils(seq2)
    
    task body();
        // 请求锁
        lock(sequencer);
        $display("[%0t] [seq2] Acquired lock", $time);
        
        repeat (2) begin
            txn tr;
            tr = txn::type_id::create("tr");
            start_item(tr);
            void'(tr.randomize() with { addr inside {[100:110]}; });
            finish_item(tr);
        end
        
        unlock(sequencer);
        $display("[%0t] [seq2] Released lock", $time);
    endtask
endclass

// 序列 3 - 优先级序列
class seq3 extends uvm_sequence#(txn);
    `uvm_object_utils(seq3)
    
    int id;
    
    task body();
        set_arbitration(SEQ_ARB_WEIGHTED);
        
        repeat (3) begin
            txn tr;
            tr = txn::type_id::create("tr");
            start_item(tr);
            void'(tr.randomize() with { addr inside {[200:210]}; });
            finish_item(tr);
        end
    endtask
endclass

module tb_sequencer;
    
    initial begin
        $display("========================================");
        $display("  Sequencer Demo");
        $display("========================================");
        
        my_sequencer sqr;
        my_driver drv;
        
        sqr = my_sequencer::type_id::create("sqr", null);
        drv = my_driver::type_id::create("drv", null);
        drv.seq_item_port.connect(sqr.seq_item_export);
        
        // 启动序列
        fork
            begin
                seq1 s1;
                s1 = seq1::type_id::create("s1");
                s1.start(sqr);
            end
            begin
                #50;
                seq2 s2;
                s2 = seq2::type_id::create("s2");
                s2.start(sqr);
            end
            begin
                #100;
                seq3 s3;
                s3 = seq3::type_id::create("s3");
                s3.start(sqr);
            end
        join
        
        #300;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_sequencer); end
endmodule
