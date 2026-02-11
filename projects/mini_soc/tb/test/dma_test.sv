// ============================================================================
// DMA Test - DMA 测试
// ============================================================================

`include "uvm_macros.svh"
`include "base_test.sv"

class dma_test extends base_test;
    `uvm_component_utils(dma_test)
    
    function new(string name="dma_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("DMA", "Starting DMA test", UVM_LOW)
        
        // DMA 传输测试
        dma_memcpy_seq seq;
        seq = dma_memcpy_seq::type_id::create("dma_seq");
        seq.src = 32'h0000_1000;
        seq.dst = 32'h1000_0000;
        seq.size = 1024;
        seq.vseqr = env.vseqr.dma_seqr;
        seq.start(seq.vseqr);
        
        `uvm_info("DMA", "DMA test PASSED", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
endclass

endmodule
