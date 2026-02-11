// ============================================================================
// Transaction Pool 示例
// ============================================================================

`timescale 1ns/1ps

class trans extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    `uvm_object_utils_begin(trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    function void reset(); addr=0; data=0; endfunction
endclass

class trans_pool extends uvm_object;
    trans free_list[$];
    `uvm_object_utils_begin(trans_pool)
    `uvm_object_utils_end
    virtual function void preallocate(int count);
        for(int i=0; i<count; i++)
            free_list.push_back(trans::type_id::create($sformatf("t_%0d", i)));
    endfunction
    virtual function trans get();
        trans t;
        if(free_list.size()>0) t = free_list.pop_front();
        else t = trans::type_id::create("new");
        t.reset();
        return t;
    endfunction
    virtual function void put(trans t);
        t.reset();
        free_list.push_back(t);
    endfunction
endclass

class my_driver extends uvm_driver#(trans);
    `uvm_component_utils(my_driver)
    trans_pool pool;
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            trans t = pool.get();
            seq_item_port.item_done(t);
            #10;
            pool.put(t);
        end
        phase.drop_objection(this);
    endtask
endclass

class env extends uvm_env;
    `uvm_component_utils(env)
    trans_pool pool;
    my_driver drv;
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        pool = trans_pool::type_id::create("pool");
        pool.preallocate(20);
        drv = my_driver::type_id::create("drv", this);
    endfunction
endclass

module tb_pool;
    initial begin
        env e;
        $display("Transaction Pool Demo");
        e = env::type_id::create("e", null);
        e.build();
        run_test();
        #100; $finish;
    end
endmodule
