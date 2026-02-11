// ============================================================================
// Zero-Copy 数据竞争风险
// ============================================================================

`timescale 1ns/1ps

class trans extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    `uvm_object_utils_begin(trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class safe_driver extends uvm_driver#(trans);
    `uvm_component_utils(safe_driver)
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            trans t;
            seq_item_port.get_next_item(t);
            trans local_t = trans::type_id::create("local_t");
            local_t.copy(t);
            seq_item_port.item_done(t);
        end
        phase.drop_objection(this);
    endtask
endclass

class env extends uvm_env;
    `uvm_component_utils(env)
    safe_driver drv;
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = safe_driver::type_id::create("drv", this);
    endfunction
endclass

module tb_race;
    initial begin
        $display("Zero-Copy Race Condition Demo");
        run_test();
        #200; $finish;
    end
endmodule
