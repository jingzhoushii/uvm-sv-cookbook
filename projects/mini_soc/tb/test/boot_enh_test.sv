// ============================================================================
// Boot Enhanced Test - 增强引导测试
// ============================================================================

`include "uvm_macros.svh"
`include "base_test.sv"

class boot_enh_test extends base_test;
    `uvm_component_utils(boot_enh_test)
    
    function new(string name="boot_enh_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("BOOT", "Starting enhanced boot test", UVM_LOW)
        
        // 运行增强引导序列
        boot_vseq_enh seq;
        seq = boot_vseq_enh::type_id::create("boot_seq");
        seq.vseqr = env.vseqr;
        seq.start(seq.vseqr);
        
        `uvm_info("BOOT", "Boot test PASSED", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
endclass

endmodule
