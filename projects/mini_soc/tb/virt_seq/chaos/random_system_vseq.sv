// ============================================================================
// Random System Sequence - 随机系统序列
// ============================================================================

`include "uvm_macros.svh"

class random_system_vseq extends uvm_sequence;
    `uvm_object_utils(random_system_vseq)
    
    soc_virtual_sequencer vseqr;
    int total_iterations = 50;
    
    virtual task body();
        `uvm_info("CHAOS", "Starting random system test", UVM_LOW)
        
        for (int i = 0; i < total_iterations; i++) begin
            // 随机选择操作
            int op = $random() % 10;
            
            case (op)
                0,1,2: begin  // Bus
                    bus_trans req;
                    `uvm_do(req)
                end
                3,4: begin  // UART
                    uart_trans req;
                    `uvm_do(req)
                end
                5,6: begin  // DMA
                    dma_trans req;
                    `uvm_do(req)
                end
                7,8: begin  // 多个并发
                    fork
                        begin bus_trans r; `uvm_do(r) end
                        begin uart_trans r; `uvm_do(r) end
                    join
                end
                9: begin  // 暂停
                    #($random() % 100 + 10);
                end
            endcase
            
            #($random() % 50);
        end
        
        `uvm_info("CHAOS", "Random system test complete", UVM_LOW)
    endtask
endclass

endmodule
