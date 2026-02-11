// ============================================================================
// UART Stream Sequence - UART 压力序列
// ============================================================================

`include "uvm_macros.svh"

class uart_stream_vseq extends uvm_sequence;
    `uvm_object_utils(uart_stream_vseq)
    
    soc_virtual_sequencer vseqr;
    int stream_count = 50;
    
    virtual task body();
        `uvm_info("UART_STREAM", "Starting UART stream test", UVM_LOW)
        
        repeat(stream_count) begin
            uart_trans req;
            `uvm_create(req)
            req.data = $random() % 256;
            `uvm_send(req)
        end
        
        `uvm_info("UART_STREAM", "UART stream complete", UVM_LOW)
    endtask
endclass

endmodule
