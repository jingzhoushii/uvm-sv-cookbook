// ============================================================================
// @file    : 01_interrupt_agent.sv
// @brief   : 中断代理演示
// @note    : 展示中断验证组件
// ============================================================================

`timescale 1ns/1ps

class irq_txn extends uvm_sequence_item;
    rand bit [3:0] irq_id;
    bit irq;
    `uvm_object_utils_begin(irq_txn)
        `uvm_field_int(irq_id, UVM_ALL_ON)
        `uvm_field_int(irq, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// 中断 Monitor
class irq_monitor extends uvm_monitor;
    `uvm_component_utils(irq_monitor)
    uvm_analysis_port#(irq_txn) ap;
    virtual irq_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if (vif.irq) begin
                irq_txn tr;
                tr = irq_txn::type_id::create("tr");
                tr.irq = 1;
                tr.irq_id = vif.irq_id;
                ap.write(tr);
                $display("[%0t] [MON] IRQ#%0d detected", $time, tr.irq_id);
            end
        end
    endtask
endclass

// 中断 Agent
class irq_agent extends uvm_agent;
    `uvm_component_utils(irq_agent)
    
    irq_monitor mon;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = irq_monitor::type_id::create("mon", this);
    endfunction
endclass

interface irq_if (input bit clk);
    logic [3:0] irq_id;
    logic irq;
endinterface

module tb_interrupt_agent;
    bit clk;
    irq_if ifc (clk);
    
    initial begin clk = 0; forever #5 clk = ~clk; end
    
    initial begin
        $display("========================================");
        $display("  Interrupt Agent Demo");
        $display("========================================");
        
        uvm_config_db#(virtual irq_if)::set(null, "*", "vif", ifc);
        
        irq_agent agent;
        agent = new("agent", null);
        agent.build();
        
        // 模拟中断
        #20 ifc.irq = 1; ifc.irq_id = 4'b0001;
        #10 ifc.irq = 0;
        #20 ifc.irq = 1; ifc.irq_id = 4'b0010;
        #10 ifc.irq = 0;
        
        #200;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_interrupt_agent); end
endmodule
