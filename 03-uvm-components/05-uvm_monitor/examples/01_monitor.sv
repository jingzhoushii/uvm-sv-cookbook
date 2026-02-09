// ============================================================
// File: 01_monitor.sv
// Description: UVM Monitor 示例
// ============================================================

`timescale 1ns/1ps

class bus_txn extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        rw;
    
    `uvm_object_utils_begin(bus_txn)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

interface bus_if (input bit clk);
    logic [31:0] addr, data;
    logic        rw, valid, ready;
endinterface

class bus_monitor extends uvm_monitor;
    `uvm_component_utils(bus_monitor)
    
    virtual bus_if vif;
    uvm_analysis_port#(bus_txn) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", "Cannot get vif")
        end
    endtask
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            @(posedge vif.clk);
            
            if (vif.valid && vif.ready) begin
                bus_txn tr;
                tr = bus_txn::type_id::create("tr");
                tr.addr = vif.addr;
                tr.data = vif.data;
                tr.rw = vif.rw;
                
                `uvm_info(get_type_name(),
                    $sformatf("Monitor: addr=0x%0h data=0x%0h rw=%b", 
                             tr.addr, tr.data, tr.rw), UVM_LOW)
                ap.write(tr);
            end
        end
    endtask
endclass

module tb_monitor;
    bit clk;
    bus_if ifc (clk);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 模拟总线活动
    initial begin
        #10 ifc.valid = 1; ifc.addr = 32'h1000; ifc.data = 32'h1234; ifc.rw = 1;
        #10 ifc.ready = 1;
        #10 ifc.valid = 0; ifc.ready = 0;
        
        #100;
        $display("Monitor Demo Complete!");
        $finish;
    end
    
    initial begin
        uvm_config_db#(virtual bus_if)::set(null, "*", "vif", ifc);
        
        bus_monitor mon;
        mon = new("mon", null);
        mon.build();
        
        #200;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_monitor);
    end
endmodule
