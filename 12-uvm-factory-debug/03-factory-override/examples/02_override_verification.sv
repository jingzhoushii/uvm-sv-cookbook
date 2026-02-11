// ============================================================================
// UVM Factory Override - 验证是否成功
// ============================================================================

`timescale 1ns/1ps

class original_driver extends uvm_driver;
    `uvm_component_utils(original_driver)
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("ORIG", "Original driver", UVM_LOW)
        #100; phase.drop_objection(this);
    endtask
endclass

class new_driver extends uvm_driver;
    `uvm_component_utils(new_driver)
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("NEW", "New driver (override SUCCESS!)", UVM_LOW)
        #100; phase.drop_objection(this);
    endtask
endclass

class test extends uvm_test;
    `uvm_component_utils(test)
    original_driver orig;
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        original_driver::set_type_override(new_driver::get_type());
        orig = original_driver::type_id::create("orig", this);
    endfunction
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        new_driver casted;
        if ($cast(casted, orig)) begin
            `uvm_info("OVERRIDE_OK", "Factory override SUCCESS!", UVM_LOW)
        end else begin
            `uvm_fatal("OVERRIDE_FAIL", "Factory override FAILED!")
        end
    endfunction
endclass

module tb_override_verify;
    initial begin
        $display("Factory Override Verification");
        run_test();
        #200; $finish;
    end
endmodule
