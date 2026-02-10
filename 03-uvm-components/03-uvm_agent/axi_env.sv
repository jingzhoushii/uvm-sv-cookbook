// ============================================================================
// @file    : axi_env.sv
// @brief   : AXI 验证环境
// @note    : 组装所有组件
// ============================================================================

`timescale 1ns/1ps

class axi_env extends uvm_env;
    `uvm_component_utils(axi_env)
    
    // 配置
    axi_config                 cfg;
    
    // 组件
    axi_agent                  agent;
    axi_scoreboard             sb;
    
    // 参考模型
    // axi_ref_model             refm;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 获取配置
        if (!uvm_config_db#(axi_config)::get(this, "", "cfg", cfg)) begin
            `uvm_warning("NO_CFG", "Using default config")
            cfg = axi_config::type_id::create("cfg");
        end
        
        // 创建组件
        agent = axi_agent::type_id::create("agent", this);
        sb = axi_scoreboard::type_id::create("sb", this);
        
        `uvm_info(get_type_name(), "Environment built", UVM_LOW)
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // 连接 Monitor 到 Scoreboard
        agent.ap.connect(sb.act_imp);
        
        // 连接参考模型到 Scoreboard
        // refm.ap.connect(sb.exp_imp);
    endfunction
    
endclass : axi_env
