// ============================================================================
// UART Agent
// ============================================================================

`timescale 1ns/1ps

`include "uvm_macros.svh"

class uart_trans extends uvm_sequence_item;
    rand bit [7:0] data;
    bit            rx_data;
    
    `uvm_object_utils_begin(uart_trans)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class uart_driver extends uvm_driver#(uart_trans);
    `uvm_component_utils(uart_driver)
    
    virtual uart_if vif;
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done(req);
        end
        phase.drop_objection(this);
    endtask
    
    task drive(uart_trans t);
        vif.tx = t.data[0];
        #100;  // 简化的 UART 时序
    endtask
endclass

class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor)
    
    virtual uart_if vif;
    uvm_analysis_port#(uart_trans) ap;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            ap.write(req);
        end
    endtask
endclass

class uart_sequencer extends uvm_sequencer#(uart_trans);
    `uvm_component_utils(uart_sequencer)
endclass

class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)
    
    uart_driver    drv;
    uart_monitor   mon;
    uart_sequencer seqr;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv  = uart_driver::type_id::create("drv", this);
        mon  = uart_monitor::type_id::create("mon", this);
        seqr = uart_sequencer::type_id::create("seqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

interface uart_if (input bit clk);
    bit rx;
    bit tx;
endinterface

endmodule
