// ============================================================================
// Factory create vs new 对比
// ============================================================================

`timescale 1ns/1ps

class my_driver extends uvm_driver;
    `uvm_component_utils(my_driver)
    
    function new(string name="my_driver");
        super.new(name);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("DRV", "Running", UVM_LOW)
        #100;
        phase.drop_objection(this);
    endtask
endclass

class test extends uvm_test;
    `uvm_component_utils(test)
    
    // ✅ factory 创建
    my_driver d1;
    
    // ❌ 直接 new（无法 override）
    my_driver d2;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // ✅ factory
        d1 = my_driver::type_id::create("d1", this);
        
        // ❌ 直接 new（危险）
        d2 = new("d2");
        
        `uvm_info("BUILD", "Components created", UVM_LOW)
    endfunction
endclass

module tb_factory_basics;
    initial begin
        $display("Factory create vs new");
        run_test();
        #200; $finish;
    end
endmodule
