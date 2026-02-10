// ============================================================================
// @file    : tb_env.sv
// @brief   : UVM 环境基类
// ============================================================================

`timescale 1ns/1ps

class tb_env extends uvm_env;
    `uvm_component_utils(tb_env)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

`endif // TB_ENV_SV
