// ============================================================================
// @file    : dma_config.sv
// @brief   : DMA 配置
// ============================================================================
`timescale 1ns/1ps

class dma_config extends uvm_object;
    rand int num_channels;
    rand int max_transfer_size;
    
    `uvm_object_utils_begin(dma_config)
        `uvm_field_int(num_channels, UVM_ALL_ON)
        `uvm_field_int(max_transfer_size, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint defaults {
        num_channels == 4;
        max_transfer_size == 4096;
    }
endclass : dma_config
