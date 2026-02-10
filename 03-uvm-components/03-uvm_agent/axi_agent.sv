// ============================================================================
// @file    : axi_agent.sv
// @brief   : AXI Agent
// @note    : 完整的验证代理组件
// ============================================================================

`timescale 1ns/1ps

class axi_agent extends uvm_agent;
    `uvm_component_utils(axi_agent)
    
    // 配置
    axi_config                 cfg;
    
    // 组件
    axi_driver                driver;
    axi_monitor               monitor;
    axi_sequencer             sequencer;
    
    // 虚拟接口
    virtual axi_if            vif;
    
    // 端口
    uvm_analysis_port#(axi_transaction) ap;
    
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
        
        // 获取接口
        if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", "Cannot get axi_if")
        end
        
        // 设置接口到全局
        uvm_config_db#(virtual axi_if)::set(this, "*", "vif", vif);
        uvm_config_db#(axi_config)::set(this, "*", "cfg", cfg);
        
        // 创建组件
        if (cfg.is_active == UVM_ACTIVE) begin
            driver = axi_driver::type_id::create("driver", this);
            sequencer = axi_sequencer::type_id::create("sequencer", this);
        end
        
        monitor = axi_monitor::type_id::create("monitor", this);
        ap = new("ap", this);
        
        `uvm_info(get_type_name(), 
            $sformatf("Created agent: is_active=%0d", cfg.is_active), 
            UVM_LOW)
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // 连接 Driver 到 Sequencer
        if (cfg.is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
        
        // 连接 Monitor 到 Analysis Port
        monitor.ap.connect(ap);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        // Monitor 会在内部自动运行
    endtask
    
endclass : axi_agent
