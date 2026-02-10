// ============================================================================
// @file    : axi_write_seq.sv
// @brief   : AXI 写序列
// @note    : 生成写事务
// ============================================================================

`timescale 1ns/1ps

class axi_write_seq extends uvm_sequence#(axi_transaction);
    `uvm_object_utils(axi_write_seq)
    
    rand bit [31:0]  addr;
    rand int         length;
    rand int         count;
    
    constraint defaults {
        addr inside {[0:32'hFFFF_FFFF]};
        length inside {[1:16]};
        count inside {[1:50]};
    }
    
    function new(string name = "axi_write_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        repeat (count) begin
            axi_transaction tr;
            tr = axi_transaction::type_id::create("tr");
            start_item(tr);
            tr.rw_type = WRITE;
            tr.addr = addr;
            tr.len = length - 1;
            if (!tr.randomize() with {
                addr == local::addr;
                len == local::length - 1;
            }) begin
                `uvm_warning("RANDFAIL", "Randomization failed")
            end
            finish_item(tr);
        end
    endtask
endclass : axi_write_seq
