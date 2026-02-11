// ============================================================================
// Base Virtual Sequence
// ============================================================================

`include "uvm_macros.svh"

class base_vseq extends uvm_sequence;
    `uvm_object_utils(base_vseq)
    
    soc_virtual_sequencer vseqr;
    
    function new(string name="base_vseq");
        super.new(name);
    endfunction
    
    virtual task body();
        `uvm_info("VSEQ", "Base virtual sequence", UVM_LOW)
    endtask
endclass

endmodule
