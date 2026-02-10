// ============================================================================
// @file    : mem_seq.sv
// @brief   : 内存测试序列
// ============================================================================
`timescale 1ns/1ps

class mem_seq extends uvm_sequence#(mem_transaction);
    `uvm_object_utils(mem_seq)
    
    int count;
    
    function new(string name = "mem_seq");
        super.new(name);
        count = 10;
    endfunction
    
    virtual task body();
        repeat (count) begin
            mem_transaction tr;
            tr = mem_transaction::type_id::create("tr");
            start_item(tr);
            if (!tr.randomize()) begin
                `uvm_warning("RANDFAIL", "Randomization failed")
            end
            tr.rw = $urandom_range(0, 1);
            finish_item(tr);
        end
    endtask
endclass : mem_seq
