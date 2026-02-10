// ============================================================================
// @file    : dma_transaction.sv
// @brief   : DMA 事务
// ============================================================================
`timescale 1ns/1ps

class dma_transaction extends uvm_sequence_item;
    rand bit [31:0] src_addr;
    rand bit [31:0] dst_addr;
    rand bit [15:0] length;
    rand bit [2:0]  channel;
    rand bit        burst;
    
    `uvm_object_utils_begin(dma_transaction)
        `uvm_field_int(src_addr, UVM_ALL_ON)
        `uvm_field_int(dst_addr, UVM_ALL_ON)
        `uvm_field_int(length, UVM_ALL_ON)
        `uvm_field_int(channel, UVM_ALL_ON)
        `uvm_field_int(burst, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint defaults {
        src_addr inside {[0:32'hFFFF_FFFF]};
        dst_addr inside {[0:32'hFFFF_FFFF]};
        length inside {[1:1024]};
    }
    
    function new(string name = "dma_transaction");
        super.new(name);
    endfunction
endclass : dma_transaction
