// ============================================================================
// UART Sequences
// ============================================================================

`include "uvm_macros.svh"

class uart_trans_enh extends uvm_sequence_item;
    rand bit [7:0] data;
    rand int delay;
    bit rx_data;
    
    `uvm_object_utils_begin(uart_trans_enh)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class uart_base_seq extends uvm_sequence#(uart_trans_enh);
    `uvm_object_utils(uart_base_seq)
    
    int repeat_count = 10;
    
    virtual task body();
        repeat(repeat_count) begin
            `uvm_do(req)
        end
    endtask
endclass

// UART TX Sequence
class uart_tx_seq extends uvm_sequence#(uart_trans_enh);
    `uvm_object_utils(uart_tx_seq)
    
    bit [7:0] tx_data[];
    
    virtual task body();
        foreach (tx_data[i]) begin
            uart_trans_enh req;
            `uvm_create(req)
            req.data = tx_data[i];
            `uvm_send(req)
        end
    endtask
endclass

endmodule
