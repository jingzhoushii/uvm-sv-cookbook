// ============================================================================
// @file    : mem_transaction.sv
// @brief   : 内存事务
// ============================================================================
`timescale 1ns/1ps

class mem_transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit rw;  // 0=read, 1=write
    int delay;
    
    `uvm_object_utils_begin(mem_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
        `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint defaults {
        addr inside {[0:32'hFFFF]};
        delay inside {[0:10]};
    }
    
    function new(string name = "mem_transaction");
        super.new(name);
    endfunction
endclass : mem_transaction
