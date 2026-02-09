// ============================================================
// File: 01_driver.sv
// Description: UVM Driver 示例
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
    
    function new(string name = "bus_txn");
        super.new(name);
    endfunction
endclass

interface bus_if (input bit clk);
    logic [31:0] addr, data;
    logic        rw, valid, ready;
endinterface

class bus_driver extends uvm_driver#(bus_txn);
    `uvm_component_utils(bus_driver)
    
    virtual bus_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NO_VIF", "Cannot get vif")
        end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            seq_item_port.get_next_item(req);
            drive_txn(req);
            seq_item_port.item_done();
        end
    endtask
    
    protected task drive_txn(bus_txn tr);
        `uvm_info(get_type_name(), 
            $sformatf("Drive: addr=0x%0h data=0x%0h rw=%b", 
                     tr.addr, tr.data, tr.rw), UVM_LOW)
        
        vif.addr   <= tr.addr;
        vif.data  <= tr.data;
        vif.rw    <= tr.rw;
        vif.valid <= 1'b1;
        
        wait (vif.ready);
        @(posedge vif.clk);
        vif.valid <= 1'b0;
        
        #10;
    endtask
endclass

module tb_driver;
    bit clk;
    bus_if ifc (clk);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        uvm_config_db#(virtual bus_if)::set(null, "*", "vif", ifc);
        
        bus_driver drv;
        drv = new("drv", null);
        drv.build();
        
        #100;
        $display("Driver Demo Complete!");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_driver);
    end
endmodule
