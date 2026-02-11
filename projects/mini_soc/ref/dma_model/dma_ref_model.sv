// ============================================================================
// DMA Reference Model - DMA 参考模型
// ============================================================================

`include "uvm_macros.svh"

class dma_ref_model extends uvm_component;
    `uvm_component_utils(dma_ref_model)
    
    // 描述符队列
    bit [31:0] descriptors[$];
    int pending_transfers = 0;
    
    // 状态
    int transfer_count = 0;
    bit [31:0] last_src;
    bit [31:0] last_dst;
    int last_len;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    // 提交传输
    virtual function void submit(bit [31:0] src, bit [31:0] dst, int len);
        descriptors.push_back(src);
        pending_transfers++;
        `uvm_info("DMA_REF", $sformatf("Submit: src=0x%0h dst=0x%0h len=%0d", src, dst, len), UVM_LOW)
    endfunction
    
    // 完成传输
    virtual function void complete();
        if (descriptors.size() > 0) begin
            descriptors.pop_front();
            pending_transfers--;
            transfer_count++;
        end
    endfunction
    
    virtual function void report();
        `uvm_info("DMA_REF", $sformatf("Transfers: %0d, Pending: %0d", transfer_count, pending_transfers), UVM_LOW)
    endfunction
endclass

endmodule
