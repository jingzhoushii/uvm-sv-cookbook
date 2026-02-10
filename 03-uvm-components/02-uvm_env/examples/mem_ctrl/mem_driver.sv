// ============================================================================
// @file    : mem_driver.sv
// @brief   : 内存驱动
// ============================================================================
`timescale 1ns/1ps

class mem_driver extends uvm_driver#(mem_transaction);
    `uvm_component_utils(mem_driver)
    
    virtual mem_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual mem_if)::get(this, "", "vif", vif)) begin
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
    
    protected task drive(mem_transaction tr);
        `uvm_info(get_type_name(),
            $sformatf("Drive: addr=0x%0h data=0x%0h rw=%b",
                     tr.addr, tr.data, tr.rw), UVM_LOW)
        
        if (tr.rw) begin
            vif.wr_addr = tr.addr;
            vif.wr_data = tr.data;
            vif.wr_en = 1'b1;
            @(posedge vif.clk);
            while (!vif.wr_ready) @(posedge vif.clk);
            vif.wr_en = 1'b0;
        end else begin
            vif.rd_addr = tr.addr;
            vif.rd_en = 1'b1;
            @(posedge vif.clk);
            while (!vif.rd_valid) @(posedge vif.clk);
            tr.data = vif.rd_data;
            vif.rd_en = 1'b0;
        end
    endtask
endclass : mem_driver
