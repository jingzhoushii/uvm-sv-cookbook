// ============================================================================
// Type Override 示例
// ============================================================================

`timescale 1ns/1ps

class base_driver extends uvm_driver;
    `uvm_component_utils(base_driver)
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("BASE", "Base driver", UVM_LOW)
        #100; phase.drop_objection(this);
    endtask
endclass

class new_driver extends uvm_driver;
    `uvm_component_utils(new_driver)
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("NEW", "New driver (overridden!)", UVM_LOW)
        #100; phase.drop_objection(this);
    endtask
endclass

class test extends uvm_test;
    `uvm_component_utils(test)
    base_driver drv;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // ✅ 设置 override
        base_driver::set_type_override_by_type(new_driver::get_type());
        drv = base_driver::type_id::create("drv", this);
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        // 验证
        new_driver casted;
        if ($cast(casted, drv))
            `uvm_info("OK", "Override success!", UVM_LOW)
    endfunction
endclass

module tb_type_override;
    initial begin
        $display("Type Override Demo");
        run_test();
        #200; $finish;
    end
endmodule
