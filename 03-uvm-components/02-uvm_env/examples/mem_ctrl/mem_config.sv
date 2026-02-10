// ============================================================================
// @file    : mem_config.sv
// @brief   : 内存配置
// ============================================================================
`timescale 1ns/1ps

class mem_config extends uvm_object;
    rand int mem_size;
    rand int access_latency;
    bit [31:0] base_addr;
    
    `uvm_object_utils_begin(mem_config)
        `uvm_field_int(mem_size, UVM_ALL_ON)
        `uvm_field_int(access_latency, UVM_ALL_ON)
        `uvm_field_int(base_addr, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint defaults {
        mem_size == 1024;
        access_latency inside {[1:5]};
        base_addr == 32'h0000_0000;
    }
endclass : mem_config
