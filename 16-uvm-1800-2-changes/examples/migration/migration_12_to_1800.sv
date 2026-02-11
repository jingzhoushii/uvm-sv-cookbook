// ============================================================================
// UVM 1.2 → 1800.2 Migration Example
// ============================================================================

`include "uvm_macros.svh"

// ========================================
// BEFORE: UVM 1.2 Style
// ========================================

`ifdef USE_UVM_12

class bus_driver_12 extends uvm_driver#(bus_trans);
    `uvm_component_utils(bus_driver_12)
    
    virtual bus_if vif;
    
    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif))
            `uvm_fatal("CFG", "Cannot get vif")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done();
        end
    endtask
endclass

class bus_agent_12 extends uvm_agent;
    `uvm_component_utils(bus_agent_12)
    
    bus_driver_12 drv;
    uvm_sequencer#(bus_trans) sqr;
    
    function void build_phase(uvm_phase phase);
        sqr = new("sqr", this);
        drv = bus_driver_12::type_id::create("drv", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

`else

// ========================================
// AFTER: UVM 1800.2 Style
// ========================================

class bus_driver_1800 extends uvm_driver#(bus_trans);
    `uvm_component_registry(bus_driver_1800, "bus_driver_1800")
    
    virtual bus_if vif;
    uvm_factory factory;
    
    function void build_phase(uvm_phase phase);
        uvm_coreservice_t cs = uvm_coreservice_t::get();
        factory = cs.get_factory();
        
        if (!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif))
            `uvm_fatal("CFG", "Cannot get vif")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done();
        end
    endtask
endclass

class bus_agent_1800 extends uvm_agent;
    `uvm_component_registry(bus_agent_1800, "bus_agent_1800")
    
    bus_driver_1800 drv;
    uvm_sequencer#(bus_trans) sqr;
    
    virtual function void build_phase(uvm_phase phase);
        uvm_coreservice_t cs = uvm_coreservice_t::get();
        factory = cs.get_factory();
        
        // 使用工厂创建
        sqr = factory.create_sequencer#(bus_trans)("sqr", this);
        drv = factory.create_component#(bus_driver_1800)("drv", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

`endif

module tb_migration;
    `ifdef USE_UVM_12
        initial begin
            `uvm_info("TB", "Running UVM 1.2 style", UVM_LOW)
            run_test("uvm_test");
        end
    `else
        initial begin
            `uvm_info("TB", "Running UVM 1800.2 style", UVM_LOW)
            run_test("uvm_test");
        end
    `endif
endmodule
