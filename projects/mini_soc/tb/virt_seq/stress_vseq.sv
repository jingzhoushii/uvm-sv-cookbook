// ============================================================================
// Stress Virtual Sequence - 压力测试序列
// ============================================================================

`include "uvm_macros.svh"
`include "base_vseq.sv"

class stress_vseq extends base_vseq;
    `uvm_object_utils(stress_vseq)
    
    int repeat_count = 100;
    
    function new(string name="stress_vseq");
        super.new(name);
    endfunction
    
    virtual task body();
        `uvm_info("STRESS", "Starting stress test", UVM_LOW)
        
        // 并发驱动多个 Agent
        fork
            begin
                // Bus 压力测试
                repeat(repeat_count) begin
                    bus_trans req;
                    `uvm_do(req)
                end
            end
        join_none
        
        `uvm_info("STRESS", "Stress test complete", UVM_LOW)
    endtask
endclass

endmodule
