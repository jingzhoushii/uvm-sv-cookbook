// ============================================================================
// @file    : base_test.sv
// @brief   : AXI 基础测试
// @note    : 启动测试序列
// ============================================================================

`timescale 1ns/1ps

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    
    axi_env                   env;
    axi_config                cfg;
    axi_base_seq             seq;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 创建配置
        cfg = axi_config::type_id::create("cfg");
        cfg.is_active = UVM_ACTIVE;
        cfg.num_transactions = 20;
        uvm_config_db#(axi_config)::set(this, "*", "cfg", cfg);
        
        // 创建环境
        env = axi_env::type_id::create("env", this);
        
        // 创建序列
        seq = axi_base_seq::type_id::create("seq");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        phase.raise_objection(this);
        
        // 启动序列
        seq.start(env.agent.sequencer);
        
        #100;
        phase.drop_objection(this);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), "Test completed", UVM_LOW)
    endtask
    
endclass : base_test
