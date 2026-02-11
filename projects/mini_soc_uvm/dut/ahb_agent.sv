// ============================================================================
// AHB Agent - 贯穿式 Agent 示例
// ============================================================================

`timescale 1ns/1ps

// AHB Transaction
class ahb_trans extends uvm_sequence_item;
    rand bit [31:0] haddr;
    rand bit [31:0] hwdata;
    rand bit         hwrite;
    rand bit [2:0]   hsize;
    rand bit [2:0]   hburst;
    
    `uvm_object_utils_begin(ahb_trans)
    `uvm_field_int(haddr, UVM_ALL_ON)
    `uvm_field_int(hwdata, UVM_ALL_ON)
    `uvm_field_int(hwrite, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// AHB Driver
class ahb_driver extends uvm_driver#(ahb_trans);
    `uvm_component_utils(ahb_driver)
    
    virtual interface ahb_vif vif;
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done(req);
        end
        
        phase.drop_objection(this);
    endtask
    
    task drive(ahb_trans t);
        // 简化的 AHB 驱动
        @(posedge vif.clk);
        vif.haddr = t.haddr;
        vif.hwdata = t.hwdata;
        vif.hwrite = t.hwrite;
        vif.hsize = t.hsize;
        vif.hburst = t.hburst;
    endtask
endclass

// AHB Monitor
class ahb_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_monitor)
    
    virtual interface ahb_vif vif;
    uvm_analysis_port#(ahb_trans) ap;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if (vif.hready) begin
                ahb_trans t = ahb_trans::type_id::create("t");
                t.haddr = vif.haddr;
                t.hwdata = vif.hwdata;
                t.hwrite = vif.hwrite;
                ap.write(t);
            end
        end
    endtask
endclass

// AHB Agent
class ahb_agent extends uvm_agent;
    `uvm_component_utils(ahb_agent)
    
    ahb_driver    drv;
    ahb_monitor   mon;
    uvm_sequencer#(ahb_trans) seqr;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = ahb_driver::type_id::create("drv", this);
        mon = ahb_monitor::type_id::create("mon", this);
        seqr = uvm_sequencer#(ahb_trans)::type_id::create("seqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
        mon.ap.connect(seqr.analysis_export);
    endfunction
endclass

// AHB Virtual Interface
interface ahb_vif (
    input bit clk,
    input bit rst_n
);
    bit [31:0] haddr;
    bit [31:0] hwdata;
    bit         hwrite;
    bit [2:0]   hsize;
    bit [2:0]   hburst;
    bit [31:0]  hrdata;
    bit         hready;
    bit         hresp;
endinterface

endmodule
