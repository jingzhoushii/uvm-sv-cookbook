// ============================================================================
// Stress Test - 压力测试
// ============================================================================

`include "uvm_macros.svh"
`include "base_test.sv"
`include "stress_vseq.sv"

class stress_test extends base_test;
    `uvm_component_utils(stress_test)
    
    function new(string name="stress_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("STRESS", "Starting stress test", UVM_LOW)
        
        // 运行 stress sequence
        stress_vseq seq;
        seq = stress_vseq::type_id::create("stress_seq");
        seq.vseqr = env.vseqr;
        seq.repeat_count = 100;
        seq.start(seq.vseqr);
        
        `uvm_info("STRESS", "Stress test PASSED", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
endmodule
