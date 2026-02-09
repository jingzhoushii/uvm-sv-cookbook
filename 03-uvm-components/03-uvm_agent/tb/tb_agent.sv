`timescale 1ns/1ps

// Simple bus transaction
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

// Simple bus driver
class bus_driver extends uvm_driver#(bus_txn);
    `uvm_component_utils(bus_driver)
    
    virtual interface void;
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info(get_type_name(), $sformatf("Drive: addr=0x%h", req.addr), UVM_LOW)
            seq_item_port.item_done();
        end
    endtask
endclass

// Simple bus monitor
class bus_monitor extends uvm_monitor;
    `uvm_component_utils(bus_monitor)
    
    uvm_analysis_port#(bus_txn) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
endclass

// Simple bus sequencer
class bus_sequencer extends uvm_sequencer#(bus_txn);
    `uvm_component_utils(bus_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Bus agent
class bus_agent extends uvm_agent;
    `uvm_component_utils(bus_agent)
    
    bus_driver     driver;
    bus_monitor    monitor;
    bus_sequencer sequencer;
    
    uvm_active_passive_enum is_active;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = bus_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
            driver = bus_driver::type_id::create("driver", this);
            sequencer = bus_sequencer::type_id::create("sequencer", this);
        end
        `uvm_info(get_type_name(), $sformatf("Agent built (active=%s)", is_active.name()), UVM_LOW)
    endfunction
endclass

// Test
class test extends uvm_test;
    `uvm_component_utils(test)
    
    bus_agent agent;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        agent = bus_agent::type_id::create("agent", this);
        `uvm_info(get_type_name(), "Test build", UVM_LOW)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

module tb_agent;
    initial begin
        `uvm_info("TOP", "Starting Agent Demo", UVM_LOW)
        run_test("test");
    end
endmodule
