// ============================================================================
// DMA Agent
// ============================================================================

`timescale 1ns/1ps

`include "uvm_macros.svh"

class dma_trans extends uvm_sequence_item;
    rand bit [31:0] src_addr;
    rand bit [31:0] dst_addr;
    rand bit [31:0] length;
    rand bit         start;
    
    `uvm_object_utils_begin(dma_trans)
    `uvm_field_int(src_addr, UVM_ALL_ON)
    `uvm_field_int(dst_addr, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class dma_driver extends uvm_driver#(dma_trans);
    `uvm_component_utils(dma_driver)
    
    virtual dma_if vif;
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done(req);
        end
        phase.drop_objection(this);
    endtask
    
    task drive(dma_trans t);
        // 配置 DMA
        vif.haddr  = 32'h1000_0000;  // DMA 寄存器基地址
        vif.hwdata = t.src_addr;
        vif.hwrite = 1'b1;
        // ... 配置寄存器
        #100;
    endtask
endclass

class dma_monitor extends uvm_monitor;
    `uvm_component_utils(dma_monitor)
    
    virtual dma_if vif;
    uvm_analysis_port#(dma_trans) ap;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
    endfunction
endclass

class dma_sequencer extends uvm_sequencer#(dma_trans);
    `uvm_component_utils(dma_sequencer)
endclass

class dma_agent extends uvm_agent;
    `uvm_component_utils(dma_agent)
    
    dma_driver    drv;
    dma_monitor   mon;
    dma_sequencer seqr;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv  = dma_driver::type_id::create("drv", this);
        mon  = dma_monitor::type_id::create("mon", this);
        seqr = dma_sequencer::type_id::create("seqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

interface dma_if (input bit clk);
    // AHB 信号
    bit [31:0] haddr;
    bit [31:0] hwdata;
    bit        hwrite;
    bit [2:0]  hsize;
    bit        hsel;
    bit [31:0] hrdata;
    bit        hready;
endinterface

endmodule
