// ============================================================================
// Boot Virtual Sequence - 系统启动序列
// ============================================================================

`include "uvm_macros.svh"
`include "base_vseq.sv"

class boot_vseq extends base_vseq;
    `uvm_object_utils(boot_vseq)
    
    function new(string name="boot_vseq");
        super.new(name);
    endfunction
    
    virtual task body();
        `uvm_info("BOOT", "Starting boot sequence", UVM_LOW)
        
        // 启动 CPU Stub
        fork
            begin
                bus_trans req;
                req = bus_trans::type_id::create("req");
                req.is_read = 1;
                req.addr = 32'h0000_0000;
                `uvm_do_with(req, {req.addr == 32'h0000_0000;})
            end
        join_none
        
        `uvm_info("BOOT", "Boot sequence complete", UVM_LOW)
    endtask
endclass

endmodule
