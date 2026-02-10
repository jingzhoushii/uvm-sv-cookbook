// ============================================================================
// @file    : 01_config_object.sv
// @brief   : 配置对象演示
// @note    : 展示复杂配置的封装和传递
// ============================================================================

`timescale 1ns/1ps

// 配置对象
class agent_config extends uvm_object;
    rand bit is_active;
    rand int num_transactions;
    bit [31:0] base_addr;
    
    `uvm_object_utils_begin(agent_config)
        `uvm_field_int(is_active, UVM_ALL_ON)
        `uvm_field_int(num_transactions, UVM_ALL_ON)
        `uvm_field_int(base_addr, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint defaults {
        is_active == 1;
        num_transactions inside {[100:1000]};
    }
endclass

// 组件 A - 使用配置
class component_a extends uvm_component;
    `uvm_component_utils(component_a)
    
    agent_config cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if (!uvm_config_db#(agent_config)::get(this, "", "cfg", cfg)) begin
            `uvm_warning("NO_CFG", "Using default config")
            cfg = agent_config::type_id::create("default_cfg");
        end
        
        `uvm_info(get_type_name(), 
            $sformatf("is_active=%0d, num_tx=%0d, addr=0x%0h",
                     cfg.is_active, cfg.num_transactions, cfg.base_addr),
            UVM_LOW)
    endtask
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

module tb_config_object;
    initial begin
        $display("========================================");
        $display("  Config Object Demo");
        $display("========================================");
        
        // 创建配置
        agent_config cfg;
        cfg = agent_config::type_id::create("cfg");
        cfg.is_active = 1;
        cfg.num_transactions = 500;
        cfg.base_addr = 32'h1000_0000;
        
        // 设置配置
        uvm_config_db#(agent_config)::set(null, "*", "cfg", cfg);
        
        // 创建组件
        component_a comp;
        comp = component_a::type_id::create("comp", null);
        
        #200;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_config_object); end
endmodule
