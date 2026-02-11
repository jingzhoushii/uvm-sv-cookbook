// ============================================================================
// Concurrent Virtual Sequence - 并发测试
// ============================================================================

`include "uvm_macros.svh"
`include "base_vseq.sv"

class concurrent_vseq extends base_vseq;
    `uvm_object_utils(concurrent_vseq)
    
    int bus_trans_count = 50;
    int uart_trans_count = 20;
    int dma_trans_count = 5;
    
    virtual task body();
        `uvm_info("CONCURRENT", "Starting concurrent test", UVM_LOW)
        
        // 并发执行多个序列
        fork
            // Bus 压力测试
            begin
                rw_seq seq;
                seq = rw_seq::type_id::create("bus_seq");
                seq.count = bus_trans_count;
                seq.vseqr = vseqr.bus_seqr;
                seq.start(seq.vseqr);
            end
            
            // UART 传输
            begin
                uart_tx_seq seq;
                seq = uart_tx_seq::type_id::create("uart_seq");
                seq.vseqr = vseqr.uart_seqr;
                seq.start(seq.vseqr);
            end
            
            // DMA 传输
            begin
                dma_memcpy_seq seq;
                seq = dma_memcpy_seq::type_id::create("dma_seq");
                seq.vseqr = vseqr.dma_seqr;
                seq.start(seq.vseqr);
            end
        join
        
        `uvm_info("CONCURRENT", "Concurrent test complete", UVM_LOW)
    endtask
endclass

endmodule
