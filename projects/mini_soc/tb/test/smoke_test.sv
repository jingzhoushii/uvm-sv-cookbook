// ============================================================================
// Smoke Test - 冒烟测试
// ============================================================================

`include "uvm_macros.svh"
`include "base_test.sv"
`include "boot_vseq.sv"

class smoke_test extends base_test;
    `uvm_component_utils(smoke_test)
    
    function new(string name="smoke_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("SMOKE", "Starting smoke test", UVM_LOW)
        
        // 运行 boot sequence
        boot_vseq seq;
        seq = boot_vseq::type_id::create("boot_seq");
        seq.vseqr = env.vseqr;
        seq.start(seq.vseqr);
        
        `uvm_info("SMOKE", "Smoke test PASSED", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
endclass

endmodule
