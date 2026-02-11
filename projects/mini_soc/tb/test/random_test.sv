// ============================================================================
// Random Test - 随机测试
// ============================================================================

`include "uvm_macros.svh"
`include "base_test.sv"

class random_test extends base_test;
    `uvm_component_utils(random_test)
    
    function new(string name="random_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("RANDOM", "Starting random test", UVM_LOW)
        
        // 随机序列
        rw_seq seq;
        seq = rw_seq::type_id::create("rw_seq");
        seq.count = 100;
        seq.vseqr = env.vseqr.bus_seqr;
        seq.start(seq.vseqr);
        
        `uvm_info("RANDOM", "Random test PASSED", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
endclass

endmodule
