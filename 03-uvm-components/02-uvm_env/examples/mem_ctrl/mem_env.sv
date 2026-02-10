// ============================================================================
// @file    : mem_env.sv
// @brief   : 内存验证环境
// ============================================================================
`timescale 1ns/1ps

class mem_env extends uvm_env;
    `uvm_component_utils(mem_env)
    
    mem_config cfg;
    mem_driver drv;
    mem_monitor mon;
    uvm_inorder_class_comparator#(mem_transaction) cmp;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        cfg = mem_config::type_id::create("cfg");
        void'(cfg.randomize());
        uvm_config_db#(mem_config)::set(this, "*", "cfg", cfg);
        
        drv = mem_driver::type_id::create("drv", this);
        mon = mem_monitor::type_id::create("mon", this);
        cmp = uvm_inorder_class_comparator#(mem_transaction)::type_id::create("cmp", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.ap.connect(cmp.before_export);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #1000;
        phase.drop_objection(this);
    endtask
endclass : mem_env
