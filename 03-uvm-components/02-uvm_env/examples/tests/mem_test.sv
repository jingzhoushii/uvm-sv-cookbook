// ============================================================================
// @file    : mem_test.sv
// @brief   : 内存测试用例
// ============================================================================
`timescale 1ns/1ps

class mem_test extends uvm_test;
    `uvm_component_utils(mem_test)
    
    mem_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = mem_env::type_id::create("env", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        mem_seq seq;
        phase.raise_objection(this);
        
        seq = mem_seq::type_id::create("seq");
        seq.count = 20;
        seq.start(env.drv);
        
        #100;
        phase.drop_objection(this);
    endtask
endclass : mem_test
