// ============================================================================
// @file    : dma_monitor.sv
// @brief   : DMA 监控
// ============================================================================
`timescale 1ns/1ps

class dma_monitor extends uvm_monitor;
    `uvm_component_utils(dma_monitor)
    
    virtual dma_if vif;
    uvm_analysis_port#(dma_transaction) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dma_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", "Cannot get vif")
        end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(posedge vif.clk);
            if (vif.start) begin
                dma_transaction tr;
                tr = dma_transaction::type_id::create("tr");
                tr.src_addr = vif.src_addr;
                tr.dst_addr = vif.dst_addr;
                tr.length = vif.length;
                tr.channel = vif.channel;
                ap.write(tr);
            end
        end
    endtask
endclass : dma_monitor
