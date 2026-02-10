// ============================================================================
// @file    : mem_monitor.sv
// @brief   : 内存监控
// ============================================================================
`timescale 1ns/1ps

class mem_monitor extends uvm_monitor;
    `uvm_component_utils(mem_monitor)
    
    virtual mem_if vif;
    uvm_analysis_port#(mem_transaction) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
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
            @(posedge vif.clk);
            if (vif.wr_en && vif.wr_ready) begin
                mem_transaction tr;
                tr = mem_transaction::type_id::create("tr");
                tr.rw = 1'b1;
                tr.addr = vif.wr_addr;
                tr.data = vif.wr_data;
                ap.write(tr);
                `uvm_info(get_type_name(),
                    $sformatf("Monitor write: addr=0x%0h data=0x%0h",
                             tr.addr, tr.data), UVM_LOW)
            end
            if (vif.rd_en && vif.rd_valid) begin
                mem_transaction tr;
                tr = mem_transaction::type_id::create("tr");
                tr.rw = 1'b0;
                tr.addr = vif.rd_addr;
                tr.data = vif.rd_data;
                ap.write(tr);
                `uvm_info(get_type_name(),
                    $sformatf("Monitor read: addr=0x%0h data=0x%0h",
                             tr.addr, tr.data), UVM_LOW)
            end
        end
    endtask
endclass : mem_monitor
