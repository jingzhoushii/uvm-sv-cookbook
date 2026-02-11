// ============================================================================
// Reset Recovery Sequence - 复位恢复序列
// ============================================================================

`include "uvm_macros.svh"

class reset_recovery_vseq extends uvm_sequence;
    `uvm_object_utils(reset_recovery_vseq)
    
    soc_virtual_sequencer vseqr;
    
    int recovery_count = 5;
    
    virtual task body();
        `uvm_info("RESET_REC", "Starting reset recovery sequence", UVM_LOW)
        
        repeat(recovery_count) begin
            // 复位后重新初始化
            `uvm_info("RESET_REC", "Recovery iteration", UVM_LOW)
            
            fork
                begin
                    bus_trans req;
                    `uvm_do_with(req, {is_read == 1; addr == 32'h0000_0000;})
                end
            join_none
            
            #50;
        end
        
        `uvm_info("RESET_REC", "Reset recovery complete", UVM_LOW)
    endtask
endclass

endmodule
