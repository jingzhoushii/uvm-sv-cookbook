// ============================================================================
// DMA Sequences
// ============================================================================

`include "uvm_macros.svh"

class dma_trans_enh extends uvm_sequence_item;
    rand bit [31:0] src_addr;
    rand bit [31:0] dst_addr;
    rand bit [31:0] length;
    rand bit         start;
    
    `uvm_object_utils_begin(dma_trans_enh)
    `uvm_field_int(src_addr, UVM_ALL_ON)
    `uvm_field_int(dst_addr, UVM_ALL_ON)
    `uvm_field_int(length, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class dma_base_seq extends uvm_sequence#(dma_trans_enh);
    `uvm_object_utils(dma_base_seq)
    
    int count = 5;
    
    virtual task body();
        repeat(count) begin
            `uvm_do(req)
        end
    endtask
endclass

// Memory Copy Sequence
class dma_memcpy_seq extends uvm_sequence#(dma_trans_enh);
    `uvm_object_utils(dma_memcpy_seq)
    
    bit [31:0] src;
    bit [31:0] dst;
    int size;
    
    virtual task body();
        `uvm_create(req)
        req.src_addr = src;
        req.dst_addr = dst;
        req.length = size;
        req.start = 1;
        `uvm_send(req)
    endtask
endclass

endmodule
