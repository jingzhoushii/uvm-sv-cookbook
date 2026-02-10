// ============================================================================
// @file    : 01_build_phase.sv
// @brief   : build_phase 演示
// @note    : 展示组件创建和 config_db 使用
// ============================================================================

`timescale 1ns/1ps

// 配置类
class my_config extends uvm_object;
    rand int count;
    rand bit [31:0] addr;
    
    `uvm_object_utils_begin(my_config)
        `uvm_field_int(count, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint defaults {
        count inside {[10:100]};
        addr == 32'h1000_0000;
    }
endclass

// Driver 组件
class my_driver extends uvm_driver;
    `uvm_component_utils(my_driver)
    
    int count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        `uvm_info(get_type_name(), "build_phase()", UVM_LOW)
        
        // 【核心】从 config_db 获取配置
        if (!uvm_config_db#(int)::get(this, "", "count", count)) begin
            `uvm_warning("NO_COUNT", "Using default count=10")
            count = 10;
        end
        
        `uvm_info(get_type_name(), 
            $sformatf("Got count=%0d from config_db", count), UVM_LOW)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

// Agent 组件
class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    
    my_driver drv;
    my_config cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        `uvm_info(get_type_name(), "build_phase()", UVM_LOW)
        
        // 【核心】创建子组件
        drv = my_driver::type_id::create("drv", this);
        
        // 创建配置
        cfg = my_config::type_id::create("cfg");
        void'(cfg.randomize());
        uvm_config_db#(my_config)::set(this, "drv", "cfg", cfg);
        
        `uvm_info(get_type_name(), "Created driver and config", UVM_LOW)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

// Env 组件
class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    
    my_agent agent;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        `uvm_info(get_type_name(), "build_phase()", UVM_LOW)
        
        // 创建子组件
        agent = my_agent::type_id::create("agent", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

module tb_build_phase;
    
    initial begin
        $display("========================================");
        $display("  build_phase Demo");
        $display("========================================");
        $display("");
        
        // 在 config_db 中设置配置
        uvm_config_db#(int)::set(null, "agent.drv", "count", 50);
        
        // 创建并运行环境
        my_env env;
        env = my_env::type_id::create("env", null);
        
        #200;
        
        $display("");
        $display("========================================");
        $display("  build_phase Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_build_phase);
    end
    
endmodule
