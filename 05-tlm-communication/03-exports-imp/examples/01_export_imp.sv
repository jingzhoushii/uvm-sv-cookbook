// ============================================================================
// @file    : 01_export_imp.sv
// @brief   : Export 和 Implementation 演示
// @note    : 展示 TLM 端口实现
// ============================================================================

`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [7:0] data;
    `uvm_object_utils_begin(txn)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// 消费者 - 实现 put 方法
class consumer extends uvm_component;
    `uvm_component_utils(consumer)
    uvm_blocking_put_export#(txn) put_exp;
    
    txn q[$];
    int count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        put_exp = new("put_exp", this);
    endfunction
    
    // 实现 put 方法
    virtual task put(txn tr);
        q.push_back(tr);
        count++;
        $display("[%0t] [%s] Put: data=0x%0h (count=%0d)", 
                 $time, get_full_name(), tr.data, count);
    endtask
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

// 生产者 - 发送数据
class producer extends uvm_component;
    `uvm_component_utils(producer)
    uvm_blocking_put_port#(txn) put_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        put_port = new("put_port", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        repeat (5) begin
            txn tr; tr = txn::type_id::create("tr");
            void'(tr.randomize());
            $display("[%0t] [%s] Trying to put...", $time, get_full_name());
            put_port.put(tr);
            #10;
        end
        
        phase.drop_objection(this);
    endtask
endclass

module tb_export_imp;
    initial begin
        $display("========================================");
        $display("  Export/Implementation Demo");
        $display("========================================");
        
        producer prod;
        consumer cons;
        
        prod = new("prod", null);
        cons = new("cons", null);
        
        // 连接
        prod.put_port.connect(cons.put_exp);
        
        #200;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_export_imp); end
endmodule
