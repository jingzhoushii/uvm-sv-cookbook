// ============================================================================
// @file    : 01_component.sv
// @brief   : uvm_component 基础
// @note    : 展示组件生命周期和层次结构
// ============================================================================

`timescale 1ns/1ps

// 最基础的 UVM 组件
class my_component extends uvm_component;
    `uvm_component_utils(my_component)
    
    string name;
    int level;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        this.name = name;
        
        // 计算层次级别
        if (parent == null) begin
            level = 0;
        end else begin
            level = parent.get_depth();
        end
        
        $display("[%0t] [%s] new() - level=%0d", 
                 $time, get_full_name(), level);
    endfunction
    
    // 获取层次深度
    virtual function int get_depth();
        return get_depth_recursive(0);
    endfunction
    
    protected function int get_depth_recursive(int current);
        uvm_component parent = get_parent();
        if (parent == null)
            return current;
        else
            return parent.get_depth_recursive(current + 1);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("[%0t] [%s] build_phase()", $time, get_full_name());
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("[%0t] [%s] connect_phase()", $time, get_full_name());
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        $display("[%0t] [%s] run_phase()", $time, get_full_name());
        #50;
        phase.drop_objection(this);
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("[%0t] [%s] report_phase()", $time, get_full_name());
    endfunction
endclass

// 嵌套组件
class nested_component extends uvm_component;
    `uvm_component_utils(nested_component)
    
    my_component child;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // 创建子组件
        child = my_component::type_id::create("child", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        $display("[%0t] [%s] run_phase()", $time, get_full_name());
        #50;
        phase.drop_objection(this);
    endtask
endclass

module tb_component;
    
    initial begin
        $display("========================================");
        $display("  uvm_component Demo");
        $display("========================================");
        $display("");
        
        // 创建嵌套层次结构
        my_component top;
        nested_component middle;
        my_component child1, child2;
        
        top = my_component::type_id::create("top", null);
        middle = nested_component::type_id::create("middle", top);
        child1 = my_component::type_id::create("child1", middle);
        child2 = my_component::type_id::create("child2", top);
        
        $display("");
        $display("--- Component Hierarchy ---");
        top.print();
        
        #200;
        
        $display("");
        $display("========================================");
        $display("  component Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_component);
    end
    
endmodule
