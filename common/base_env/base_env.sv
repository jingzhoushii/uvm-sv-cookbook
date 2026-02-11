// ============================================================================
// Base Environment - 基础 UVM 骨架
// ============================================================================

`timescale 1ns/1ps

// 基础环境配置
class base_env_cfg extends uvm_object;
    bit has_agent;
    int agent_count;
    
    `uvm_object_utils_begin(base_env_cfg)
    `uvm_field_int(has_agent, UVM_ALL_ON)
    `uvm_field_int(agent_count, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// 基础环境
class base_env extends uvm_env;
    `uvm_component_utils(base_env)
    
    base_env_cfg cfg;
    base_agent  agt;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (cfg.has_agent)
            agt = base_agent::type_id::create("agt", this);
    endfunction
endclass

// 基础 Agent
class base_agent extends uvm_agent;
    `uvm_component_utils(base_agent)
    
    base_driver  drv;
    base_monitor mon;
    uvm_sequencer#(base_trans) seqr;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = base_driver::type_id::create("drv", this);
        mon = base_monitor::type_id::create("mon", this);
        seqr = uvm_sequencer#(base_trans)::type_id::create("seqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

// 基础 Driver
class base_driver extends uvm_driver#(base_trans);
    `uvm_component_utils(base_driver)
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done(req);
        end
        phase.drop_objection(this);
    endtask
    virtual task drive(base_trans t);
    endtask
endclass

// 基础 Monitor
class base_monitor extends uvm_monitor;
    `uvm_component_utils(base_monitor)
    uvm_analysis_port#(base_trans) ap;
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
    endtask
endclass

// 基础 Transaction
class base_trans extends uvm_sequence_item;
    `uvm_object_utils_begin(base_trans)
    `uvm_object_utils_end
endclass

endmodule
