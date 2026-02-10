// ============================================================================
// @file    : 01_env.sv
// @brief   : uvm_env 演示
// @note    : 展示验证环境容器
// ============================================================================

`timescale 1ns/1ps

// 子组件
class sub_component extends uvm_component;
    `uvm_component_utils(sub_component)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #50;
        phase.drop_objection(this);
    endtask
endclass

// UVM 环境（验证环境容器）
class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    
    // 子组件实例
    sub_component comp_a;
    sub_component comp_b;
    sub_component comp_c;
    
    // 配置
    int num_transactions = 100;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        $display("[%0t] [%s] new()", $time, get_full_name());
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("[%0t] [%s] build_phase()", $time, get_full_name());
        
        // 获取配置
        void'(uvm_config_db#(int)::get(this, "", "num_tx", num_transactions));
        
        // 创建子组件
        comp_a = sub_component::type_id::create("comp_a", this);
        comp_b = sub_component::type_id::create("comp_b", this);
        comp_c = sub_component::type_id::create("comp_c", this);
        
        `uvm_info(get_type_name(), 
            $sformatf("Created 3 sub-components, num_tx=%0d", num_transactions),
            UVM_LOW)
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("[%0t] [%s] connect_phase()", $time, get_full_name());
        // 连接 TLM 端口...
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        $display("[%0t] [%s] run_phase() - Starting", $time, get_full_name());
        phase.raise_objection(this);
        
        // 环境协调逻辑
        $display("[%0t] [%s] Coordinating %0d transactions", 
                 $time, get_full_name(), num_transactions);
        
        #100;
        phase.drop_objection(this);
        $display("[%0t] [%s] run_phase() - Finished", $time, get_full_name());
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("[%0t] [%s] report_phase()", $time, get_full_name());
    endfunction
endclass

module tb_env;
    
    initial begin
        $display("========================================");
        $display("  uvm_env Demo");
        $display("========================================");
        $display("");
        
        // 设置配置
        uvm_config_db#(int)::set(null, "*", "num_tx", 500);
        
        // 创建环境
        my_env env;
        env = my_env::type_id::create("env", null);
        
        $display("");
        $display("--- Environment Structure ---");
        env.print();
        
        #300;
        
        $display("");
        $display("========================================");
        $display("  env Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_env);
    end
    
endmodule
