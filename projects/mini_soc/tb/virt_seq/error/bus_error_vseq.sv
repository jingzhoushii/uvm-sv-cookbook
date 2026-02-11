// ============================================================================
// Bus Error Sequence - 总线错误注入序列
// ============================================================================

`include "uvm_macros.svh"

class bus_error_vseq extends uvm_sequence;
    `uvm_object_utils(bus_error_vseq)
    
    soc_virtual_sequencer vseqr;
    int error_count = 10;
    
    virtual task body();
        `uvm_info("BUS_ERROR", "Starting bus error injection", UVM_LOW)
        
        repeat(error_count) begin
            bus_trans req;
            `uvm_create(req)
            req.is_read = $random() % 2;
            req.addr = 32'hFFFF_FFF0;  // 非法地址
            req.data = $random();
            `uvm_send(req)
            
            #10;
        end
        
        `uvm_info("BUS_ERROR", "Bus error injection complete", UVM_LOW)
    endtask
endclass

endmodule
