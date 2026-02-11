// ============================================================================
// System Test - 系统级测试
// ============================================================================

`include "uvm_macros.svh"
`include "base_test.sv"

class system_test extends base_test;
    `uvm_component_utils(system_test)
    
    function new(string name="system_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("SYSTEM", "Starting system test", UVM_LOW)
        
        // 运行 system virtual sequence
        system_vseq seq;
        seq = system_vseq::type_id::create("sys_seq");
        seq.vseqr = env.vseqr;
        seq.cpu_enable = 1;
        seq.uart_enable = 1;
        seq.dma_enable = 1;
        seq.start(seq.vseqr);
        
        `uvm_info("SYSTEM", "System test PASSED", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
endclass

endmodule
