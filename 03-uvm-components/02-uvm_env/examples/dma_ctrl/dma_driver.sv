// ============================================================================
// @file    : dma_driver.sv
// @brief   : DMA 驱动
// ============================================================================
`timescale 1ns/1ps

class dma_driver extends uvm_driver#(dma_transaction);
    `uvm_component_utils(dma_driver)
    
    virtual dma_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
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
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done();
        end
    endtask
    
    protected task drive(dma_transaction tr);
        `uvm_info(get_type_name(),
            $sformatf("Drive: src=0x%0h dst=0x%0h len=%0d",
                     tr.src_addr, tr.dst_addr, tr.length), UVM_LOW)
    endtask
endclass : dma_driver
