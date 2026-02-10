// ============================================================================
// @file    : 01_connect_phase.sv
// @brief   : connect_phase 演示
// @note    : 展示 TLM 端口连接
// ============================================================================

`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [31:0] addr;
    `uvm_object_utils_begin(txn)
        `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// Monitor
class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor)
    uvm_analysis_port#(txn) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "connect_phase()", UVM_LOW)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #50;
        phase.drop_objection(this);
    endtask
endclass

// Scoreboard
class my_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_scoreboard)
    uvm_analysis_imp#(txn, my_scoreboard) analysis_export;
    int count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction
    
    virtual function void write(txn tr);
        count++;
        `uvm_info(get_type_name(), 
            $sformatf("Received txn #%0d: addr=0x%0h", count, tr.addr), 
            UVM_LOW)
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "connect_phase()", UVM_LOW)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

// Agent
class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    
    my_monitor mon;
    my_scoreboard sb;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = my_monitor::type_id::create("mon", this);
        sb = my_scoreboard::type_id::create("sb", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        `uvm_info(get_type_name(), "connect_phase()", UVM_LOW)
        
        // 【核心】Monitor -> Scoreboard 连接
        mon.ap.connect(sb.analysis_export);
        
        `uvm_info(get_type_name(), "Connected mon.ap -> sb.analysis_export", 
            UVM_LOW)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

module tb_connect_phase;
    
    initial begin
        $display("========================================");
        $display("  connect_phase Demo");
        $display("========================================");
        $display("");
        
        my_agent agent;
        agent = my_agent::type_id::create("agent", null);
        
        #200;
        
        $display("");
        $display("========================================");
        $display("  connect_phase Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_connect_phase);
    end
    
endmodule
