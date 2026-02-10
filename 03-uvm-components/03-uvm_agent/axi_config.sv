// ============================================================================
// @file    : axi_config.sv
// @brief   : AXI Agent 配置类
// @note    : Agent 的配置参数
// ============================================================================

`timescale 1ns/1ps

class axi_config extends uvm_object;
    // 配置参数
    rand bit                is_active;
    rand int                num_transactions;
    rand bit [31:0]        base_addr;
    rand int                max_transaction_length;
    
    // 时序参数
    int                     setup_time;
    int                     hold_time;
    
    `uvm_object_utils_begin(axi_config)
        `uvm_field_int(is_active, UVM_ALL_ON)
        `uvm_field_int(num_transactions, UVM_ALL_ON)
        `uvm_field_int(base_addr, UVM_ALL_ON)
        `uvm_field_int(max_transaction_length, UVM_ALL_ON)
        `uvm_field_int(setup_time, UVM_ALL_ON)
        `uvm_field_int(hold_time, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint defaults {
        is_active == UVM_ACTIVE;
        num_transactions inside {[10:100]};
        base_addr == 32'h0000_0000;
        max_transaction_length == 16;
        setup_time == 1;
        hold_time == 1;
    }
    
    function new(string name = "axi_config");
        super.new(name);
    endfunction
endclass : axi_config
