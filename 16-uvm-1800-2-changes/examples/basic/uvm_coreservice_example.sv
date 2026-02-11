// ============================================================================
// UVM 1800.2 - Core Service Example
// ============================================================================

`include "uvm_macros.svh"

class my_config extends uvm_object;
    `uvm_object_utils(my_config)
    
    int num_drivers = 4;
    bit enable_coverage = 1;
endclass

class my_driver extends uvm_driver#(bus_trans);
    `uvm_component_registry(my_driver, "my_driver")
    
    int driver_id;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done();
        end
    endtask
    
    virtual protected void drive(bus_trans t);
        // 驱动逻辑
    endtask
endclass

class my_agent extends uvm_agent;
    `uvm_component_registry(my_agent, "my_agent")
    
    my_driver drv;
    uvm_sequencer#(bus_trans) sqr;
    
    virtual function void build_phase(uvm_phase phase);
        // UVM 1800.2: 使用核心服务
        uvm_coreservice_t cs = uvm_coreservice_t::get();
        uvm_factory factory = cs.get_factory();
        
        // 创建组件
        sqr = factory.create_sequencer#(bus_trans)("sqr", this);
        drv = factory.create_component#(my_driver)("drv", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

class my_test extends uvm_test;
    `uvm_component_registry(my_test, "my_test")
    
    my_agent agent;
    
    virtual function void build_phase(uvm_phase phase);
        uvm_coreservice_t cs = uvm_coreservice_t::get();
        uvm_factory factory = cs.get_factory();
        
        agent = factory.create_component#(my_agent)("agent", this);
        
        // 配置
        my_config cfg = new("cfg");
        uvm_resource_db#(my_config)::set("*", "agent_cfg", cfg);
    endfunction
endclass

module tb;
    initial begin
        run_test("my_test");
    end
endmodule
