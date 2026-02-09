// ============================================================
// File: 01_simple_agent.sv
// Description: UVM Agent 示例
// ============================================================

`timescale 1ns/1ps

// --------------------------------------------------------
// 1. 事务定义
// --------------------------------------------------------
class bus_transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        rw;  // 0=read, 1=write
    
    `uvm_object_utils_begin(bus_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "bus_transaction");
        super.new(name);
    endfunction
endclass

// --------------------------------------------------------
// 2. Driver
// --------------------------------------------------------
class bus_driver extends uvm_driver#(bus_transaction);
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
            drive_transaction(req);
            seq_item_port.item_done();
        end
    endtask
    
    protected task drive_transaction(bus_transaction tr);
        `uvm_info(get_type_name(), 
            $sformatf("Drive: addr=0x%0h data=0x%0h rw=%b", 
                     tr.addr, tr.data, tr.rw), UVM_LOW)
        
        // 简化的总线驱动
        vif.drv_cb.awaddr <= tr.addr;
        vif.drv_cb.awvalid <= 1'b1;
        // ... 简化处理
        #10;
        vif.drv_cb.awvalid <= 0;
    endtask
endclass

// --------------------------------------------------------
// 3. Monitor
// --------------------------------------------------------
class bus_monitor extends uvm_monitor;
    `uvm_component_utils(bus_monitor)
    
    virtual bus_if vif;
    uvm_analysis_port#(bus_transaction) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        void'(uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif));
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            @(vif.cb);
            if (vif.cb.awvalid) begin
                bus_transaction tr;
                tr = bus_transaction::type_id::create("tr");
                tr.addr = vif.cb.awaddr;
                `uvm_info(get_type_name(), 
                    $sformatf("Monitor: addr=0x%0h", tr.addr), UVM_LOW)
                ap.write(tr);
            end
        end
    endtask
endclass

// --------------------------------------------------------
// 4. Sequencer
// --------------------------------------------------------
class bus_sequencer extends uvm_sequencer#(bus_transaction);
    `uvm_component_utils(bus_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// --------------------------------------------------------
// 5. Agent (核心)
// --------------------------------------------------------
class bus_agent extends uvm_agent;
    `uvm_component_utils(bus_agent)
    
    bus_driver     driver;
    bus_monitor   monitor;
    bus_sequencer sequencer;
    
    uvm_active_passive_enum is_active;
    virtual bus_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        void'(uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif));
        void'(uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active));
        
        monitor = bus_monitor::type_id::create("monitor", this);
        
        if (is_active == UVM_ACTIVE) begin
            driver = bus_driver::type_id::create("driver", this);
            sequencer = bus_sequencer::type_id::create("sequencer", this);
        end
        
        `uvm_info(get_type_name(), 
            $sformatf("Agent built: is_active=%s", is_active.name()), UVM_LOW)
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        if (is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
endclass

// --------------------------------------------------------
// 6. 简化的总线接口 (用于演示)
// --------------------------------------------------------
interface bus_if (input bit clk, input bit rst_n);
    logic [31:0] awaddr, wdata, araddr, rdata;
    logic awvalid, awready, wvalid, wready, bready, bvalid;
    logic arvalid, arready, rready, rvalid;
    logic [1:0] bresp, rresp;
    logic [3:0] wstrb;
    
    clocking drv_cb @(posedge clk);
        output awaddr, awvalid, wdata, wstrb, wvalid, bready;
        input  awready, wready, bresp, bvalid;
        output araddr, arvalid, rready;
        input  arready, rdata, rresp, rvalid;
    endclocking
    
    clocking mon_cb @(posedge clk);
        input  awaddr, awvalid, wdata, wstrb, wvalid, bready;
        output awready, wready, bresp, bvalid;
        input  araddr, arvalid, rready;
        output arready, rdata, rresp, rvalid;
    endclocking
endinterface

// --------------------------------------------------------
// 7. Test
// --------------------------------------------------------
class test extends uvm_test;
    `uvm_component_utils(test)
    
    bus_agent agent;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        agent = bus_agent::type_id::create("agent", this);
        
        uvm_config_db#(uvm_active_passive_enum)::set(this, "agent", "is_active", UVM_ACTIVE);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

// --------------------------------------------------------
// 8. Top module
// --------------------------------------------------------
module top;
    bit clk, rst_n;
    
    bus_if ifc (clk, rst_n);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end
    
    initial begin
        uvm_config_db#(virtual bus_if)::set(null, "*", "vif", ifc);
        run_test("test");
    end
endmodule
