// ============================================================================
// System Virtual Sequence - 系统级虚拟序列
// ============================================================================

`include "uvm_macros.svh"
`include "base_vseq.sv"

class system_vseq extends base_vseq;
    `uvm_object_utils(system_vseq)
    
    // 并发控制
    bit cpu_enable = 1;
    bit uart_enable = 1;
    bit dma_enable = 1;
    
    virtual task body();
        `uvm_info("SYS_VSEQ", "Starting system virtual sequence", UVM_LOW)
        
        fork
            // CPU 访问
            if (cpu_enable) begin
                fork
                    begin
                        bus_trans req;
                        forever begin
                            `uvm_do(req)
                        end
                    end
                join_none
            end
            
            // UART 通信
            if (uart_enable) begin
                fork
                    begin
                        uart_trans req;
                        forever begin
                            `uvm_do(req)
                        end
                    end
                join_none
            end
            
            // DMA 传输
            if (dma_enable) begin
                fork
                    begin
                        dma_trans req;
                        forever begin
                            `uvm_do(req)
                        end
                    end
                join_none
            end
        join
        
        `uvm_info("SYS_VSEQ", "System sequence complete", UVM_LOW)
    endtask
endclass

endmodule
