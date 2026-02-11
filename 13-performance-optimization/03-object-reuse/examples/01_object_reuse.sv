// ============================================================================
// Object Reuse 示例
// ============================================================================

`timescale 1ns/1ps

class trans extends uvm_sequence_item;
    rand bit [31:0] addr, data;
    `uvm_object_utils_begin(trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class reuse_driver extends uvm_driver#(trans);
    `uvm_component_utils(reuse_driver)
    trans current;
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            // ✅ 复用同一个对象
            if (current == null)
                current = trans::type_id::create("t");
            
            seq_item_port.get_next_item(current);
            drive(current);
            seq_item_port.item_done(current);
            #10;
        end
        phase.drop_objection(this);
    endtask
    
    task drive(trans t);
        #10;
    endtask
endclass

class env extends uvm_env;
    `uvm_component_utils(env)
    reuse_driver drv;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = reuse_driver::type_id::create("drv", this);
    endfunction
endclass

module tb_reuse;
    initial begin
        $display("Object Reuse Demo");
        run_test();
        #200; $finish;
    end
endmodule
