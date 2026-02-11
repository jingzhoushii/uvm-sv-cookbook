// ============================================================================
// Mixed I/O Sequence - 混合 I/O 序列
// ============================================================================

`include "uvm_macros.svh"

class mixed_io_vseq extends uvm_sequence;
    `uvm_object_utils(mixed_io_vseq)
    
    soc_virtual_sequencer vseqr;
    int iteration_count = 20;
    
    virtual task body();
        `uvm_info("MIXED_IO", "Starting mixed I/O test", UVM_LOW)
        
        fork
            // Bus I/O
            begin
                repeat(iteration_count) begin
                    bus_trans req;
                    `uvm_do(req)
                end
            end
            
            // UART I/O
            begin
                repeat(iteration_count / 2) begin
                    uart_trans req;
                    `uvm_do(req)
                end
            end
            
            // DMA
            begin
                repeat(iteration_count / 4) begin
                    dma_trans req;
                    `uvm_do(req)
                end
            end
        join
        
        `uvm_info("MIXED_IO", "Mixed I/O complete", UVM_LOW)
    endtask
endclass

endmodule
