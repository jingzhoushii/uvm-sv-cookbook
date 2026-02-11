// ============================================================================
// Bus Agent - AHB 总线代理
// ============================================================================

`timescale 1ns/1ps

`include "uvm_macros.svh"

class bus_trans extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit         is_read;
    bit              response;
    
    `uvm_object_utils_begin(bus_trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(is_read, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class bus_driver extends uvm_driver#(bus_trans);
    `uvm_component_utils(bus_driver)
    
    virtual bus_if vif;
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done(req);
        end
        phase.drop_objection(this);
    endtask
    
    task drive(bus_trans t);
        // 简化的 AHB 驱动
        @(posedge vif.clk);
        vif.haddr  = t.addr;
        vif.hwdata = t.data;
        vif.hwrite = t.is_read ? 1'b0 : 1'b1;
        vif.hsize  = 3'b010;
        vif.hburst = 3'b000;
        vif.hsel   = 1'b1;
        
        // 等待响应
        do begin
            @(posedge vif.clk);
        end while (!vif.hready);
        
        if (t.is_read)
            t.data = vif.hrdata;
    endtask
endclass

class bus_monitor extends uvm_monitor;
    `uvm_component_utils(bus_monitor)
    
    virtual bus_if vif;
    uvm_analysis_port#(bus_trans) ap;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if (vif.hready && vif.hsel) begin
                bus_trans t = bus_trans::type_id::create("t");
                t.addr  = vif.haddr;
                t.data  = vif.hrdata;
                t.is_read = vif.hwrite ? 1'b0 : 1'b1;
                ap.write(t);
            end
        end
    endtask
endclass

class bus_sequencer extends uvm_sequencer#(bus_trans);
    `uvm_component_utils(bus_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class bus_agent extends uvm_agent;
    `uvm_component_utils(bus_agent)
    
    bus_driver    drv;
    bus_monitor   mon;
    bus_sequencer seqr;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv  = bus_driver::type_id::create("drv", this);
        mon  = bus_monitor::type_id::create("mon", this);
        seqr = bus_sequencer::type_id::create("seqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass

// Virtual Interface
interface bus_if (input bit clk, input bit rst_n);
    bit [31:0] haddr;
    bit [31:0] hwdata;
    bit        hwrite;
    bit [2:0]  hsize;
    bit [2:0]  hburst;
    bit        hsel;
    bit [31:0] hrdata;
    bit        hready;
    bit [1:0]  hresp;
endinterface

endmodule
