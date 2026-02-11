// ============================================================================
// UART VIP - 通用虚拟 IP 示例
// ============================================================================

`timescale 1ns/1ps

// UART Transaction
class uart_trans extends uvm_sequence_item;
    rand bit [7:0] data;
    rand bit       parity_err;
    
    `uvm_object_utils_begin(uart_trans)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// UART Driver
class uart_driver extends uvm_driver#(uart_trans);
    `uvm_component_utils(uart_driver)
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            seq_item_port.get_next_item(req);
            // 模拟 UART 发送
            #100;
            seq_item_port.item_done(req);
        end
        phase.drop_objection(this);
    endtask
endclass

// UART Agent
class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)
    
    uart_driver   drv;
    uvm_sequencer#(uart_trans) seqr;
    
    virtual function void build_phase(uvm_phase phase);
        drv = uart_driver::type_id::create("drv", this);
        seqr = uvm_sequencer#(uart_trans)::type_id::create("seqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

endmodule
