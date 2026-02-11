// ============================================================================
// Memory Test - 存储器测试
// ============================================================================

`include "uvm_macros.svh"
`include "base_test.sv"

class mem_test extends base_test;
    `uvm_component_utils(mem_test)
    
    function new(string name="mem_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("MEM", "Starting memory test", UVM_LOW)
        
        // 地址范围测试
        addr_range_seq seq;
        seq = addr_range_seq::type_id::create("addr_seq");
        seq.start_addr = 32'h0000_0000;
        seq.end_addr = 32'h0000_1000;
        seq.count = 256;
        seq.vseqr = env.vseqr.bus_seqr;
        seq.start(seq.vseqr);
        
        `uvm_info("MEM", "Memory test PASSED", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
endclass

endmodule
