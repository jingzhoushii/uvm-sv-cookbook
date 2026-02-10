// ============================================================================
// @file    : 01_pipeline.sv
// @brief   : 流水化序列演示
// @note    : 展示流水线设计模式
// ============================================================================

`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [7:0] id;
    `uvm_object_utils_begin(txn)
        `uvm_field_int(id, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// 流水化 Driver
class pipeline_driver extends uvm_driver#(txn);
    `uvm_component_utils(pipeline_driver)
    
    int busy_count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        forever begin
            seq_item_port.get(req);
            busy_count++;
            $display("[%0t] [%s] Processing id=%0d (busy=%0d)", 
                     $time, get_full_name(), req.id, busy_count);
            #20;  // 处理延迟
            busy_count--;
            seq_item_port.item_done();
        end
        
        phase.drop_objection(this);
    endtask
endclass

// 流水化序列
class pipeline_seq extends uvm_sequence#(txn);
    `uvm_object_utils(pipeline_seq)
    
    int depth = 4;
    int total_items = 16;
    
    task body();
        txn qs[$];
        
        // 预创建事务
        repeat (total_items) begin
            txn tr; tr = txn::type_id::create("tr");
            void'(tr.randomize());
            qs.push_back(tr);
        end
        
        // 流水线发送
        fork
            begin
                foreach (qs[i]) begin
                    start_item(qs[i]);
                    $display("[%0t] [%s] Send id=%0d", 
                             $time, get_type_name(), qs[i].id);
                    finish_item(qs[i]);
                end
            end
        join
        
        `uvm_info(get_type_name(), "Pipeline complete", UVM_LOW)
    endtask
endclass

module tb_pipeline;
    initial begin
        $display("========================================");
        $display("  Pipelined Sequences Demo");
        $display("========================================");
        
        pipeline_driver drv;
        pipeline_seq seq;
        
        drv = new("drv", null);
        
        seq = new("seq");
        fork seq.start(drv); join
        
        #500;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_pipeline); end
endmodule
