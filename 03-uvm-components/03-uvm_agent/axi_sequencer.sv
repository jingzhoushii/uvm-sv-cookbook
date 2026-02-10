// ============================================================================
// @file    : axi_sequencer.sv
// @brief   : AXI Sequencer
// @note    : 序列仲裁和事务分发
// ============================================================================

`timescale 1ns/1ps

class axi_sequencer extends uvm_sequencer#(axi_transaction);
    `uvm_component_utils(axi_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
endclass : axi_sequencer
