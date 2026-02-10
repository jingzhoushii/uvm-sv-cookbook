// ============================================================================
// @file    : 01_resource_db.sv
// @brief   : uvm_resource_db 演示
// @note    : 与 config_db 不同的配置方式
// ============================================================================

`timescale 1ns/1ps

class my_config extends uvm_object;
    int count;
    string mode;
    
    `uvm_object_utils_begin(my_config)
        `uvm_field_int(count, UVM_ALL_ON)
        `uvm_field_string(mode, UVM_ALL_ON)
    `vm_object_utils_end
endclass

class component_a extends uvm_component;
    `uvm_component_utils(component_a)
    
    my_config cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 使用 resource_db
        if (uvm_resource_db#(my_config)::read_by_name("my_scope", "cfg", cfg)) begin
            `uvm_info(get_type_name(), 
                $sformatf("Got cfg: count=%0d mode=%s", cfg.count, cfg.mode),
                UVM_LOW)
        end else begin
            `uvm_warning("NO_CFG", "Resource not found")
        end
    endtask
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

class component_b extends uvm_component;
    `uvm_component_utils(component_b)
    
    int count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 直接读取
        if (uvm_resource_db#(int)::read_by_name(get_full_name(), "count", count))
            begin
            `uvm_info(get_type_name(), 
                $sformatf("Got count=%0d", count), UVM_LOW)
        end
    endtask
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

module tb_resource_db;
    
    initial begin
        $display("========================================");
        $display("  uvm_resource_db Demo");
        $display("========================================");
        $display("");
        
        // 设置资源
        my_config cfg;
        cfg = my_config::type_id::create("cfg");
        cfg.count = 100;
        cfg.mode = "ACTIVE";
        
        uvm_resource_db#(my_config)::write("my_scope", "cfg", cfg);
        uvm_resource_db#(int)::write("comp_b", "count", 42);
        
        // 创建组件
        component_a comp_a;
        component_b comp_b;
        
        comp_a = component_a::type_id::create("comp_a", null);
        comp_b = component_b::type_id::create("comp_b", null);
        
        #200;
        
        $display("");
        $display("========================================");
        $display("  resource_db Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_resource_db);
    end
    
endmodule
