// ============================================================================
// @file    : 01_arbitration.sv
// @brief   : 序列仲裁演示
// @note    : 展示仲裁和锁定机制
// ============================================================================

`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [7:0] id;
    `uvm_object_utils_begin(txn)
        `uvm_field_int(id, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class my_sequencer extends uvm_sequencer#(txn);
    `uvm_component_utils(my_sequencer)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// 高优先级序列
class high_prio_seq extends uvm_sequence#(txn);
    `uvm_object_utils(high_prio_seq)
    int id;
    task body();
        repeat (3) begin
            txn tr; tr = txn::type_id::create("tr");
            start_item(tr); tr.id = id; finish_item(tr);
        end
    endtask
endclass

// 低优先级序列
class low_prio_seq extends uvm_sequence#(txn);
    `uvm_object_utils(low_prio_seq)
    int id;
    task body();
        repeat (3) begin
            txn tr; tr = txn::type_id::create("tr");
            start_item(tr); tr.id = id; finish_item(tr);
        end
    endtask
endclass

// 锁定序列
class locked_seq extends uvm_sequence#(txn);
    `uvm_object_utils(locked_seq)
    task body();
        lock(sequencer);
        repeat (2) begin
            txn tr; tr = txn::type_id::create("tr");
            start_item(tr); tr.id = 100; finish_item(tr);
        end
        unlock(sequencer);
    endtask
endclass

module tb_arbitration;
    initial begin
        $display("========================================");
        $display("  Sequence Arbitration Demo");
        $display("========================================");
        
        my_sequencer sqr;
        sqr = new("sqr", null);
        
        fork
            begin high_prio_seq s; s = new("high"); s.id=1; s.start(sqr); end
            begin low_prio_seq s; s = new("low"); s.id=2; s.start(sqr); end
            begin #100; locked_seq s; s = new("locked"); s.start(sqr); end
        join
        
        #200;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_arbitration); end
endmodule
