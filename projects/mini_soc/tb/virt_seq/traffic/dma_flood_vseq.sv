// ============================================================================
// DMA Flood Sequence - DMA 压力序列
// ============================================================================

`include "uvm_macros.svh"

class dma_flood_vseq extends uvm_sequence;
    `uvm_object_utils(dma_flood_vseq)
    
    soc_virtual_sequencer vseqr;
    int flood_count = 100;
    
    virtual task body();
        `uvm_info("DMA_FLOOD", "Starting DMA flood test", UVM_LOW)
        
        repeat(flood_count) begin
            dma_trans req;
            `uvm_create(req)
            req.src_addr = $random() % 32'h10000;
            req.dst_addr = $random() % 32'h10000 + 32'h20000;
            req.length = 64 + ($random() % 64);
            req.start = 1;
            `uvm_send(req)
        end
        
        `uvm_info("DMA_FLOOD", "DMA flood complete", UVM_LOW)
    endtask
endclass

endmodule
