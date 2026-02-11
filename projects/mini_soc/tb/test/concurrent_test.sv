// ============================================================================
// Concurrent Test - 并发测试
// ============================================================================

`include "uvm_macros.svh"
`include "base_test.sv"

class concurrent_test extends base_test;
    `uvm_component_utils(concurrent_test)
    
    function new(string name="concurrent_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("CONCURRENT", "Starting concurrent test", UVM_LOW)
        
        // 运行并发虚拟序列
        concurrent_vseq seq;
        seq = concurrent_vseq::type_id::create("conc_seq");
        seq.vseqr = env.vseqr;
        seq.bus_trans_count = 100;
        seq.start(seq.vseqr);
        
        `uvm_info("CONCURRENT", "Concurrent test PASSED", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
endclass

endmodule
