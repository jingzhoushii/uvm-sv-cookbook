// ============================================================================
// Bus Sequences
// ============================================================================

`include "uvm_macros.svh"

// Bus Transaction 增强版
class bus_trans_enh extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit         is_read;
    rand int         delay;
    bit              response;
    bit              error;
    
    `uvm_object_utils_begin(bus_trans_enh)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(is_read, UVM_ALL_ON)
    `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// Basic Bus Sequence
class bus_base_seq extends uvm_sequence#(bus_trans_enh);
    `uvm_object_utils(bus_base_seq)
    
    int repeat_count = 10;
    
    virtual task body();
        repeat(repeat_count) begin
            `uvm_do(req)
        end
    endtask
endclass

// Read/Write Sequence
class rw_seq extends uvm_sequence#(bus_trans_enh);
    `uvm_object_utils(rw_seq)
    
    int count = 20;
    
    virtual task body();
        repeat(count) begin
            bus_trans_enh req;
            `uvm_create(req)
            req.is_read = $random() % 2;
            req.addr = $random() % 32'h1000_0000;
            req.data = $random();
            `uvm_send(req)
        end
    endtask
endclass

// Address Range Sequence
class addr_range_seq extends uvm_sequence#(bus_trans_enh);
    `uvm_object_utils(addr_range_seq)
    
    bit [31:0] start_addr;
    bit [31:0] end_addr;
    int count;
    
    virtual task body();
        for (int i = 0; i < count; i++) begin
            bus_trans_enh req;
            `uvm_create(req)
            req.addr = start_addr + (i * 4);
            req.is_read = 1;
            req.data = $random();
            `uvm_send(req)
        end
    endtask
endclass

endmodule
