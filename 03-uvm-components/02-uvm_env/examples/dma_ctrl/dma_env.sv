// ============================================================================
// @file    : dma_env.sv
// @brief   : DMA 环境
// ============================================================================
`timescale 1ns/1ps

class dma_env extends uvm_env;
    `uvm_component_utils(dma_env)
    
    dma_config cfg;
    dma_driver drv;
    dma_monitor mon;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        cfg = dma_config::type_id::create("cfg");
        void'(cfg.randomize());
        
        drv = dma_driver::type_id::create("drv", this);
        mon = dma_monitor::type_id::create("mon", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.ap.connect(drv.seq_item_port);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #1000;
        phase.drop_objection(this);
    endtask
endclass : dma_env
