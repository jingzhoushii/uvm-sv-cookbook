// ============================================================================
// Factory 调试技巧
// ============================================================================

`timescale 1ns/1ps

class base_comp extends uvm_component;
    `uvm_component_utils(base_comp)
    function new(string name="base");
        super.new(name);
    endfunction
endclass

class new_comp extends uvm_component;
    `uvm_component_utils(new_comp)
    function new(string name="new");
        super.new(name);
    endfunction
endclass

class test extends uvm_test;
    `uvm_component_utils(test)
    base_comp c;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        base_comp::set_type_override_by_type(new_comp::get_type());
        c = base_comp::type_id::create("c", this);
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        
        `uvm_info("DEBUG", "=== Factory Info ===", UVM_LOW)
        
        // ✅ 打印 override 信息
        print_override_info();
        
        // ✅ 获取类型名称
        `uvm_info("DEBUG", $sformatf("Type: %s", c.get_type_name()), UVM_LOW)
        
        // ✅ 验证类型
        if (c.get_type_name() == "new_comp")
            `uvm_info("OK", "Override verified!", UVM_LOW)
    endfunction
endclass

module tb_debug;
    initial begin
        $display("Factory Debug Demo");
        run_test();
        #200; $finish;
    end
endmodule
