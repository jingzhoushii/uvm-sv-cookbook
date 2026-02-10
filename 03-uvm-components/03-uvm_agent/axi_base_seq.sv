// ============================================================================
// @file    : axi_base_seq.sv
// @brief   : AXI 基础序列
// @note    : 提供常用序列
// ============================================================================

`timescale 1ns/1ps

class axi_base_seq extends uvm_sequence#(axi_transaction);
    `uvm_object_utils(axi_base_seq)
    
    int                     num_transactions;
    
    function new(string name = "axi_base_seq");
        super.new(name);
        num_transactions = 10;
    endfunction
    
    virtual task body();
        repeat (num_transactions) begin
            axi_transaction tr;
            tr = axi_transaction::type_id::create("tr");
            start_item(tr);
            if (!tr.randomize()) begin
                `uvm_warning("RANDFAIL", "Randomization failed")
            end
            finish_item(tr);
        end
    endtask
endclass : axi_base_seq
