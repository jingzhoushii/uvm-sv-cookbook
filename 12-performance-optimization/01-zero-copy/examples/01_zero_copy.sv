// ============================================================================
// SystemVerilog 零拷贝示例
// ============================================================================

`timescale 1ns/1ps

class trans extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    `uvm_object_utils_begin(trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class good_processor extends uvm_component;
    `uvm_component_utils(good_processor)
    trans pool[10];
    
    virtual function void build_phase(uvm_phase phase);
        for(int i=0; i<10; i++)
            pool[i] = trans::type_id::create($sformatf("p_%0d", i));
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        foreach(pool[i]) begin
            pool[i].randomize();
            process_ref(pool[i]);  // ref 参数，零拷贝
            pool[i].reset();
        end
        phase.drop_objection(this);
    endtask
    
    task process_ref(ref trans t);
        $display("addr=0x%0h data=0x%0h", t.addr, t.data);
    endtask
endclass

class env extends uvm_env;
    `uvm_component_utils(env)
    good_processor proc;
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        proc = good_processor::type_id::create("proc", this);
    endfunction
endclass

module tb_zero_copy;
    initial begin
        env e;
        $display("Zero-Copy Demo");
        e = env::type_id::create("e", null);
        e.build();
        run_test();
        #100; $finish;
    end
endmodule
