// ============================================================================
// Transaction Pooling 示例
// ============================================================================

`timescale 1ns/1ps

class trans extends uvm_sequence_item;
    rand bit [31:0] addr, data;
    `uvm_object_utils_begin(trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_object_utils_end
    function void reset(); addr=0; data=0; endfunction
endclass

class txn_pool extends uvm_object;
    `uvm_object_utils_begin(txn_pool)
    `uvm_object_utils_end
    trans free_list[$];
    
    virtual function trans get();
        trans t;
        if (free_list.size() > 0) t = free_list.pop_front();
        else t = trans::type_id::create("new");
        t.reset();
        return t;
    endfunction
    
    virtual function void put(trans t);
        t.reset();
        free_list.push_back(t);
    endfunction
endclass

class driver extends uvm_driver#(trans);
    `uvm_component_utils(driver)
    txn_pool pool;
    
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
    txn_pool pool;
    driver drv;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        pool = txn_pool::type_id::create("pool");
        pool.free_list = new[20];  // 预分配
        drv = driver::type_id::create("drv", this);
    endfunction
endclass

module tb_pool;
    initial begin
        $display("Transaction Pool Demo");
        run_test();
        #200; $finish;
    end
endmodule
